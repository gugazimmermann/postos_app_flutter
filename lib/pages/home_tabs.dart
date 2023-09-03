import 'dart:async';

import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

import '../models/gas_station.dart';
import '../providers/app_provider.dart';
import '../utils/geofencing.dart';
import '../utils/shared_preferences.dart';
import '../utils/log.dart';

import '../constants/colors.dart';
import '../constants/strings.dart';

import '../widgets/gas-station/location_status_map.dart';

import 'gas_stations_tab.dart';
import 'schedules_tab.dart';

class HomeTabs extends StatefulWidget {
  const HomeTabs({super.key});

  @override
  HomeTabsState createState() => HomeTabsState();
}

class HomeTabsState extends State<HomeTabs>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late StreamSubscription<GeofenceEventWithId> _geofenceSubscription;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {});
      }
    });
    Future.delayed(Duration.zero, _loadData);
  }

  _loadData() {
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    appProvider.locationProvider.getUserLocation();
    appProvider.locationProvider.initGeofence();
    appProvider.updateGasStationsAndSchedules();
    appProvider.notificationProvider.clearAllUnreadNotifications();
    final geofenceStream = appProvider.locationProvider.geofenceStream;
    if (geofenceStream != null) {
      _geofenceSubscription = geofenceStream.listen((eventWithId) {
        if (eventWithId.event == GeofenceEvent.enter) {
          _showNotification(context, eventWithId.id);
        }
      });
    }
  }

  Future<void> _showNotification(
      BuildContext context, String gasStationID) async {
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    final gasStations = appProvider.gasStationsProvider.gasStations;
    final vehicle = appProvider.signInProvider.selectedVehicle;

    GasStationModel? targetGasStation;
    try {
      targetGasStation = gasStations
          ?.firstWhere((gasStation) => gasStation.id == gasStationID);
    } catch (e) {
      logger.e('Gas station with ID $gasStationID not found.');
    }
    if (targetGasStation != null) {
      final lastNotifiedAt =
          await PreferencesHelper.getLastGasStationNotificationTimestamp(
              gasStationID, vehicle!.plate);
      final currentTime = DateTime.now().millisecondsSinceEpoch;
      const sixHoursInMillis = 6 * 60 * 60 * 1000;
      if (lastNotifiedAt == null ||
          (currentTime - lastNotifiedAt > sixHoursInMillis)) {
        final fuelTypes = targetGasStation.vehicle.fuelTypes;
        if (fuelTypes.isNotEmpty) {
          final fuelTypeNames = fuelTypes.map((type) => type.name).join(', ');
          appProvider.notificationProvider.showNotification(
              id: 1,
              title: targetGasStation.name,
              body: 'Restrição de combustível: $fuelTypeNames');
          PreferencesHelper.saveLastGasStationNotificationTimestamp(
              gasStationID, vehicle.plate, currentTime);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);
    final vehicle = appProvider.signInProvider.selectedVehicle;

    return Scaffold(
        body: Stack(children: [
      Column(
        children: [
          Row(
            children: [
              _buildTab(
                index: 0,
                icon: MdiIcons.gasStation,
                label: HomeTabsStrings.tabGasStations,
              ),
              _buildTab(
                index: 1,
                icon: MdiIcons.carClock,
                label: HomeTabsStrings.tabSchedules,
              ),
            ],
          ),
          const SizedBox(height: 4.0),
          Text(vehicle != null ? vehicle.plate : "",
              style: const TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
                color: ColorsConstants.textColor,
              )),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                GasStationsTab(),
                SchedulesTab(),
              ],
            ),
          ),
        ],
      ),
      const LocationStatusMap()
    ]));
  }

  Widget _buildTab(
      {required int index, required IconData icon, required String label}) {
    bool isActive = _tabController.index == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          _tabController.animateTo(index);
        },
        child: Container(
          height: 80,
          color: isActive
              ? ColorsConstants.activeTab
              : ColorsConstants.inactiveTab,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Align(
                alignment: Alignment.center,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      icon,
                      size: 36.0,
                      color: isActive
                          ? ColorsConstants.activeTabText
                          : ColorsConstants.inactiveTabText,
                    ),
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 18.0,
                        color: isActive
                            ? ColorsConstants.activeTabText
                            : ColorsConstants.inactiveTabText,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 6.0,
                  color: isActive
                      ? ColorsConstants.activeTabIndicator
                      : Colors.transparent,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _geofenceSubscription.cancel();
    super.dispose();
  }
}
