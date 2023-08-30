class ProductModel {
  final String category;
  final String name;
  final bool active;

  ProductModel({
    required this.category,
    required this.name,
    required this.active,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      category: json['category'],
      name: json['name'],
      active: json['active'] is bool ? json['active'] : false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'name': name,
      'active': active,
    };
  }
}
