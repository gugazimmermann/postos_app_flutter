import 'package:flutter/material.dart';

import '../models/driver.dart';
import '../models/gas_station.dart';
import '../models/vehicle.dart';
import '../utils/api_helper.dart';

class GasStationProvider with ChangeNotifier {
  final errorNotifier = ValueNotifier<String?>(null);
  List<GasStationModel>? _gasStations;
  List<GasStationModel>? get gasStations => _gasStations;

  Future<void> fetchGasStationsData(
      VehicleModel? selectedVehicle, DriverModel? selectedDriver) async {
    if (selectedVehicle != null && selectedDriver != null) {
      var response = await ApiHelper.fetchGasStationsData(
          selectedDriver.company.id, selectedVehicle.id, selectedDriver.id);
      if (response.data != null) {
        _gasStations = response.data!;
        notifyListeners();
      } else {
        errorNotifier.value = response.error?.toString();
      }
    }
  }
}
