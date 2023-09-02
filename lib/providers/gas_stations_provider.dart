import 'package:flutter/material.dart';

import 'location_provider.dart';

import '../models/driver.dart';
import '../models/gas_station.dart';
import '../models/vehicle.dart';

import '../utils/api_helper.dart';
import '../utils/haversine.dart';

class GasStationsProvider with ChangeNotifier {
  final errorNotifier = ValueNotifier<String?>(null);
  final isLoading = ValueNotifier<bool>(false);
  List<GasStationModel>? _gasStations;
  List<GasStationModel>? get gasStations => _gasStations;

  final LocationProvider _locationProvider;

  GasStationsProvider(this._locationProvider) {
    _locationProvider.addListener(_onLocationChanged);
  }

  Future<void> fetchGasStationsData(
      VehicleModel? selectedVehicle, DriverModel? selectedDriver) async {
    if (selectedVehicle != null && selectedDriver != null) {
      isLoading.value = true;
      var response = await ApiHelper.fetchGasStationsData(
          selectedDriver.company.id, selectedVehicle.id, selectedDriver.id);
      if (response.data != null) {
        _gasStations = response.data!;
        notifyListeners();
      } else {
        errorNotifier.value = response.error?.toString();
      }
      isLoading.value = false;
    }
  }

  void _onLocationChanged() {
    if (_gasStations != null && _locationProvider.currentLocation != null) {
      for (var gasStation in _gasStations!) {
        gasStation.distance = haversineDistance(
          _locationProvider.currentLocation!.latitude!,
          _locationProvider.currentLocation!.longitude!,
          gasStation.latitudeAsDouble,
          gasStation.longitudeAsDouble,
        );
      }
      _gasStations!.sort((a, b) => a.distance!.compareTo(b.distance!));
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _locationProvider.removeListener(_onLocationChanged);
    super.dispose();
  }
}
