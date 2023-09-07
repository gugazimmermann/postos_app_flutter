import 'package:flutter/material.dart';

import '../models/driver.dart';
import '../models/schedule.dart';
import '../models/vehicle.dart';

import '../utils/api_helper.dart';

class SchedulesProvider with ChangeNotifier {
  final errorNotifier = ValueNotifier<String?>(null);
  final isLoading = ValueNotifier<bool>(false);
  final _schedules = ValueNotifier<List<ScheduleModel>?>(null);

  ValueNotifier<List<ScheduleModel>?> get schedulesNotifier => _schedules;
  List<ScheduleModel>? get schedules => _schedules.value;

  Future<void> fetchSchedulesData(
      DriverModel? selectedDriver, VehicleModel? selectedVehicle) async {
    if (selectedVehicle != null && selectedDriver != null) {
      isLoading.value = true;
      var response = await ApiHelper.fetchSchedulesData(
          selectedDriver.company.id, selectedVehicle.id);
      if (response.data != null) {
        response.data!.sort((a, b) {
          DateTime dateA = DateTime.parse(a.date);
          DateTime dateB = DateTime.parse(b.date);
          return dateA.compareTo(dateB);
        });
        _schedules.value = response.data;
      } else {
        errorNotifier.value = response.error?.toString();
      }
      isLoading.value = false;
    }
  }
}
