class TransactionProductModel {
  final String category;
  final String name;
  final int quantity;
  final String price;
  final String totalValue;

  TransactionProductModel({
    required this.category,
    required this.name,
    required this.quantity,
    required this.price,
    required this.totalValue,
  });

  factory TransactionProductModel.fromJson(Map<String, dynamic> json) {
    return TransactionProductModel(
      category: json['category'],
      name: json['name'],
      quantity: json['quantity'],
      price: json['price'],
      totalValue: json['totalValue'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'name': name,
      'quantity': quantity,
      'price': price,
      'totalValue': totalValue,
    };
  }
}
