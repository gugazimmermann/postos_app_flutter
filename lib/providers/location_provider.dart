import 'package:flutter/material.dart';
import 'package:location/location.dart';

import '../constants/constants.dart';
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

  LocationProvider() {
    _initLocation();
  }

  Future<void> _initLocation() async {
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
      logger.d('location: $_locationData');
    } catch (error) {
      _locationError = "${LocationConstants.error}: $error";
    }
    _isLoadingLocation = false;
    notifyListeners();
  }
}
