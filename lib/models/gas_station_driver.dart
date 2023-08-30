import 'product.dart';
import 'signature.dart';

class GasSstationDriverModel {
  final SignatureModel signatures;
  final ProductModel products;

  GasSstationDriverModel({required this.signatures, required this.products});

  factory GasSstationDriverModel.fromJson(Map<String, dynamic> json) {
    return GasSstationDriverModel(
      signatures: SignatureModel.fromJson(json['signatures']),
      products: ProductModel.fromJson(json['products']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'signatures': signatures.toJson(),
      'products': products.toJson(),
    };
  }
}
