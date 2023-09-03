import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/app_provider.dart';

import '../../models/driver.dart';
import '../../models/vehicle.dart';

import '../../constants/colors.dart';
import '../../constants/strings.dart';

import '../../pages/config_change_company.dart';
import '../../pages/config_change_vehicle.dart';

class UserDialog extends StatelessWidget {
  final BuildContext dialogContext;

  const UserDialog(this.dialogContext, {super.key});

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    final DriverModel? driver = appProvider.signInProvider.selectedDriver;
    final VehicleModel? vehicle = appProvider.signInProvider.selectedVehicle;
    final List<DriverModel>? driverList = appProvider.signInProvider.driverList;

    return AlertDialog(
      title: Text(driver != null ? driver.name : ""),
      content: SingleChildScrollView(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
              "${ConfigStrings.dialogText1} ${driver?.company.name} ${ConfigStrings.dialogText2} ${vehicle?.manufacturer} /  ${vehicle?.model} - ${vehicle?.plate}."),
          const SizedBox(height: 10),
          // TextButton(
          //   onPressed: () => _showSettings(context),
          //   child: const Text("Configurações",
          //       style:
          //           TextStyle(fontSize: 18, color: ColorsConstants.textColor)),
          // ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (BuildContext context) {
                return ConfigChangeVehicle(appProvider: appProvider);
              }));
            },
            child: const Text(ConfigStrings.changeVehicle,
                style:
                    TextStyle(fontSize: 18, color: ColorsConstants.textColor)),
          ),
          driverList != null && driverList.length > 1
              ? TextButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (BuildContext context) {
                      return ConfigChangeCompany(appProvider: appProvider);
                    }));
                  },
                  child: const Text(ConfigStrings.changeCompany,
                      style: TextStyle(
                          fontSize: 18, color: ColorsConstants.textColor)),
                )
              : Container(),
        ],
      )),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(),
          child: const Text(GeneralStrings.buttonCancel),
        ),
        TextButton(
          onPressed: () {
            appProvider.signInProvider.resetSelection();
            Navigator.of(dialogContext).pop();
          },
          child: const Text(GeneralStrings.buttonLogout),
        ),
      ],
    );
  }
}
