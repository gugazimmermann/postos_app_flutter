class VehicleModel {
  final String id;
  final String plate;
  final String manufacturer;
  final String model;

  VehicleModel({
    required this.id,
    required this.plate,
    required this.manufacturer,
    required this.model,
  });

  factory VehicleModel.fromJson(Map<String, dynamic> json) {
    return VehicleModel(
      id: json['id'],
      plate: json['plate'],
      manufacturer: json['manufacturer'],
      model: json['model'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'plate': plate,
      'manufacturer': manufacturer,
      'model': model,
    };
  }
}
