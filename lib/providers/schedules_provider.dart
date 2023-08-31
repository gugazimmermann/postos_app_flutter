import 'package:flutter/material.dart';

import '../models/driver.dart';
import '../models/schedule.dart';
import '../models/vehicle.dart';
import '../utils/api_helper.dart';

class SchedulesProvider with ChangeNotifier {
  final errorNotifier = ValueNotifier<String?>(null);
  List<ScheduleModel>? _schedules;
  List<ScheduleModel>? get schedules => _schedules;

  Future<void> fetchGasStationsData(
      DriverModel? selectedDriver, VehicleModel? selectedVehicle) async {
    if (selectedVehicle != null && selectedDriver != null) {
      var response = await ApiHelper.fetchSchedulesData(
          selectedDriver.company.id, selectedVehicle.id);
      if (response.data != null) {
        _schedules = response.data!;
        notifyListeners();
      } else {
        errorNotifier.value = response.error?.toString();
      }
    }
  }
}
