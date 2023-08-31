import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../constants/colors.dart';
import '../constants/constants.dart';
import '../models/gas_station.dart';
import '../models/transaction.dart';
import '../widgets/custom_page_app_bar.dart';
import 'gas_stations_transactions_products.dart';

class GasStationTransactions extends StatelessWidget {
  final GasStationModel gasStation;

  const GasStationTransactions({Key? key, required this.gasStation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<TransactionModel> transactions = gasStation.vehicle.transactions;
    transactions.sort((a, b) =>
        DateTime.parse(b.createdAt).compareTo(DateTime.parse(a.createdAt)));

    return Scaffold(
      appBar: CustomPageAppBar(title: 'Abastecimentos em ${gasStation.name}'),
      body: Padding(
        padding: Lists.edgeInsets,
        child: ListView.builder(
          itemCount: transactions.length,
          itemBuilder: (context, index) {
            final transaction = transactions[index];
            return Card(
              color: Lists.color,
              elevation: Lists.elevation,
              shape: Lists.shape,
              child: ListTile(
                dense: true,
                contentPadding: Lists.padding,
                title: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          dateRow(transaction),
                          const SizedBox(height: 8.0),
                          fuelTypeRow(transaction),
                          const SizedBox(height: 8.0),
                          detailsRow(transaction)
                        ],
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    cartIcon(context, transaction),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Text dateRow(TransactionModel transaction) {
    return Text(
      '${DateFormat('dd/MM/yy hh:mm').format(DateTime.parse(transaction.createdAt))}hs',
      style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: ColorsConstants.textColor),
    );
  }

  Row fuelTypeRow(TransactionModel transaction) {
    return Row(
      children: [
        Text(
          transaction.fuelType,
          style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: ColorsConstants.textColor),
        ),
        const SizedBox(width: 8.0),
        Text(
          NumberFormat.currency(
                  locale: 'pt_BR', symbol: 'R\$', decimalDigits: 2)
              .format(double.parse(transaction.totalValue)),
          style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: ColorsConstants.textColor),
        ),
      ],
    );
  }

  Row detailsRow(TransactionModel transaction) {
    return Row(
      children: [
        Text(
          '${NumberFormat.decimalPattern('pt_BR').format(double.parse(transaction.quantity))} L',
          style:
              const TextStyle(fontSize: 14, color: ColorsConstants.textColor),
        ),
        const SizedBox(width: 8.0),
        Text(
          NumberFormat.currency(
                  locale: 'pt_BR', symbol: 'R\$', decimalDigits: 2)
              .format(double.parse(transaction.unitValue)),
          style:
              const TextStyle(fontSize: 14, color: ColorsConstants.textColor),
        ),
      ],
    );
  }

  Stack cartIcon(BuildContext context, TransactionModel transaction) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    GasStationTransactionsProducts(transaction: transaction),
              ),
            );
          },
          child: Icon(
            MdiIcons.cartVariant,
            color: ColorsConstants.textColor,
            size: 36.0,
          ),
        ),
        if (transaction.products.isNotEmpty)
          Badge.count(
            count: transaction.products.length,
            backgroundColor: ColorsConstants.success,
            textStyle: const TextStyle(
              color: ColorsConstants.success,
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
            ),
          ),
      ],
    );
  }
}
