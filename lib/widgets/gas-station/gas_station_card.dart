import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../constants/colors.dart';
import '../../constants/constants.dart';
import '../../models/gas_station.dart';
import '../../utils/gas_station_open.dart';
import 'gas_station_dialog.dart';

class GasStationCard extends StatelessWidget {
  final GasStationModel gasStation;
  final LocationData? userLocation;

  const GasStationCard(
      {super.key, required this.gasStation, this.userLocation});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Lists.color,
      elevation: Lists.elevation,
      shape: Lists.shape,
      child: InkWell(
        onTap: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return GasStationDialog(
                  gasStation: gasStation, userLocation: userLocation);
            },
          );
        },
        child: Padding(
          padding: Lists.paddingHalf,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              gasStation.openHours.isNotEmpty
                  ? Icon(
                      MdiIcons.circle,
                      color: gasStation.openHours.any(isGasStationOpen)
                          ? ColorsConstants.success
                          : ColorsConstants.danger,
                      size: 14,
                    )
                  : Container(),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: Lists.padding,
                  child: Row(
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
                            if (userLocation != null &&
                                gasStation.distance != null)
                              Text(
                                '${gasStation.distance?.toStringAsFixed(2)} km',
                                style: const TextStyle(
                                  fontSize: 18.0,
                                  color: ColorsConstants.textColor,
                                ),
                              ),
                          ],
                        ),
                      )
                    ],
                  ),
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
