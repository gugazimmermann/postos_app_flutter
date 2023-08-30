import 'signature.dart';
import 'vehicle.dart';
import 'driver.dart';

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
  final String active;
  final SignatureModel signatures;
  final VehicleModel vehicle;
  final DriverModel driver;

  GasSstationModel(
      {required this.id,
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
      required this.driver});

  factory GasSstationModel.fromJson(Map<String, dynamic> json) {
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
      active: json['active'],
      signatures: SignatureModel.fromJson(json['signatures']),
      vehicle: VehicleModel.fromJson(json['vehicle']),
      driver: DriverModel.fromJson(json['driver']),
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
      'signatures': signatures.toJson(),
      'vehicle': vehicle.toJson(),
      'driver': driver.toJson(),
    };
  }
}
