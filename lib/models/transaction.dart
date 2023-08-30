import 'transaction_product.dart';

class TransactionModel {
  final String createdAt;
  final String km;
  final String quantity;
  final String unitValue;
  final String totalValue;
  final String fuelType;
  final List<TransactionProductModel> products;

  TransactionModel({
    required this.createdAt,
    required this.km,
    required this.quantity,
    required this.unitValue,
    required this.totalValue,
    required this.fuelType,
    required this.products,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    List<TransactionProductModel> productsList = (json['products'] as List)
        .map((item) => TransactionProductModel.fromJson(item))
        .toList();
    return TransactionModel(
      createdAt: json['createdAt'],
      km: json['km'],
      quantity: json['quantity'],
      unitValue: json['unitValue'],
      totalValue: json['totalValue'],
      fuelType: json['fuelType'],
      products: productsList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'createdAt': createdAt,
      'km': km,
      'quantity': quantity,
      'unitValue': unitValue,
      'totalValue': totalValue,
      'fuelType': fuelType,
      'products': products.map((item) => item.toJson()).toList(),
    };
  }
}
