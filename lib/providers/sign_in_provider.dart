import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:touch_sistemas_postos/providers/analytics_provider.dart';

import '../models/driver.dart';
import '../models/vehicle.dart';

import '../constants/strings.dart';

import '../utils/api_helper.dart';
import '../utils/is_valid_cpf.dart';
import '../utils/shared_preferences.dart';

class SignInProvider with ChangeNotifier {
  final AnalyticsProvider _analyticsProvider;

  final cpfController = MaskedTextController(mask: '000.000.000-00');
  final errorNotifier = ValueNotifier<String?>(null);

  List<DriverModel>? _driverList;
  DriverModel? _selectedDriver;
  List<VehicleModel>? _vehiclesList;
  VehicleModel? _selectedVehicle;
  bool _isUserConnected = false;

  List<DriverModel>? get driverList => _driverList;
  DriverModel? get selectedDriver => _selectedDriver;
  List<VehicleModel>? get vehiclesList => _vehiclesList;
  VehicleModel? get selectedVehicle => _selectedVehicle;
  bool get isUserConnected => _isUserConnected;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  SignInProvider(this._analyticsProvider) {
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
    }
    if (savedDriverData != null) {
      _selectedDriver = DriverModel.fromJson(savedDriverData);
    }
    if (savedVehiclesList != null) {
      _vehiclesList = (savedVehiclesList as List)
          .map((vehicle) => VehicleModel.fromJson(vehicle))
          .toList();
    }
    if (savedVehicleData != null) {
      _selectedVehicle = VehicleModel.fromJson(savedVehicleData);
    }
    _isUserConnected = savedDriverList != null &&
        savedDriverData != null &&
        savedVehicleData != null &&
        savedDriverList != null;
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
    _isUserConnected = false;
    notifyListeners();
  }

  Future<void> fetchDriver() async {
    if (!isValidCPF(cpfController.text)) {
      errorNotifier.value = SignInStrings.errorDocumentNull;
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
      notifyListeners();
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

  Future<void> selectDriver(DriverModel driver) async {
    _selectedDriver = driver;
    await PreferencesHelper.saveData(
        PreferencesHelper.driverDataKey, _selectedDriver);
    notifyListeners();
    fetchVehicles();
  }

  Future<void> selectVehicle(VehicleModel vehicle) async {
    _selectedVehicle = vehicle;
    await PreferencesHelper.saveData(
        PreferencesHelper.vehicleDataKey, _selectedVehicle);
    _isUserConnected = true;
    notifyListeners();
    _analyticsProvider.logLogin(_selectedDriver, _selectedVehicle);
  }

  Future<void> removeVehicles() async {
    _selectedVehicle = null;
    _vehiclesList = null;
    await PreferencesHelper.removeData(PreferencesHelper.vehicleDataKey);
    await PreferencesHelper.removeData(PreferencesHelper.vehicleListKey);
  }
}
