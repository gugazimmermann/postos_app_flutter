import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:latlong2/latlong.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:postos_flutter_app/constants/constants.dart';
import 'package:postos_flutter_app/utils/log.dart';
import 'package:provider/provider.dart';

import '../models/gas_station.dart';
import '../providers/app_provider.dart';

import '../constants/colors.dart';
import '../utils/haversine.dart';
import '../widgets/custom_flushbar_error.dart';
import '../widgets/gas-station/gas_station_card.dart';

import 'gas_stations_route.dart';

class GasStationsTab extends StatefulWidget {
  const GasStationsTab({super.key});

  @override
  GasStationsTabState createState() => GasStationsTabState();
}

class GasStationsTabState extends State<GasStationsTab>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);
    final userLocation = appProvider.currentLocation;
    final gasStations = appProvider.gasStations;
    final locationError = appProvider.locationError;

    if (userLocation != null && gasStations != null) {
      for (var station in gasStations) {
        station.distance = haversineDistance(
          userLocation.latitude!,
          userLocation.longitude!,
          station.latitudeAsDouble,
          station.longitudeAsDouble,
        );
      }
      gasStations.sort((a, b) => a.distance!.compareTo(b.distance!));
    }

    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Stack(
        children: [
          ListView.builder(
            itemCount: gasStations?.length ?? 0,
            itemBuilder: (context, index) {
              return Slidable(
                  startActionPane:
                      slidableToMap(appProvider, gasStations![index]),
                  child: GasStationCard(
                      gasStation: gasStations[index],
                      userLocation: userLocation));
            },
          ),
          if (appProvider.isLoadingLocation) loadingLocation(),
          if (appProvider.isLoadingLocation == false && locationError != null)
            errorLocation(context),
          if (appProvider.isLoadingLocation == false &&
              locationError == null &&
              userLocation != null)
            mapButton(),
        ],
      ),
    );
  }

  Align mapButton() {
    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FloatingActionButton(
          onPressed: () {
            // abrir map
          },
          child: Icon(MdiIcons.mapSearch,
              size: 38.0, color: ColorsConstants.white),
        ),
      ),
    );
  }

  Align errorLocation(BuildContext context) {
    customFlushBarError(LocationConstants.error, context);
    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Icon(MdiIcons.compassOffOutline,
            size: 64.0, color: ColorsConstants.danger),
      ),
    );
  }

  Align loadingLocation() {
    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: RotationTransition(
          turns: _animationController,
          child: Icon(MdiIcons.compassOutline,
              size: 64.0, color: ColorsConstants.locationLoading),
        ),
      ),
    );
  }

  ActionPane slidableToMap(
      AppProvider appProvider, GasSstationModel gasStation) {
    return ActionPane(
      motion: const ScrollMotion(),
      extentRatio: 0.20,
      children: [
        SlidableAction(
          onPressed: (BuildContext context) {
            if (appProvider.currentLocation != null) {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => GasStationsRoute(
                  userLocation: LatLng(
                    appProvider.currentLocation!.latitude!,
                    appProvider.currentLocation!.longitude!,
                  ),
                  gasStation: gasStation,
                ),
              ));
            }
          },
          backgroundColor: ColorsConstants.primaryColor,
          foregroundColor: ColorsConstants.white,
          icon: MdiIcons.mapMarker,
        ),
      ],
    );
  }
}
