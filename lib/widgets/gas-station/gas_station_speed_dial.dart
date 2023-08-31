import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:latlong2/latlong.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constants/colors.dart';
import '../../models/gas_station.dart';
import '../custom_flushbar_error.dart';

class GasStationSpeedDial extends StatelessWidget {
  final LatLng userLocation;
  final GasStationModel gasStation;

  const GasStationSpeedDial({
    super.key,
    required this.userLocation,
    required this.gasStation,
  });

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      animatedIcon: AnimatedIcons.menu_close,
      animatedIconTheme:
          const IconThemeData(size: 32.0, color: ColorsConstants.white),
      backgroundColor: ColorsConstants.primaryColor,
      visible: true,
      curve: Curves.bounceIn,
      children: [
        gasStationInfo(context),
        googleMaps(context),
        waze(context),
      ],
    );
  }

  SpeedDialChild gasStationInfo(BuildContext context) {
    return SpeedDialChild(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Informações do posto em breve!')),
          );
        },
        backgroundColor: ColorsConstants.mapGasStation,
        child: Icon(
          MdiIcons.gasStation,
          color: ColorsConstants.white,
          size: 28,
        ),
        label: gasStation.name,
        labelStyle: const TextStyle(
            fontWeight: FontWeight.w500, color: ColorsConstants.white),
        labelBackgroundColor: ColorsConstants.mapGasStation);
  }

  SpeedDialChild googleMaps(BuildContext context) {
    return SpeedDialChild(
        onTap: () {
          _launchMapsUrl(context, gasStation.latitudeAsDouble,
              gasStation.longitudeAsDouble, 'google');
        },
        backgroundColor: ColorsConstants.googleMaps,
        child: Icon(
          MdiIcons.googleMaps,
          color: ColorsConstants.white,
          size: 28,
        ),
        label: "Google Maps",
        labelStyle: const TextStyle(
          fontWeight: FontWeight.w500,
          color: ColorsConstants.white,
        ),
        labelBackgroundColor: ColorsConstants.googleMaps);
  }

  SpeedDialChild waze(BuildContext context) {
    return SpeedDialChild(
        onTap: () {
          _launchMapsUrl(context, gasStation.latitudeAsDouble,
              gasStation.longitudeAsDouble, 'waze');
        },
        backgroundColor: ColorsConstants.waze,
        child: Icon(
          MdiIcons.waze,
          color: ColorsConstants.white,
          size: 28,
        ),
        label: "Waze",
        labelStyle: const TextStyle(
            fontWeight: FontWeight.w500, color: ColorsConstants.white),
        labelBackgroundColor: ColorsConstants.waze);
  }

  void _launchMapsUrl(
      BuildContext context, double lat, double lng, String type) {
    String urlString = '';
    if (type == 'google') {
      if (defaultTargetPlatform == TargetPlatform.android) {
        urlString = 'geo:$lat,$lng?q=$lat,$lng';
      } else if (defaultTargetPlatform == TargetPlatform.iOS) {
        urlString = 'comgooglemaps://?q=$lat,$lng';
      }
    } else if (type == 'waze') {
      urlString = 'waze://?ll=$lat,$lng&navigate=yes';
    }
    Uri url = Uri.parse(urlString);
    _tryToLaunchUrl(context, url);
  }

  void _tryToLaunchUrl(BuildContext context, Uri url) async {
    if (await canLaunchUrl(url)) {
      launchUrl(url);
    } else {
      customFlushBarError('Aplicativo não instalado!', context);
    }
  }
}
