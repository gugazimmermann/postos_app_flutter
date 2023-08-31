import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:latlong2/latlong.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../constants/colors.dart';
import '../models/gas_station.dart';

class GasStationsMap extends StatefulWidget {
  final List<GasStationModel>? gasStations;
  final LatLng userLocation;

  const GasStationsMap({
    Key? key,
    this.gasStations,
    required this.userLocation,
  }) : super(key: key);

  @override
  GasStationsMapState createState() => GasStationsMapState();
}

class GasStationsMapState extends State<GasStationsMap> {
  final List<Color> markerColors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.purple,
    Colors.orange,
    Colors.yellow,
    Colors.pink,
    Colors.teal,
    Colors.cyan,
    Colors.indigo,
    Colors.brown,
    Colors.lime,
    Colors.amber,
    Colors.deepOrange,
    Colors.lightBlue,
    Colors.lightGreen,
    Colors.deepPurple,
    Colors.blueGrey,
    Colors.grey,
    Colors.black,
  ];

  final MapController mapController = MapController();

  void _moveMap(LatLng coords) {
    mapController.move(coords, 15.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: ColorsConstants.white,
          title: const Text("Mapa dos Postos")),
      body: FlutterMap(
        mapController: mapController,
        options: MapOptions(
          center: widget.userLocation,
          zoom: 13.0,
        ),
        children: [
          TileLayer(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: const ['a', 'b', 'c'],
          ),
          MarkerLayer(
            markers: widget.gasStations!.asMap().entries.map((entry) {
              GasStationModel gasStation = entry.value;
              return Marker(
                width: 40,
                height: 40,
                point: LatLng(
                    gasStation.latitudeAsDouble, gasStation.longitudeAsDouble),
                builder: (context) => GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Informações do posto em breve!')),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: markerColors[entry.key % markerColors.length],
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Icon(
                        MdiIcons.gasStation,
                        color: Colors.white,
                        size: 26,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        animatedIconTheme:
            const IconThemeData(size: 32.0, color: ColorsConstants.white),
        backgroundColor: ColorsConstants.primaryColor,
        visible: true,
        curve: Curves.bounceIn,
        children: widget.gasStations!.take(5).map((gasStation) {
          return SpeedDialChild(
              child: Icon(MdiIcons.gasStation,
                  color: markerColors[widget.gasStations!.indexOf(gasStation)],
                  size: 32.0),
              label: gasStation.name,
              onTap: () => _moveMap(LatLng(
                  gasStation.latitudeAsDouble, gasStation.longitudeAsDouble)));
        }).toList(),
      ),
    );
  }
}
