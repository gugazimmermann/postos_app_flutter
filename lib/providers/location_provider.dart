import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

import '../constants/constants.dart';
import '../utils/geofencing.dart';
import '../utils/shared_preferences.dart';
import '../utils/log.dart';

class LocationProvider with ChangeNotifier {
  Location location = Location();
  bool? _serviceEnabled;
  PermissionStatus? _permissionGranted;
  LocationData? _locationData;
  String? _locationError;

  bool _isLoadingLocation = true;
  bool get isLoadingLocation => _isLoadingLocation;
  LocationData? get currentLocation => _locationData;
  String? get locationError => _locationError;
  StreamSubscription<LocationData>? _locationChangeSubscription;

  final StreamController<GeofenceEventWithId> _geofenceController =
      StreamController<GeofenceEventWithId>.broadcast();
  final Map<String, GeofencePoint> _geofencePoints = {};
  late StreamSubscription<GeofenceEventWithId> _geofenceSubscription;
  GeofenceEventWithId? _lastGeofenceEventWithId;
  GeofenceEventWithId? get lastGeofenceEventWithId => _lastGeofenceEventWithId;

  Future<void> initialize() async {
    try {
      _permissionGranted = await location.hasPermission();
      if (_permissionGranted == PermissionStatus.denied) {
        _permissionGranted = await location.requestPermission();
      }
      await location.enableBackgroundMode(enable: true);
    } catch (e) {
      if (e is PlatformException && e.code == 'PERMISSION_DENIED') {
        await PreferencesHelper.setBackgroundLocationDenied(true);
      }
    }
  }

  Future<void> getUserLocation() async {
    _isLoadingLocation = true;
    notifyListeners();
    try {
      _serviceEnabled = await location.serviceEnabled();
      if (_serviceEnabled != true) {
        _serviceEnabled = await location.requestService();
        if (_serviceEnabled != true) {
          _locationError = LocationConstants.disabled;
          _isLoadingLocation = false;
          notifyListeners();
          return;
        }
      }
      _permissionGranted = await location.hasPermission();
      if (_permissionGranted == PermissionStatus.denied) {
        _permissionGranted = await location.requestPermission();
        if (_permissionGranted == null ||
            _permissionGranted != PermissionStatus.granted) {
          _locationError = LocationConstants.permissionDenied;
          _isLoadingLocation = false;
          notifyListeners();
          return;
        }
      }
      location.changeSettings(accuracy: LocationAccuracy.high);
      _locationData = await location.getLocation();
      _startLocationListening();
    } catch (error) {
      _locationError = "${LocationConstants.error}: $error";
    }
    _isLoadingLocation = false;
    notifyListeners();
  }

  void _startLocationListening() {
    _locationChangeSubscription ??=
        location.onLocationChanged.listen((LocationData actualLocation) {
      _locationData = actualLocation;
      if (_locationData != null) {
        _checkGeofence(
            LatLng(_locationData!.latitude!, _locationData!.longitude!));
      }
      notifyListeners();
      _locationChangeSubscription
          ?.pause(Future.delayed(const Duration(seconds: 10)));
    });
  }

  void initGeofence() {
    _geofenceSubscription = _geofenceController.stream.listen((eventWithId) {
      _lastGeofenceEventWithId = eventWithId;
      notifyListeners();
    });
  }

  void clearAllGeofencePoints() {
    _geofencePoints.clear();
    logger.i("All geofence points cleared");
  }

  void addGeofencePoint(
      String id, double latitude, double longitude, double radius) {
    _geofencePoints[id] = GeofencePoint(latitude, longitude, radius);
    logger.i(
        "Added geofence point for ID: $id at ($latitude, $longitude) with radius: $radius meters.");
  }

  void _checkGeofence(LatLng currentPosition) {
    for (var id in _geofencePoints.keys) {
      const distance = Distance();
      double distanceInMeters = distance.distance(
          LatLng(_geofencePoints[id]!.latitude, _geofencePoints[id]!.longitude),
          currentPosition);
      logger.i("checkGeofence distance: $distanceInMeters");
      if (distanceInMeters <= _geofencePoints[id]!.radius) {
        _geofenceController.add(GeofenceEventWithId(GeofenceEvent.enter, id));
      }
    }
  }

  Stream<GeofenceEventWithId>? get geofenceStream => _geofenceController.stream;

  @override
  void dispose() {
    _geofenceSubscription.cancel();
    _locationChangeSubscription?.cancel();
    _geofenceController.close();
    super.dispose();
  }
}
