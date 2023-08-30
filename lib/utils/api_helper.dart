import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import '../constants/strings.dart';
import '../constants/constants.dart';

import '../models/driver.dart';
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

  static Future<ApiResponse<List<GasSstationModel>>> fetchGasStationsData(
      String companyId, String vehicleId, String driverId) async {
    try {
      var response = await http.get(Uri.parse(
          '${ApiConstants.baseUrl}/gas-stations/$companyId/$vehicleId/$driverId'));
      if (response.statusCode == 200) {
        List<GasSstationModel> gasSstations =
            (json.decode(response.body) as List)
                .map((data) => GasSstationModel.fromJson(data))
                .toList();
        return ApiResponse(data: gasSstations);
      }
      return ApiResponse(error: Exception(GasStationStrings.errorGasStations));
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
