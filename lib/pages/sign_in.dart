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

import 'home_tabs.dart';

class SignIn extends StatelessWidget {
  const SignIn({super.key});

  List<Widget> _buildDriverDocument(
      AppProvider appProvider, BuildContext context) {
    return [
      CustomInput(
        controller: appProvider.cpfController,
        keyboardType: TextInputType.number,
        textColor: ColorsConstants.textColor,
      ),
      CustomButton(
        label: GeneralStrings.buttonSend,
        onPressed: () => _handleFetchDriver(context, appProvider),
        textColor: ColorsConstants.white,
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
        title: const Text(SignInStrings.dialogDriverTitle),
        content: Text(driverName),
        actions: [
          TextButton(
            onPressed: () => navigator.pop(false),
            child: const Text(GeneralStrings.optionNo),
          ),
          TextButton(
            onPressed: () => navigator.pop(true),
            child: const Text(GeneralStrings.optionYes),
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
        hint: SignInStrings.inputHintCompany,
        onChanged: (value) {
          if (value != null) appProvider.selectDriver(value);
        },
        itemText: (item) => item.company.name,
      ),
      CustomButton(
        label: GeneralStrings.buttonBack,
        onPressed: appProvider.resetSelection,
        textColor: ColorsConstants.white,
        buttonColor: ColorsConstants.primaryColor,
      ),
    ];
  }

  List<Widget> _buildVehicleSelection(
      AppProvider appProvider, BuildContext context) {
    return [
      CustomDropdown<VehicleModel>(
        items: appProvider.vehiclesList,
        hint: SignInStrings.inputHintVehicle,
        onChanged: (value) {
          if (value != null) appProvider.selectVehicle(value);
        },
        itemText: (item) =>
            '${item.plate} - ${item.manufacturer} / ${item.model}',
      ),
      CustomButton(
        label: GeneralStrings.buttonSend,
        onPressed: appProvider.resetSelection,
        textColor: ColorsConstants.white,
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
              MaterialPageRoute(builder: (context) => const HomeTabs()),
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
                    const WelcomeContainer(),
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
