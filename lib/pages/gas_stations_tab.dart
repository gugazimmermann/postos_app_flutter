import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/app_provider.dart';

class GasStationsTab extends StatelessWidget {
  const GasStationsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final gasStations = Provider.of<AppProvider>(context).gasStations;

    return ListView.builder(
      itemCount: gasStations?.length ?? 0,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(gasStations![index].name),
        );
      },
    );
  }
}
