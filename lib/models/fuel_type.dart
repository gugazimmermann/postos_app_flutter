class FuelTypeModel {
  final String name;

  FuelTypeModel({
    required this.name,
  });

  factory FuelTypeModel.fromJson(Map<String, dynamic> json) {
    return FuelTypeModel(
      name: json['plnameate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }
}
