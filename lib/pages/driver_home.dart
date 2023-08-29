import 'package:flutter/material.dart';
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(icon: Icon(Icons.local_gas_station), text: "Postos"),
              Tab(icon: Icon(Icons.schedule), text: "Agendamentos"),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                PostosTab(),
                AgendamentosTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
