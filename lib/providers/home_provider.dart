import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';

import '../constants/constants.dart';
import '../models/driver.dart';
import '../models/vehicle.dart';
import '../utils/log.dart';
import '../utils/api_helper.dart';
import '../utils/shared_preferences.dart';
import '../utils/is_valid_cpf.dart';

class HomeProvider with ChangeNotifier {
  final cpfController = MaskedTextController(mask: '000.000.000-00');

  List<DriverModel>? _driverList;
  DriverModel? _selectedDriver;
  List<VehicleModel>? _vehiclesList;
  VehicleModel? _selectedVehicle;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  List<DriverModel>? get driverList => _driverList;
  DriverModel? get selectedDriver => _selectedDriver;
  List<VehicleModel>? get vehiclesList => _vehiclesList;
  VehicleModel? get selectedVehicle => _selectedVehicle;

  final errorNotifier = ValueNotifier<String?>(null);

  HomeProvider() {
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    _isLoading = true;
    notifyListeners();

    dynamic savedDriverList =
        await PreferencesHelper.getData(PreferencesHelper.driverListKey);
    dynamic savedDriverData =
        await PreferencesHelper.getData(PreferencesHelper.driverDataKey);
    dynamic savedVehiclesList =
        await PreferencesHelper.getData(PreferencesHelper.vehicleListKey);
    dynamic savedVehicleData =
        await PreferencesHelper.getData(PreferencesHelper.vehicleDataKey);

    if (savedDriverList != null) {
      _driverList = (savedDriverList as List)
          .map((driver) => DriverModel.fromJson(driver))
          .toList();
      logger.d(
          'Driver List: ${_driverList?.map((driver) => driver.toJson()).toList()}');
    }

    if (savedDriverData != null) {
      _selectedDriver = DriverModel.fromJson(savedDriverData);
      logger.d('Driver: ${_selectedDriver?.toJson()}');
    }

    if (savedVehiclesList != null) {
      _vehiclesList = (savedVehiclesList as List)
          .map((vehicle) => VehicleModel.fromJson(vehicle))
          .toList();
      logger.d(
          'Vehicle List: ${_vehiclesList?.map((vehicle) => vehicle.toJson()).toList()}');
    }

    if (savedVehicleData != null) {
      _selectedVehicle = VehicleModel.fromJson(savedVehicleData);
      logger.d('Vehicle: ${_selectedVehicle?.toJson()}');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> _resetPreferences() async {
    await PreferencesHelper.removeData(PreferencesHelper.driverDataKey);
    await PreferencesHelper.removeData(PreferencesHelper.driverListKey);
    await PreferencesHelper.removeData(PreferencesHelper.vehicleDataKey);
    await PreferencesHelper.removeData(PreferencesHelper.vehicleListKey);
  }

  void resetSelection() {
    _vehiclesList = null;
    _driverList = null;
    _selectedDriver = null;
    _selectedVehicle = null;
    cpfController.clear();
    _resetPreferences();
    notifyListeners();
  }

  Future<void> fetchDriver() async {
    if (!isValidCPF(cpfController.text)) {
      errorNotifier.value = ApiConstants.errorDocumentNull;
      return;
    }
    _isLoading = true;
    notifyListeners();
    var response = await ApiHelper.fetchDriverData(cpfController.text);
    if (response.data != null) {
      _driverList = response.data;
      await PreferencesHelper.saveData(
          PreferencesHelper.driverListKey, _driverList);
      _isLoading = false;
      notifyListeners();
    } else {
      _isLoading = false;
      errorNotifier.value = response.error?.toString();
    }
  }

  Future<void> fetchVehicles() async {
    if (_selectedDriver == null) return;
    _isLoading = true;
    notifyListeners();
    var response = await ApiHelper.fetchVehiclesData(
        _selectedDriver!.company.id, _selectedDriver!.id);
    if (response.data != null) {
      _vehiclesList = response.data;
      await PreferencesHelper.saveData(
          PreferencesHelper.vehicleListKey, _vehiclesList);
      _isLoading = false;
      notifyListeners();
    } else {
      _isLoading = false;
      errorNotifier.value = response.error?.toString();
    }
  }

  void selectDriver(DriverModel driver) {
    _selectedDriver = driver;
    notifyListeners();
    fetchVehicles();
  }

  void selectVehicle(VehicleModel vehicle) {
    _selectedVehicle = vehicle;
    notifyListeners();
  }
}
