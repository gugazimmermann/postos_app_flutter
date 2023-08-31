import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:postos_flutter_app/constants/constants.dart';
import 'package:postos_flutter_app/models/transaction.dart';
import 'package:postos_flutter_app/models/transaction_product.dart';

import '../constants/colors.dart';
import '../widgets/custom_page_app_bar.dart';

class GasStationTransactionsProducts extends StatelessWidget {
  final TransactionModel transaction;

  const GasStationTransactionsProducts({Key? key, required this.transaction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<TransactionProductModel> products = transaction.products;
    products.sort((a, b) => a.name.compareTo(b.name));

    return Scaffold(
      appBar: CustomPageAppBar(
          title:
              '${DateFormat('dd/MM/yy hh:mm').format(DateTime.parse(transaction.createdAt))}hs - ${transaction.fuelType}'),
      body: Padding(
        padding: Lists.edgeInsets,
        child: ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
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
                          Text(
                            '${product.name} x ${product.quantity}un',
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: ColorsConstants.textColor),
                          ),
                          const SizedBox(height: 4.0),
                          Text(
                            product.category,
                            style: const TextStyle(
                                fontSize: 14, color: ColorsConstants.textColor),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          NumberFormat.currency(
                                  locale: 'pt_BR',
                                  symbol: 'R\$',
                                  decimalDigits: 2)
                              .format(double.parse(product.price)),
                          style: const TextStyle(
                              fontSize: 14, color: ColorsConstants.textColor),
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          NumberFormat.currency(
                                  locale: 'pt_BR',
                                  symbol: 'R\$',
                                  decimalDigits: 2)
                              .format(double.parse(product.totalValue)),
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: ColorsConstants.textColor),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
