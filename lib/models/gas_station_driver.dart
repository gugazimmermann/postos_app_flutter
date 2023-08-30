import 'product.dart';
import 'signature.dart';

class GasSstationDriverModel {
  final List<SignatureModel> signatures;
  final List<ProductModel> products;

  GasSstationDriverModel({required this.signatures, required this.products});

  factory GasSstationDriverModel.fromJson(Map<String, dynamic> json) {
    List<SignatureModel> signaturesList = (json['signatures'] as List)
        .map((item) => SignatureModel.fromJson(item))
        .toList();
    List<ProductModel> productsList = (json['products'] as List)
        .map((item) => ProductModel.fromJson(item))
        .toList();

    return GasSstationDriverModel(
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
