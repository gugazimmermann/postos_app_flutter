class GasStationFuelPricesModel {
  final String fuelType;
  final String date;
  final String price;

  GasStationFuelPricesModel({
    required this.fuelType,
    required this.date,
    required this.price,
  });

  factory GasStationFuelPricesModel.fromJson(Map<String, dynamic> json) {
    return GasStationFuelPricesModel(
      fuelType: json['fuelType'],
      date: json['date'],
      price: json['price'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fuelType': fuelType,
      'date': date,
      'price': price,
    };
  }
}
