import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/driver.dart';
import '../models/vehicle.dart';

class PreferencesHelper {
  static const driverDataKey = "driver_data";
  static const vehicleDataKey = "vehicle_data";
  static const driverListKey = "driver_list";
  static const vehicleListKey = "vehicle_list";
  static const unreadNotificationsKey = "unread_notifications";
  static const backgroundLocationDeniedKey = "background_location_denied";

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

  static Future<int> getNotificationsCount() async {
    final prefs = await _getPrefs();
    return prefs.getInt(unreadNotificationsKey) ?? 0;
  }

  static Future<void> incrementNotificationsCount() async {
    final prefs = await _getPrefs();
    int currentCount = prefs.getInt(unreadNotificationsKey) ?? 0;
    prefs.setInt(unreadNotificationsKey, currentCount + 1);
  }

  static Future<void> clearNotificationsCount() async {
    final prefs = await _getPrefs();
    prefs.remove(unreadNotificationsKey);
  }

  static Future<void> saveLastGasStationNotificationTimestamp(
      String gasStationID, String vehiclePlate, int timestamp) async {
    final prefs = await _getPrefs();
    final key = 'lastGasStationNotifiedAt_${gasStationID}_$vehiclePlate';
    prefs.setInt(key, timestamp);
  }

  static Future<int?> getLastGasStationNotificationTimestamp(
      String gasStationID, String vehiclePlate) async {
    final prefs = await _getPrefs();
    final key = 'lastGasStationNotifiedAt_${gasStationID}_$vehiclePlate';
    return prefs.getInt(key);
  }

  static Future<void> setBackgroundLocationDenied(bool value) async {
    final prefs = await _getPrefs();
    prefs.setBool(backgroundLocationDeniedKey, value);
  }

  static Future<bool?> getBackgroundLocationDenied() async {
    final prefs = await _getPrefs();
    return prefs.getBool(backgroundLocationDeniedKey);
  }
}
