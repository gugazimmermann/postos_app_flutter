import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../models/gas_station.dart';

import '../constants/colors.dart';
import '../widgets/gas-station/gas_station_speed_dial.dart';

class GasStationsRoute extends StatefulWidget {
  final LatLng userLocation;
  final GasStationModel gasStation;

  const GasStationsRoute(
      {Key? key, required this.userLocation, required this.gasStation})
      : super(key: key);

  @override
  GasStationsRouteState createState() => GasStationsRouteState();
}

class GasStationsRouteState extends State<GasStationsRoute> {
  List<LatLng>? routePoints;

  @override
  void initState() {
    super.initState();
    fetchRoute(
            widget.userLocation,
            LatLng(widget.gasStation.latitudeAsDouble,
                widget.gasStation.longitudeAsDouble),
            "58c34e31-fac4-4417-8d87-ff62270593ed")
        .then((encoded) {
      if (encoded != null) {
        setState(() {
          routePoints = decodePoly(encoded);
        });
      }
    });
  }

  Future<String?> fetchRoute(LatLng start, LatLng end, String apiKey) async {
    final url =
        'https://graphhopper.com/api/1/route?point=${start.latitude},${start.longitude}&point=${end.latitude},${end.longitude}&vehicle=car&locale=pt&key=$apiKey&type=json';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return json.decode(response.body)['paths'][0]['points'];
    } else {
      throw Exception('Failed to load route');
    }
  }

  List<LatLng> decodePoly(String encoded) {
    final PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> decodedPolylines = polylinePoints.decodePolyline(encoded);
    return decodedPolylines
        .map((pointLatLng) =>
            LatLng(pointLatLng.latitude, pointLatLng.longitude))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: FlutterMap(
        options: mapOptions(),
        children: [
          TileLayer(
              urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
              subdomains: const ['a', 'b', 'c']),
          if (routePoints != null)
            PolylineLayer(
              polylines: [
                polyline(),
              ],
            ),
          MarkerLayer(
            markers: [
              gasStationMarker(),
              driverMarker(),
            ],
          ),
        ],
      ),
      floatingActionButton: GasStationSpeedDial(
        // Uso do novo widget
        userLocation: widget.userLocation,
        gasStation: widget.gasStation,
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
        backgroundColor: ColorsConstants.white,
        title: Text(widget.gasStation.name));
  }

  MapOptions mapOptions() {
    return MapOptions(
      center: LatLng(widget.gasStation.latitudeAsDouble,
          widget.gasStation.longitudeAsDouble),
      zoom: 17.0,
    );
  }

  Marker gasStationMarker() {
    return Marker(
      width: 64,
      height: 64,
      point: LatLng(widget.gasStation.latitudeAsDouble,
          widget.gasStation.longitudeAsDouble),
      builder: (context) => Icon(
        MdiIcons.gasStation,
        color: ColorsConstants.mapGasStation,
        size: 64,
      ),
    );
  }

  Marker driverMarker() {
    return Marker(
      width: 64,
      height: 64,
      point: widget.userLocation,
      builder: (context) => Icon(
        MdiIcons.carConnected,
        color: ColorsConstants.mapDriver,
        size: 64,
      ),
    );
  }

  Polyline polyline() {
    return Polyline(
        points: routePoints!,
        color: ColorsConstants.mapRoute,
        strokeWidth: 12.0);
  }
}
