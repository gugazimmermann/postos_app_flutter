import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/driver.dart';
import '../models/vehicle.dart';
import '../providers/app_provider.dart';

import '../constants/colors.dart';
import '../constants/strings.dart';

import '../widgets/forms/custom_input.dart';
import '../widgets/forms/custom_dropdown.dart';
import '../widgets/home/welcome_container.dart';
import '../widgets/custom_flushbar_error.dart';
import '../widgets/custom_button.dart';
import 'driver_home.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  List<Widget> _buildDriverDocument(
      AppProvider appProvider, BuildContext context) {
    return [
      CustomInput(
        controller: appProvider.cpfController,
        keyboardType: TextInputType.number,
        textColor: ColorsConstants.textColor,
      ),
      CustomButton(
        label: HomeStrings.buttonSend,
        onPressed: () => _handleFetchDriver(context, appProvider),
        textColor: ColorsConstants.backgroundColor,
        buttonColor: ColorsConstants.primaryColor,
      ),
    ];
  }

  Future<void> _handleFetchDriver(
      BuildContext context, AppProvider appProvider) async {
    var navigator = Navigator.of(context);
    await appProvider.fetchDriver();
    if (appProvider.driverList != null && appProvider.driverList!.isNotEmpty) {
      final isConfirmed = await _confirmDriverDialog(
          navigator, appProvider.driverList![0].name);
      if (isConfirmed == true) {
        if (appProvider.driverList!.length == 1) {
          appProvider.selectDriver(appProvider.driverList![0]);
        }
      }
    }
  }

  Future<bool?> _confirmDriverDialog(
      NavigatorState navigator, String driverName) async {
    return await showDialog<bool>(
      context: navigator.context,
      builder: (BuildContext dialogContext) => AlertDialog(
        title: const Text(HomeStrings.dialogDriverTitle),
        content: Text(driverName),
        actions: [
          TextButton(
            onPressed: () => navigator.pop(false),
            child: const Text(HomeStrings.dialogOptionNo),
          ),
          TextButton(
            onPressed: () => navigator.pop(true),
            child: const Text(HomeStrings.dialogOptionYes),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildCompanySelection(
      AppProvider appProvider, BuildContext context) {
    return [
      CustomDropdown<DriverModel>(
        items: appProvider.driverList,
        hint: HomeStrings.inputHintCompany,
        onChanged: (value) {
          if (value != null) appProvider.selectDriver(value);
        },
        itemText: (item) => item.company.name,
      ),
      CustomButton(
        label: HomeStrings.labelBack,
        onPressed: appProvider.resetSelection,
        textColor: ColorsConstants.backgroundColor,
        buttonColor: ColorsConstants.primaryColor,
      ),
    ];
  }

  List<Widget> _buildVehicleSelection(
      AppProvider appProvider, BuildContext context) {
    return [
      CustomDropdown<VehicleModel>(
        items: appProvider.vehiclesList,
        hint: HomeStrings.inputHintVehicle,
        onChanged: (value) {
          if (value != null) appProvider.selectVehicle(value);
        },
        itemText: (item) =>
            '${item.plate} - ${item.manufacturer} / ${item.model}',
      ),
      CustomButton(
        label: HomeStrings.labelBack,
        onPressed: appProvider.resetSelection,
        textColor: ColorsConstants.backgroundColor,
        buttonColor: ColorsConstants.primaryColor,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        if (appProvider.selectedVehicle != null) {
          Future.delayed(Duration.zero, () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const DriverHome()),
            );
          });
        }
        return ValueListenableBuilder<String?>(
          valueListenable: appProvider.errorNotifier,
          builder: (context, errorMessage, _) {
            if (errorMessage != null) {
              customFlushBarError(errorMessage, context);
              appProvider.errorNotifier.value = null;
            }
            return Scaffold(
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Stack(
                  children: [
                    WelcomeContainer(textColor: ColorsConstants.textColor),
                    if (appProvider.isLoading)
                      const Center(child: CircularProgressIndicator()),
                    if (!appProvider.isLoading)
                      SingleChildScrollView(
                        padding: const EdgeInsets.only(top: 300),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (appProvider.selectedDriver == null &&
                                appProvider.driverList == null)
                              ..._buildDriverDocument(appProvider, context),
                            if (appProvider.selectedDriver == null &&
                                appProvider.driverList != null)
                              ..._buildCompanySelection(appProvider, context),
                            if (appProvider.selectedDriver != null &&
                                appProvider.selectedVehicle == null)
                              ..._buildVehicleSelection(appProvider, context),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
