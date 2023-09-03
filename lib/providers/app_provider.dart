import 'package:flutter/material.dart';

import 'notification_provider.dart';
import 'location_provider.dart';
import 'sign_in_provider.dart';
import 'gas_stations_provider.dart';
import 'schedules_provider.dart';

class AppProvider with ChangeNotifier {
  final NotificationProvider _notificationProvider;
  final LocationProvider _locationProvider;
  final SignInProvider _signInProvider;
  final SchedulesProvider _schedulesProvider;
  late GasStationsProvider _gasStationsProvider;

  AppProvider()
      : _notificationProvider = NotificationProvider(),
        _locationProvider = LocationProvider(),
        _signInProvider = SignInProvider(),
        _schedulesProvider = SchedulesProvider() {
    _initializePermissions();
    _locationProvider.addListener(_handleLocationProviderChange);
    _signInProvider.addListener(_handleSignInProviderChange);
    _schedulesProvider.addListener(_handleSchedulesProviderChange);
    _gasStationsProvider = GasStationsProvider(_locationProvider);
    _gasStationsProvider.addListener(_handleGasStationsProviderChange);
  }

  Future<void> _initializePermissions() async {
    await _notificationProvider.initialize();
    await _locationProvider.initialize();
  }

  void _handleSignInProviderChange() {
    notifyListeners();
  }

  void _handleLocationProviderChange() {
    notifyListeners();
  }

  void _handleGasStationsProviderChange() {
    notifyListeners();
  }

  void _handleSchedulesProviderChange() {
    notifyListeners();
  }

  @override
  void dispose() {
    _signInProvider.removeListener(_handleSignInProviderChange);
    _locationProvider.removeListener(_handleLocationProviderChange);
    _gasStationsProvider.removeListener(_handleGasStationsProviderChange);
    _schedulesProvider.removeListener(_handleSchedulesProviderChange);
    super.dispose();
  }

  Future<void> updateGasStationsAndSchedules() async {
    await gasStationsProvider.fetchGasStationsData(
        signInProvider.selectedVehicle, signInProvider.selectedDriver);
    await schedulesProvider.fetchSchedulesData(
        signInProvider.selectedDriver, signInProvider.selectedVehicle);
    gasStationsProvider.onLocationChanged();
  }

  NotificationProvider get notificationProvider => _notificationProvider;
  LocationProvider get locationProvider => _locationProvider;
  SignInProvider get signInProvider => _signInProvider;
  GasStationsProvider get gasStationsProvider => _gasStationsProvider;
  SchedulesProvider get schedulesProvider => _schedulesProvider;
}
