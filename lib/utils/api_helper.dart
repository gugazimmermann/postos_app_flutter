import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import '../constants/strings.dart';
import '../constants/constants.dart';

import '../models/driver.dart';
import '../models/schedule.dart';
import '../models/vehicle.dart';
import '../models/gas_station.dart';

import '../widgets/custom_flushbar_error.dart';

class ApiResponse<T> {
  final T? data;
  final Exception? error;

  ApiResponse({this.data, this.error});
}

class ApiHelper {
  static Future<ApiResponse<List<DriverModel>>> fetchDriverData(
      String cpf) async {
    try {
      var response =
          await http.get(Uri.parse('${ApiConstants.baseUrl}/driver/$cpf'));
      if (response.statusCode == 200) {
        List<DriverModel> drivers = (json.decode(response.body) as List)
            .map((data) => DriverModel.fromJson(data))
            .toList();
        return ApiResponse(data: drivers);
      }
      return ApiResponse(error: Exception(SignInStrings.errorDocument));
    } catch (e) {
      return ApiResponse(error: Exception(e.toString()));
    }
  }

  static Future<ApiResponse<List<VehicleModel>>> fetchVehiclesData(
      String companyId, String driverId) async {
    try {
      var response = await http.get(
          Uri.parse('${ApiConstants.baseUrl}/vehicles/$companyId/$driverId'));
      if (response.statusCode == 200) {
        List<VehicleModel> vehicles = (json.decode(response.body) as List)
            .map((data) => VehicleModel.fromJson(data))
            .toList();
        return ApiResponse(data: vehicles);
      }
      return ApiResponse(error: Exception(SignInStrings.errorVehicle));
    } catch (e) {
      return ApiResponse(error: Exception(e.toString()));
    }
  }

  static Future<ApiResponse<List<GasStationModel>>> fetchGasStationsData(
      String companyId, String vehicleId, String driverId) async {
    try {
      var response = await http.get(Uri.parse(
          '${ApiConstants.baseUrl}/gas-stations/$companyId/$vehicleId/$driverId'));
      if (response.statusCode == 200) {
        List<GasStationModel> gasStations = (json.decode(response.body) as List)
            .map((data) => GasStationModel.fromJson(data))
            .toList();
        return ApiResponse(data: gasStations);
      }
      return ApiResponse(error: Exception(GasStationStrings.errorGasStations));
    } catch (e) {
      return ApiResponse(error: Exception(e.toString()));
    }
  }

  static Future<ApiResponse<List<ScheduleModel>>> fetchSchedulesData(
      String companyId, String vehicleId) async {
    try {
      var response = await http.get(
          Uri.parse('${ApiConstants.baseUrl}/schedules/$companyId/$vehicleId'));
      if (response.statusCode == 200) {
        List<ScheduleModel> schedules = (json.decode(response.body) as List)
            .map((data) => ScheduleModel.fromJson(data))
            .toList();
        return ApiResponse(data: schedules);
      }
      return ApiResponse(error: Exception(SchedulesStrings.errorSchedule));
    } catch (e) {
      return ApiResponse(error: Exception(e.toString()));
    }
  }

  static Future<ApiResponse<void>> sendFCMTokenAndTimestamp(
      String driverID, String fcmToken, DateTime timestamp) async {
    try {
      var response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}/driver'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'driverID': driverID,
          'fcmToken': fcmToken,
          'timestamp': timestamp.toIso8601String(),
        }),
      );
      if (response.statusCode == 200) {
        return ApiResponse(data: null);
      } else {
        return ApiResponse(error: Exception('Error while sending data'));
      }
    } catch (e) {
      return ApiResponse(error: Exception(e.toString()));
    }
  }

  static void handleApiError(Exception? error, BuildContext context) {
    if (error == null) return;
    if (error is SocketException) {
      customFlushBarError(ApiConstants.errorNetwork, context);
    } else if (error.toString().contains(SignInStrings.errorDocument)) {
      customFlushBarError(SignInStrings.errorDocument, context);
    } else if (error.toString().contains(SignInStrings.errorVehicle)) {
      customFlushBarError(SignInStrings.errorVehicle, context);
    } else {
      customFlushBarError(ApiConstants.errorApi, context);
    }
  }
}
