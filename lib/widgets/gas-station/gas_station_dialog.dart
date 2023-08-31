import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constants/colors.dart';
import '../../models/gas_station.dart';

import '../../pages/gas_stations_products.dart';
import '../../pages/gas_stations_route.dart';
import '../../pages/gas_stations_transactions.dart';

class GasStationDialog extends StatelessWidget {
  final GasStationModel gasStation;
  final LocationData? userLocation;

  const GasStationDialog(
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
            divider(),
            gasStationFuelTypes(),
            divider(),
            gasStationProducts(context),
            divider(),
            gasStationSignatures(),
            divider(),
            const SizedBox(height: 4.0),
            gasStationTransactions(context),
            const SizedBox(height: 16.0),
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

  Column gasStationFuelTypes() {
    return Column(
      children: [
        const Text(
          'Combustíveis Autorizados',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
              color: ColorsConstants.textColor),
        ),
        const SizedBox(height: 8.0),
        gasStationFuelTypesList(),
      ],
    );
  }

  Widget gasStationFuelTypesList() {
    final fuelTypes = gasStation.vehicle.fuelTypes;
    if (fuelTypes.isEmpty) {
      return const Text(
        'Veículo sem Restrições',
        style: TextStyle(fontSize: 16.0, color: ColorsConstants.textColor),
      );
    } else {
      final fuelTypeNames = fuelTypes.map((type) => type.name).join(', ');
      return Text(
        fuelTypeNames,
        style: const TextStyle(
            fontSize: 16.0,
            color: ColorsConstants.primaryColor,
            fontWeight: FontWeight.bold),
      );
    }
  }

  Column gasStationProducts(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Produtos',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
              color: ColorsConstants.textColor),
        ),
        const SizedBox(height: 8.0),
        gasStationProductsList(context),
      ],
    );
  }

  Widget gasStationProductsList(BuildContext context) {
    final productCount = gasStation.driver.products.length;
    bool hasProducts = productCount > 0;
    Widget productsText;
    if (!hasProducts) {
      productsText = const Text(
        'Nenhum Produto Autorizado',
        style: TextStyle(
          fontSize: 16.0,
          color: ColorsConstants.textColor,
        ),
      );
    } else {
      productsText = Text(
        hasProducts
            ? '$productCount Produtos Autorizados'
            : '1 Produto Autorizado',
        style:
            const TextStyle(fontSize: 16.0, color: ColorsConstants.textColor),
      );
    }
    return GestureDetector(
      onTap: hasProducts ? () => _navigateToProductsPage(context) : null,
      child: productsText,
    );
  }

  void _navigateToProductsPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GasStationProducts(gasStation: gasStation),
      ),
    );
  }

  Widget gasStationSignatures() {
    return Column(
      children: [
        const Text(
          'Assinaturas',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
              color: ColorsConstants.textColor),
        ),
        const SizedBox(height: 8.0),
        gasStationSignaturesList(),
      ],
    );
  }

  Widget gasStationSignaturesList() {
    final availableSignatures = gasStation.signatures;
    final driverSignatures = gasStation.driver.signatures;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: availableSignatures.map((signature) {
        final isDriverSignature = driverSignatures
            .any((driverSignature) => driverSignature.type == signature.type);
        final icon = _getSignatureIcon(signature.type);
        final color = signature.active
            ? ColorsConstants.primaryColor
            : ColorsConstants.inactive;
        return Padding(
          padding: const EdgeInsets.all(4.0),
          child: Icon(
            icon,
            color: isDriverSignature ? ColorsConstants.success : color,
            size: 36,
          ),
        );
      }).toList(),
    );
  }

  IconData _getSignatureIcon(String signatureType) {
    switch (signatureType) {
      case 'Biometric':
        return MdiIcons.fingerprint;
      case 'Facial Recognition':
        return MdiIcons.faceRecognition;
      case 'Digital Signature':
        return MdiIcons.drawPen;
      case 'Code':
        return MdiIcons.numeric;
      default:
        return Icons.error;
    }
  }

  Widget gasStationTransactions(BuildContext context) {
    final transactionsCount = gasStation.vehicle.transactions.length;
    bool hasTransactions = transactionsCount > 0;
    Widget transactionsText;
    if (!hasTransactions) {
      transactionsText = const Text(
        'Nenhum Abastecimento Realizado',
        style: TextStyle(
          fontSize: 16.0,
          color: ColorsConstants.textColor,
        ),
      );
    } else {
      transactionsText = Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            hasTransactions
                ? '$transactionsCount Abastecimentos Realizados'
                : '1 Abastecimento Realizado',
            style: const TextStyle(
                fontSize: 16.0, color: ColorsConstants.textColor),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Icon(
              MdiIcons.openInApp,
              size: 21,
              color: ColorsConstants.textColor,
            ),
          ),
        ],
      );
    }
    return GestureDetector(
      onTap:
          hasTransactions ? () => _navigateToTransactionsPage(context) : null,
      child: transactionsText,
    );
  }

  void _navigateToTransactionsPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GasStationTransactions(gasStation: gasStation),
      ),
    );
  }

  Column divider() {
    return const Column(
      children: [
        SizedBox(height: 4.0),
        Divider(
          color: ColorsConstants.divider,
        ),
        SizedBox(height: 4.0),
      ],
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
        userLocation: userLocation,
        gasStation: gasStation,
      ),
    ));
  }
}
