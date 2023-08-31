import 'product.dart';
import 'signature.dart';

class GasStationDriverModel {
  final List<SignatureModel> signatures;
  final List<ProductModel> products;

  GasStationDriverModel({required this.signatures, required this.products});

  factory GasStationDriverModel.fromJson(Map<String, dynamic> json) {
    List<SignatureModel> signaturesList = (json['signatures'] as List)
        .map((item) => SignatureModel.fromJson(item))
        .toList();
    List<ProductModel> productsList = (json['products'] as List)
        .map((item) => ProductModel.fromJson(item))
        .toList();

    return GasStationDriverModel(
      signatures: signaturesList,
      products: productsList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'signatures': signatures.map((item) => item.toJson()).toList(),
      'products': products.map((item) => item.toJson()).toList(),
    };
  }
}
