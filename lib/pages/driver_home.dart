import 'package:flutter/material.dart';
import 'package:postos_flutter_app/constants/colors.dart';
import 'package:postos_flutter_app/constants/strings.dart';
import 'postos_tab.dart';
import 'agendamentos_tab.dart';

class DriverHome extends StatefulWidget {
  const DriverHome({super.key});

  @override
  DriverHomeState createState() => DriverHomeState();
}

class DriverHomeState extends State<DriverHome>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Row(
            children: [
              _buildTab(
                index: 0,
                icon: Icons.local_gas_station,
                label: DriverHomeStrings.tabLabelGasStations,
              ),
              _buildTab(
                index: 1,
                icon: Icons.schedule,
                label: DriverHomeStrings.tabLabelSchedules,
              ),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                PostosTab(),
                AgendamentosTab(),
              ],
            ),
          ),
        ],
      ),
    );
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
                        fontSize: 21.0,
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
                  height: 4.0,
                  color: isActive
                      ? ColorsConstants.activeTabBorder
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
    super.dispose();
  }
}
