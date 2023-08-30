import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:postos_flutter_app/constants/constants.dart';

import '../constants/strings.dart';

import '../models/driver.dart';
import '../models/vehicle.dart';
import '../models/gas_station.dart';

import '../utils/log.dart';
import '../utils/api_helper.dart';
import '../utils/shared_preferences.dart';
import '../utils/is_valid_cpf.dart';

class AppProvider with ChangeNotifier {
  Location location = Location();
  bool? _serviceEnabled;
  PermissionStatus? _permissionGranted;
  LocationData? _locationData;
  String? _locationError;

  final cpfController = MaskedTextController(mask: '000.000.000-00');

  List<DriverModel>? _driverList;
  DriverModel? _selectedDriver;
  List<VehicleModel>? _vehiclesList;
  VehicleModel? _selectedVehicle;
  List<GasSstationModel>? _gasStations;

  List<DriverModel>? get driverList => _driverList;
  DriverModel? get selectedDriver => _selectedDriver;
  List<VehicleModel>? get vehiclesList => _vehiclesList;
  VehicleModel? get selectedVehicle => _selectedVehicle;
  List<GasSstationModel>? get gasStations => _gasStations;

  bool _isLoadingLocation = true;
  bool get isLoadingLocation => _isLoadingLocation;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  final errorNotifier = ValueNotifier<String?>(null);

  AppProvider() {
    _initLocation();
    _loadInitialData();
  }

  Future<void> _initLocation() async {
    _isLoadingLocation = true;
    notifyListeners();
    try {
      _serviceEnabled = await location.serviceEnabled();
      if (_serviceEnabled != true) {
        _serviceEnabled = await location.requestService();
        if (_serviceEnabled != true) {
          _locationError = LocationConstants.disabled;
          _isLoadingLocation = false;
          notifyListeners();
          return;
        }
      }
      _permissionGranted = await location.hasPermission();
      if (_permissionGranted == PermissionStatus.denied) {
        _permissionGranted = await location.requestPermission();
        if (_permissionGranted == null ||
            _permissionGranted != PermissionStatus.granted) {
          _locationError = LocationConstants.permissionDenied;
          _isLoadingLocation = false;
          notifyListeners();
          return;
        }
      }
      _locationData = await location.getLocation();
      logger.d('location: $_locationData');
    } catch (error) {
      _locationError = "${LocationConstants.error}: $error";
    }
    _isLoadingLocation = false;
    notifyListeners();
  }

  LocationData? get currentLocation => _locationData;
  String? get locationError => _locationError;

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
      logger.t(
          'Driver List: ${_driverList?.map((driver) => driver.toJson()).toList()}');
    }

    if (savedDriverData != null) {
      _selectedDriver = DriverModel.fromJson(savedDriverData);
      logger.t('Driver: ${_selectedDriver?.toJson()}');
    }

    if (savedVehiclesList != null) {
      _vehiclesList = (savedVehiclesList as List)
          .map((vehicle) => VehicleModel.fromJson(vehicle))
          .toList();
      logger.t(
          'Vehicle List: ${_vehiclesList?.map((vehicle) => vehicle.toJson()).toList()}');
    }

    if (savedVehicleData != null) {
      _selectedVehicle = VehicleModel.fromJson(savedVehicleData);
      logger.t('Vehicle: ${_selectedVehicle?.toJson()}');
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
    notifyListeners();
  }

  Future<void> fetchGasStationsData() async {
    if (selectedVehicle != null && selectedDriver != null) {
      var response = await ApiHelper.fetchGasStationsData(
          selectedDriver!.company.id, selectedVehicle!.id, selectedDriver!.id);
      if (response.data != null) {
        _gasStations = response.data!;
        notifyListeners();
      } else {
        errorNotifier.value = response.error?.toString();
      }
    }
  }
}
