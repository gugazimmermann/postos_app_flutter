import 'company.dart';

class DriverModel {
  final String id;
  final String name;
  final CompanyModel company;

  DriverModel({required this.id, required this.name, required this.company});

  factory DriverModel.fromJson(Map<String, dynamic> json) {
    return DriverModel(
      id: json['id'],
      name: json['name'],
      company: CompanyModel.fromJson(json['Company']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'Company': company.toJson(),
    };
  }
}
