import 'signature.dart';
import 'gas_station_vehicle.dart';
import 'gas_station_driver.dart';
import 'gas_station_fuel_prices.dart';
import 'gas_station_open_hours.dart';

class GasStationModel {
  final String id;
  final String name;
  final String phone;
  final String email;
  final String address;
  final String city;
  final String state;
  final String latitude;
  final String longitude;
  final bool active;
  final List<SignatureModel> signatures;
  final GasStationVehicleModel vehicle;
  final GasStationDriverModel driver;
  final List<GasStationFuelPricesModel> fuelPrices;
  final List<GasStationOpenHoursModel> openHours;
  double? distance;

  GasStationModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.address,
    required this.city,
    required this.state,
    required this.latitude,
    required this.longitude,
    required this.active,
    required this.signatures,
    required this.vehicle,
    required this.driver,
    required this.fuelPrices,
    required this.openHours,
    this.distance,
  });

  double get latitudeAsDouble => double.parse(latitude);
  double get longitudeAsDouble => double.parse(longitude);

  factory GasStationModel.fromJson(Map<String, dynamic> json) {
    List<SignatureModel> signaturesList = (json['signatures'] as List)
        .map((item) => SignatureModel.fromJson(item))
        .toList();
    List<GasStationFuelPricesModel> fuelPricesList =
        (json['fuelPrices'] as List)
            .map((item) => GasStationFuelPricesModel.fromJson(item))
            .toList();
    List<GasStationOpenHoursModel> openHoursList = (json['openHours'] as List)
        .map((item) => GasStationOpenHoursModel.fromJson(item))
        .toList();

    return GasStationModel(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      email: json['email'],
      address: json['address'],
      city: json['city'],
      state: json['state'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      active: json['active'] is bool ? json['active'] : false,
      signatures: signaturesList,
      vehicle: GasStationVehicleModel.fromJson(json['vehicle']),
      driver: GasStationDriverModel.fromJson(json['driver']),
      fuelPrices: fuelPricesList,
      openHours: openHoursList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'address': address,
      'city': city,
      'state': state,
      'latitude': latitude,
      'longitude': longitude,
      'active': active,
      'signatures': signatures.map((item) => item.toJson()).toList(),
      'vehicle': vehicle.toJson(),
      'driver': driver.toJson(),
      'fuelPrices': fuelPrices.map((item) => item.toJson()).toList(),
      'openHours': openHours.map((item) => item.toJson()).toList(),
    };
  }
}
