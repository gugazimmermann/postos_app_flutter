import 'dart:async';

import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

import '../providers/app_provider.dart';
import '../providers/location_geofence_provider.dart';

import '../constants/colors.dart';
import '../constants/strings.dart';

import '../utils/log.dart';

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
    appProvider.gasStationsProvider.fetchGasStationsData(
        appProvider.signInProvider.selectedVehicle,
        appProvider.signInProvider.selectedDriver);
    appProvider.schedulesProvider.fetchSchedulesData(
        appProvider.signInProvider.selectedDriver,
        appProvider.signInProvider.selectedVehicle);
    appProvider.notificationProvider.clearAllUnreadNotifications();
    final geofenceStream = appProvider.locationProvider.geofenceStream;
    if (geofenceStream != null) {
      _geofenceSubscription = geofenceStream.listen((eventWithId) {
        if (eventWithId.event == GeofenceEvent.enter) {
          logger.i('Usuário entrou no posto com ID: ${eventWithId.id}');
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
