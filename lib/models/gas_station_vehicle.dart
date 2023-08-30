import 'fuel_type.dart';
import 'transaction.dart';

class GasSstationVehicleModel {
  final FuelTypeModel fuelTypes;
  final TransactionModel transactions;

  GasSstationVehicleModel(
      {required this.fuelTypes, required this.transactions});

  factory GasSstationVehicleModel.fromJson(Map<String, dynamic> json) {
    return GasSstationVehicleModel(
      fuelTypes: FuelTypeModel.fromJson(json['fuelTypes']),
      transactions: TransactionModel.fromJson(json['transactions']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fuelTypes': fuelTypes.toJson(),
      'transactions': transactions.toJson(),
    };
  }
}
