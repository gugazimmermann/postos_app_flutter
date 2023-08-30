import 'package:flutter/material.dart';
import 'package:location/location.dart';

import '../../constants/colors.dart';
import '../../models/gas_station.dart';

class GasStationCard extends StatelessWidget {
  final GasSstationModel gasStation;
  final LocationData? userLocation;

  const GasStationCard(
      {super.key, required this.gasStation, this.userLocation});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: ColorsConstants.cardWhite,
      elevation: 3.0,
      child: InkWell(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Informações do posto em breve!')),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      gasStation.name,
                      style: const TextStyle(
                        color: ColorsConstants.textColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                    const SizedBox(height: 6.0),
                    Text(
                      gasStation.address,
                      style: const TextStyle(
                        fontSize: 16.0,
                        color: ColorsConstants.textColor,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${gasStation.city}, ${gasStation.state}',
                      style: const TextStyle(
                        color: ColorsConstants.textColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                    if (userLocation != null)
                      Text(
                        '${gasStation.distance?.toStringAsFixed(2)} km',
                        style: const TextStyle(
                          fontSize: 18.0,
                          color: ColorsConstants.textColor,
                        ),
                      ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}
