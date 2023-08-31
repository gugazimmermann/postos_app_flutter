import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:location/location.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

import '../constants/constants.dart';
import '../constants/strings.dart';
import '../providers/app_provider.dart';
import '../models/gas_station.dart';
import '../utils/haversine.dart';
import '../constants/colors.dart';

import '../utils/lauch_url.dart';
import '../widgets/custom_flushbar_error.dart';
import '../widgets/gas-station/gas_station_card.dart';

import 'gas_stations_map.dart';

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
    final gasStations = _sortedGasStations(appProvider);

    return Padding(
      padding: Lists.edgeInsets,
      child: Stack(
        children: [
          gasStations != null && gasStations.isNotEmpty
              ? ListView.builder(
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
                )
              : noGasStations(),
          ..._buildLocationWidgets(appProvider),
        ],
      ),
    );
  }

  List<GasStationModel>? _sortedGasStations(AppProvider appProvider) {
    final userLocation = appProvider.locationProvider.currentLocation;
    final gasStations = appProvider.gasStationsProvider.gasStations;

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

    return gasStations;
  }

  List<Widget> _buildLocationWidgets(AppProvider appProvider) {
    final locationError = appProvider.locationProvider.locationError;
    final userLocation = appProvider.locationProvider.currentLocation;

    List<Widget> widgets = [];

    if (appProvider.locationProvider.isLoadingLocation) {
      widgets.add(loadingLocation());
    } else if (locationError != null) {
      widgets.add(errorLocation(locationError, context));
    } else if (userLocation != null) {
      widgets.add(
          mapButton(userLocation, appProvider.gasStationsProvider.gasStations));
    }

    return widgets;
  }

  Align mapButton(
      LocationData? userLocation, List<GasStationModel>? gasStations) {
    if (userLocation == null) {
      return const Align();
    }
    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FloatingActionButton(
          onPressed: () {
            if (gasStations != null) {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => GasStationsMap(
                  userLocation: userLocation,
                  gasStations: gasStations,
                ),
              ));
            }
          },
          child: Icon(MdiIcons.mapSearch,
              size: 38.0, color: ColorsConstants.white),
        ),
      ),
    );
  }

  Align errorLocation(String locationError, BuildContext context) {
    customFlushBarError(locationError, context, duration: 10);
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

  SizedBox noGasStations() {
    return SizedBox(
      height: 100,
      child: Card(
        elevation: Lists.elevation,
        shape: Lists.shape,
        child: const Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(
            child: Text(
              GasStationStrings.noGasStations,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ColorsConstants.danger,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
