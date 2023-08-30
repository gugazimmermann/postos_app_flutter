class FuelTypeModel {
  final String name;

  FuelTypeModel({
    required this.name,
  });

  factory FuelTypeModel.fromJson(Map<String, dynamic> json) {
    return FuelTypeModel(
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }
}
