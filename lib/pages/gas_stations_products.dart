import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:postos_flutter_app/constants/colors.dart';

import '../models/gas_station.dart';
import '../models/product.dart';
import '../widgets/custom_page_app_bar.dart';

class GasStationProducts extends StatelessWidget {
  final GasStationModel gasStation;

  const GasStationProducts({Key? key, required this.gasStation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<ProductModel> products = gasStation.driver.products;
    products.sort((a, b) => a.name.compareTo(b.name));

    return Scaffold(
      appBar: CustomPageAppBar(title: 'Produtos em ${gasStation.name}'),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 16.0),
        child: ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return Card(
              color: ColorsConstants.cardWhite,
              elevation: 2.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: ListTile(
                dense: true,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                title: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    children: [
                      Icon(
                        MdiIcons.circle,
                        color: product.active
                            ? ColorsConstants.success
                            : ColorsConstants.danger,
                        size: 16.0,
                      ),
                      const SizedBox(width: 8.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name,
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: ColorsConstants.textColor),
                            ),
                            const SizedBox(height: 4.0),
                            Text(
                              product.category,
                              style: const TextStyle(
                                  fontSize: 14,
                                  color: ColorsConstants.textColor),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
