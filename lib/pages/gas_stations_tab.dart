import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

import '../providers/app_provider.dart';

import '../models/gas_station.dart';

import '../constants/colors.dart';
import '../constants/strings.dart';

import '../utils/lauch_url.dart';

import '../widgets/custom_empty_data_card.dart';
import '../widgets/gas-station/gas_station_card.dart';

class GasStationsTab extends StatelessWidget {
  const GasStationsTab({Key? key}) : super(key: key);

  Future<void> _recarregarDados(BuildContext context) async {
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    appProvider.locationProvider.getUserLocation();
    await appProvider.updateGasStationsAndSchedules();
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);
    return ValueListenableBuilder<bool>(
      valueListenable: appProvider.gasStationsProvider.isLoading,
      builder: (context, isLoading, child) {
        if (isLoading) {
          return const Center(child: CircularProgressIndicator());
        } else {
          final List<GasStationModel>? gasStations =
              appProvider.gasStationsProvider.gasStations;
          if (gasStations == null || gasStations.isEmpty) {
            return const Center(
                child: EmptyDataCard(text: GasStationStrings.noGasStations));
          } else {
            return RefreshIndicator(
              onRefresh: () => _recarregarDados(context),
              child: ListView.builder(
                itemCount: gasStations.length,
                itemBuilder: (context, index) {
                  return Slidable(
                    startActionPane:
                        slidableToMap(appProvider, gasStations[index]),
                    child: GasStationCard(
                      gasStation: gasStations[index],
                      userLocation:
                          appProvider.locationProvider.currentLocation,
                    ),
                  );
                },
              ),
            );
          }
        }
      },
    );
  }

  ActionPane slidableToMap(
      AppProvider appProvider, GasStationModel gasStation) {
    return ActionPane(
      motion: const ScrollMotion(),
      extentRatio: 0.50,
      children: [
        SlidableAction(
          onPressed: (BuildContext context) {
            launchMapsUrl(context, gasStation.latitudeAsDouble,
                gasStation.longitudeAsDouble, 'google');
          },
          backgroundColor: ColorsConstants.googleMaps,
          foregroundColor: ColorsConstants.white,
          icon: MdiIcons.googleMaps,
        ),
        SlidableAction(
          onPressed: (BuildContext context) {
            launchMapsUrl(context, gasStation.latitudeAsDouble,
                gasStation.longitudeAsDouble, 'waze');
          },
          backgroundColor: ColorsConstants.waze,
          foregroundColor: ColorsConstants.white,
          icon: MdiIcons.waze,
        ),
      ],
    );
  }
}
