import 'dart:async';

import 'package:flutter/material.dart';
import 'package:location/location.dart';

import '../constants/constants.dart';
import '../utils/log.dart';
import 'location_geofence_provider.dart';

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

  late StreamSubscription<GeofenceEventWithId> _geofenceSubscription;
  GeofenceEventWithId? _lastGeofenceEventWithId;
  GeofenceEventWithId? get lastGeofenceEventWithId => _lastGeofenceEventWithId;

  Future<void> initialize() async {
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
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
      _locationData = await location.getLocation();
    } catch (error) {
      _locationError = "${LocationConstants.error}: $error";
    }
    _isLoadingLocation = false;
    notifyListeners();
  }

  void initGeofence() {
    var geofenceStream = LocationGeofenceProvider.getGeofenceStream();
    if (geofenceStream != null) {
      _geofenceSubscription = geofenceStream.listen((eventWithId) {
        _lastGeofenceEventWithId = eventWithId;
        notifyListeners();
      });
    }
  }

  void clearAllGeofencePoints() {
    LocationGeofenceProvider.clearGeofencePoints();
    logger.d('All geofence points cleared');
  }

  void addGeofencePoint(
      String id, double latitude, double longitude, double radius) {
    logger.d('adicionando posto $id');
    LocationGeofenceProvider.startGeofenceService(
        id: id,
        pointedLatitude: latitude,
        pointedLongitude: longitude,
        radiusMeter: radius,
        eventPeriodInSeconds: 10);
  }

  Stream<GeofenceEventWithId>? get geofenceStream =>
      LocationGeofenceProvider.getGeofenceStream();

  @override
  void dispose() {
    _geofenceSubscription.cancel();
    LocationGeofenceProvider.stopGeofenceService();
    super.dispose();
  }
}
