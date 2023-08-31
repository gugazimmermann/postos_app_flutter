import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:postos_flutter_app/constants/colors.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/gas_station.dart';
import '../../pages/gas_stations_route.dart';

class GasStationInfo extends StatelessWidget {
  final GasStationModel gasStation;
  final LocationData? userLocation;

  const GasStationInfo(
      {Key? key, required this.gasStation, required this.userLocation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            gasStationName(),
            const SizedBox(height: 16.0),
            gasStationContactRow(context),
            const SizedBox(height: 16.0),
            gasStationAddress(),
            const Divider(),
            closeButton(context),
          ],
        ),
      ),
    );
  }

  Text gasStationName() {
    return Text(
      gasStation.name,
      style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 21.0,
          color: ColorsConstants.textColor),
    );
  }

  Row gasStationContactRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          onPressed: () =>
              _launchUrl("tel:${_cleanPhoneNumber(gasStation.phone)}", context),
          icon: const Icon(
            Icons.phone,
            size: 36,
            color: ColorsConstants.textColor,
          ),
        ),
        IconButton(
          onPressed: () {
            _openMap(context);
          },
          icon: Icon(
            MdiIcons.mapMarkerRadius,
            size: 36,
            color: ColorsConstants.textColor,
          ),
        ),
        IconButton(
          onPressed: () => _launchUrl("mailto:${gasStation.email}", context),
          icon: const Icon(
            Icons.email,
            size: 36,
            color: ColorsConstants.textColor,
          ),
        ),
      ],
    );
  }

  Text gasStationAddress() {
    return Text(
      '${gasStation.address}, ${gasStation.city}, ${gasStation.state}',
      style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18.0,
          color: ColorsConstants.textColor),
      textAlign: TextAlign.center,
    );
  }

  Align closeButton(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: ElevatedButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Text(
          'Fechar',
          style: TextStyle(color: ColorsConstants.textColor),
        ),
      ),
    );
  }

  String _cleanPhoneNumber(String phoneNumber) {
    return phoneNumber.replaceAll(RegExp(r'[^\d]'), '');
  }

  void _launchUrl(String urlString, BuildContext context) async {
    await launchUrl(Uri.parse(urlString));
  }

  void _openMap(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => GasStationsRoute(
        userLocation: userLocation != null
            ? LatLng(userLocation!.latitude!, userLocation!.longitude!)
            : null,
        gasStation: gasStation,
      ),
    ));
  }
}
