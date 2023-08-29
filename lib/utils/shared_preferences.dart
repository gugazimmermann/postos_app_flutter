import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/driver.dart';
import '../models/vehicle.dart';

class PreferencesHelper {
  static const driverDataKey = "driver_data";
  static const vehicleDataKey = "vehicle_data";
  static const driverListKey = "driver_list";
  static const vehicleListKey = "vehicle_list";

  static Future<SharedPreferences> _getPrefs() async {
    return await SharedPreferences.getInstance();
  }

  static Future<void> saveData(String key, dynamic data) async {
    final prefs = await _getPrefs();
    String jsonData;

    if (data is DriverModel) {
      jsonData = json.encode(data.toJson());
    } else if (data is List<DriverModel>) {
      jsonData = json.encode(data.map((e) => e.toJson()).toList());
    } else if (data is VehicleModel) {
      jsonData = json.encode(data.toJson());
    } else if (data is List<VehicleModel>) {
      jsonData = json.encode(data.map((e) => e.toJson()).toList());
    } else {
      throw Exception("Unknow Type!");
    }

    prefs.setString(key, jsonData);
  }

  static Future<dynamic> getData(String key) async {
    final prefs = await _getPrefs();
    String? data = prefs.getString(key);
    if (data != null) {
      return json.decode(data);
    }
    return null;
  }

  static Future<void> removeData(String key) async {
    final prefs = await _getPrefs();
    prefs.remove(key);
  }
}
