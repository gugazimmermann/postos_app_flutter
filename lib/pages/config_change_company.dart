import 'package:flutter/material.dart';

import '../providers/app_provider.dart';

import '../models/driver.dart';

import '../constants/colors.dart';
import '../constants/strings.dart';

import '../widgets/custom_button.dart';
import '../widgets/custom_flushbar_error.dart';
import '../widgets/custom_page_app_bar.dart';
import 'config_change_vehicle.dart';

class ConfigChangeCompany extends StatefulWidget {
  final AppProvider appProvider;

  const ConfigChangeCompany({
    Key? key,
    required this.appProvider,
  }) : super(key: key);

  @override
  ConfigChangeCompanyState createState() => ConfigChangeCompanyState();
}

class ConfigChangeCompanyState extends State<ConfigChangeCompany> {
  DriverModel? _selectedDriver;

  @override
  void initState() {
    super.initState();
    _selectedDriver = widget.appProvider.signInProvider.selectedDriver;
  }

  @override
  Widget build(BuildContext context) {
    final driverList = widget.appProvider.signInProvider.driverList;

    return Scaffold(
        appBar: const CustomPageAppBar(title: ConfigStrings.selectCompany),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: driverList?.length,
                  itemBuilder: (BuildContext context, int index) {
                    return CheckboxListTile(
                      activeColor: ColorsConstants.primaryColor,
                      title: Text(driverList![index].company.name),
                      value: _selectedDriver?.company.id ==
                          driverList[index].company.id,
                      onChanged: (bool? value) {
                        setState(() {
                          if (value == true) {
                            _selectedDriver = driverList[index];
                          }
                        });
                      },
                    );
                  },
                ),
              ),
              CustomButton(
                label: GeneralStrings.buttonConfirm,
                onPressed: _confirmSelection,
                textColor: ColorsConstants.white,
                buttonColor: ColorsConstants.primaryColor,
              )
            ],
          ),
        ));
  }

  void _confirmSelection() async {
    if (_selectedDriver == null) {
      customFlushBarError(ConfigStrings.noCompanySelected, context);
      return;
    }
    await widget.appProvider.signInProvider.selectDriver(_selectedDriver!);
    await widget.appProvider.signInProvider.removeVehicles();
    await widget.appProvider.signInProvider.fetchVehicles();
    if (mounted) {
      Navigator.of(context).pop();
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) =>
              ConfigChangeVehicle(appProvider: widget.appProvider)));
    }
  }
}
