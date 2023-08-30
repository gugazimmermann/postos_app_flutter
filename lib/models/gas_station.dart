import 'signature.dart';
import 'gas_station_vehicle.dart';
import 'gas_station_driver.dart';

class GasSstationModel {
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
  final GasSstationVehicleModel vehicle;
  final GasSstationDriverModel driver;
  double? distance;

  GasSstationModel({
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
    this.distance,
  });

  double get latitudeAsDouble => double.parse(latitude);
  double get longitudeAsDouble => double.parse(longitude);

  factory GasSstationModel.fromJson(Map<String, dynamic> json) {
    List<SignatureModel> signaturesList = (json['signatures'] as List)
        .map((item) => SignatureModel.fromJson(item))
        .toList();

    return GasSstationModel(
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
      vehicle: GasSstationVehicleModel.fromJson(json['vehicle']),
      driver: GasSstationDriverModel.fromJson(json['driver']),
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
      'vehicle': vehicle,
      'driver': driver,
    };
  }
}