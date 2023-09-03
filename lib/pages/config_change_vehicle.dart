import 'package:flutter/material.dart';

import '../providers/app_provider.dart';

import '../models/vehicle.dart';

import '../constants/colors.dart';
import '../constants/strings.dart';

import '../widgets/custom_button.dart';
import '../widgets/custom_flushbar_error.dart';
import '../widgets/custom_page_app_bar.dart';

class ConfigChangeVehicle extends StatefulWidget {
  final AppProvider appProvider;

  const ConfigChangeVehicle({
    Key? key,
    required this.appProvider,
  }) : super(key: key);

  @override
  ConfigChangeVehicleState createState() => ConfigChangeVehicleState();
}

class ConfigChangeVehicleState extends State<ConfigChangeVehicle> {
  VehicleModel? _selectedVehicle;

  @override
  void initState() {
    super.initState();
    _selectedVehicle = widget.appProvider.signInProvider.selectedVehicle;
  }

  @override
  Widget build(BuildContext context) {
    final vehiclesList = widget.appProvider.signInProvider.vehiclesList;

    return WillPopScope(
        onWillPop: () async {
          if (_selectedVehicle == null) {
            customFlushBarError(ConfigStrings.noVehicleSelected, context);
            return false;
          }
          return true;
        },
        child: Scaffold(
          appBar: const CustomPageAppBar(title: ConfigStrings.selectVehicle),
          body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: vehiclesList?.length,
                      itemBuilder: (BuildContext context, int index) {
                        return CheckboxListTile(
                          activeColor: ColorsConstants.primaryColor,
                          title: Text(
                              '${vehiclesList?[index].manufacturer} / ${vehiclesList?[index].model} - ${vehiclesList?[index].plate}'),
                          value:
                              _selectedVehicle?.id == vehiclesList?[index].id,
                          onChanged: (bool? value) {
                            setState(() {
                              if (value == true) {
                                _selectedVehicle = vehiclesList![index];
                              }
                            });
                          },
                        );
                      },
                    ),
                  ),
                  CustomButton(
                    label: GeneralStrings.buttonConfirm,
                    onPressed: _selectedVehicle != null
                        ? () {
                            widget.appProvider.signInProvider
                                .selectVehicle(_selectedVehicle!);
                            widget.appProvider.updateGasStationsAndSchedules();
                            Navigator.of(context).pop();
                          }
                        : () {
                            customFlushBarError(
                                ConfigStrings.noVehicleSelected, context);
                          },
                    textColor: ColorsConstants.white,
                    buttonColor: ColorsConstants.primaryColor,
                  )
                ],
              )),
        ));
  }
}
