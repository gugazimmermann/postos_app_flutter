import 'package:flutter/material.dart';

import 'gas_stations_provider.dart';
import 'location_provider.dart';
import 'sign_in_provider.dart';

class AppProvider with ChangeNotifier {
  final SignInProvider _signInProvider;
  final LocationProvider _locationProvider;
  final GasStationProvider _gasStationProvider;

  AppProvider()
      : _signInProvider = SignInProvider(),
        _locationProvider = LocationProvider(),
        _gasStationProvider = GasStationProvider() {
    _signInProvider.addListener(_handleSignInProviderChange);
    _locationProvider.addListener(_handleLocationProviderChange);
    _gasStationProvider.addListener(_handleGasStationProviderChange);
  }

  void _handleSignInProviderChange() {
    notifyListeners();
  }

  void _handleLocationProviderChange() {
    notifyListeners();
  }

  void _handleGasStationProviderChange() {
    notifyListeners();
  }

  @override
  void dispose() {
    _signInProvider.removeListener(_handleSignInProviderChange);
    _locationProvider.removeListener(_handleLocationProviderChange);
    _gasStationProvider.removeListener(_handleGasStationProviderChange);
    super.dispose();
  }

  SignInProvider get signInProvider => _signInProvider;
  LocationProvider get locationProvider => _locationProvider;
  GasStationProvider get gasStationProvider => _gasStationProvider;
}
