import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

import '../../constants/colors.dart';
import '../../models/gas_station.dart';
import '../../pages/gas_stations_map.dart';
import '../../providers/app_provider.dart';
import '../custom_flushbar_error.dart';

class LocationStatusMap extends StatefulWidget {
  const LocationStatusMap({super.key});

  @override
  LocationStatusMapState createState() => LocationStatusMapState();
}

class LocationStatusMapState extends State<LocationStatusMap>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  List<GasStationModel>? _previousGasStations;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);
    return Stack(children: buildLocationWidgets(appProvider));
  }

  List<Widget> buildLocationWidgets(AppProvider appProvider) {
    final isLoadingLocation = appProvider.locationProvider.isLoadingLocation;
    final locationError = appProvider.locationProvider.locationError;
    final userLocation = appProvider.locationProvider.currentLocation;

    List<Widget> widgets = [];
    if (isLoadingLocation) {
      widgets.add(loadingLocation());
    } else if (locationError != null) {
      widgets.add(errorLocation(locationError, context));
    } else if (userLocation != null) {
      _setGeofences(appProvider, appProvider.gasStationsProvider.gasStations);
      widgets.add(
          mapButton(userLocation, appProvider.gasStationsProvider.gasStations));
    }
    return widgets;
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

  void _setGeofences(
      AppProvider appProvider, List<GasStationModel>? gasStations) {
    if (listsAreEqual(_previousGasStations, gasStations)) return;
    appProvider.locationProvider.clearAllGeofencePoints();
    if (gasStations != null && gasStations.isNotEmpty) {
      for (var gasStation in gasStations) {
        appProvider.locationProvider.addGeofencePoint(gasStation.id,
            gasStation.latitudeAsDouble, gasStation.longitudeAsDouble, 10);
      }
    }
    _previousGasStations = gasStations;
  }

  bool listsAreEqual(List<GasStationModel>? a, List<GasStationModel>? b) {
    if (a == null || b == null) return a == b;
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i].id != b[i].id) return false;
    }
    return true;
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
