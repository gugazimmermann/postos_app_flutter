import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/gas_station.dart';
import '../../constants/colors.dart';
import '../../constants/strings.dart';

class GasStationFuelPrices extends StatelessWidget {
  const GasStationFuelPrices({
    super.key,
    required this.gasStation,
  });

  final GasStationModel gasStation;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      title: const Text(GasStationStrings.fuelPricesTitle),
      content: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columnSpacing: 10,
          headingRowHeight: 40,
          dataRowMinHeight: 40,
          headingTextStyle: const TextStyle(fontSize: 12),
          dataTextStyle: const TextStyle(fontSize: 12),
          columns: const [
            DataColumn(
                label: Text(GasStationStrings.fuelPricesFuelType,
                    style: TextStyle(
                        fontSize: 12, color: ColorsConstants.textColor))),
            DataColumn(
                label: Text(GasStationStrings.fuelPricesDate,
                    style: TextStyle(
                        fontSize: 12, color: ColorsConstants.textColor))),
            DataColumn(
                label: Text(GasStationStrings.fuelPricesPrice,
                    style: TextStyle(
                        fontSize: 12, color: ColorsConstants.textColor))),
          ],
          rows: gasStation.fuelPrices.map((fuelPrice) {
            return DataRow(
              cells: [
                DataCell(Text(fuelPrice.fuelType,
                    style: const TextStyle(
                        fontSize: 12, color: ColorsConstants.textColor))),
                DataCell(Text(
                    DateFormat('dd/MM/yy')
                        .format(DateTime.parse(fuelPrice.date)),
                    style: const TextStyle(
                        fontSize: 12, color: ColorsConstants.textColor))),
                DataCell(Text(
                    NumberFormat.currency(
                            locale: 'pt_BR', symbol: 'R\$', decimalDigits: 2)
                        .format(double.parse(fuelPrice.price)),
                    style: const TextStyle(
                        fontSize: 12, color: ColorsConstants.textColor))),
              ],
            );
          }).toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text(GeneralStrings.buttonClose),
        ),
      ],
    );
  }
}
