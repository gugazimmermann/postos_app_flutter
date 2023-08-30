import 'fuel_type.dart';
import 'transaction.dart';

class GasSstationVehicleModel {
  final List<FuelTypeModel> fuelTypes;
  final List<TransactionModel> transactions;

  GasSstationVehicleModel(
      {required this.fuelTypes, required this.transactions});

  factory GasSstationVehicleModel.fromJson(Map<dynamic, dynamic> json) {
    List<FuelTypeModel> fuelTypesList = (json['fuelTypes'] as List)
        .map((item) => FuelTypeModel.fromJson(item))
        .toList();
    List<TransactionModel> transactionsList = (json['transactions'] as List)
        .map((item) => TransactionModel.fromJson(item))
        .toList();
    return GasSstationVehicleModel(
      fuelTypes: fuelTypesList,
      transactions: transactionsList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fuelTypes': fuelTypes.map((item) => item.toJson()).toList(),
      'transactions': transactions.map((item) => item.toJson()).toList(),
    };
  }
}
