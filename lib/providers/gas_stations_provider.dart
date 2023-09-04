import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

import '../utils/log.dart';
import 'location_provider.dart';

import '../models/driver.dart';
import '../models/gas_station.dart';
import '../models/vehicle.dart';

import '../utils/api_helper.dart';

class GasStationsProvider with ChangeNotifier {
  final errorNotifier = ValueNotifier<String?>(null);
  final isLoading = ValueNotifier<bool>(false);
  List<GasStationModel>? _gasStations;
  List<GasStationModel>? get gasStations => _gasStations;

  final LocationProvider _locationProvider;

  GasStationsProvider(this._locationProvider) {
    _locationProvider.addListener(onLocationChanged);
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

  void onLocationChanged() {
    logger.t(_locationProvider.currentLocation);
    if (_gasStations != null && _locationProvider.currentLocation != null) {
      for (var gasStation in _gasStations!) {
        const distance = Distance();
        var distanceInMeters = distance.distance(
            LatLng(_locationProvider.currentLocation!.latitude!,
                _locationProvider.currentLocation!.longitude!),
            LatLng(gasStation.latitudeAsDouble, gasStation.longitudeAsDouble));
        gasStation.distance = distanceInMeters / 1000;
      }
      _gasStations!.sort((a, b) => a.distance!.compareTo(b.distance!));
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _locationProvider.removeListener(onLocationChanged);
    super.dispose();
  }
}
