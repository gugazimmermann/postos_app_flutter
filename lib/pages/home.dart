import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/driver.dart';
import '../models/vehicle.dart';
import '../providers/home_provider.dart';

import '../constants/colors.dart';
import '../constants/strings.dart';

import '../widgets/forms/custom_input.dart';
import '../widgets/forms/custom_dropdown.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/home/welcome_container.dart';
import '../widgets/custom_snackbar_error.dart';
import '../widgets/custom_button.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future<void> _handleFetchDriver(
      BuildContext context, HomeProvider homeProvider) async {
    var navigator = Navigator.of(context);
    await homeProvider.fetchDriver();
    if (homeProvider.driverList != null) {
      final isConfirmed = await _confirmDriverDialog(
          navigator, homeProvider.driverList![0].name);
      if (isConfirmed == true) {
        if (homeProvider.driverList!.length == 1) {
          homeProvider.selectDriver(homeProvider.driverList![0]);
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

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HomeProvider(),
      child: Consumer<HomeProvider>(
        builder: (context, homeProvider, child) {
          return ValueListenableBuilder<String?>(
            valueListenable: homeProvider.errorNotifier,
            builder: (context, errorMessage, _) {
              if (errorMessage != null) {
                Future.delayed(Duration.zero, () {
                  customSnackBarError(errorMessage, context);
                  homeProvider.errorNotifier.value = null;
                });
              }
              return Scaffold(
                appBar: CustomAppBar(
                    backgroundColor: ColorsConstants.backgroundColor),
                body: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Stack(
                    children: [
                      WelcomeContainer(textColor: ColorsConstants.textColor),
                      if (homeProvider.isLoading) ...[
                        const Center(child: CircularProgressIndicator()),
                      ] else ...[
                        SingleChildScrollView(
                          padding: const EdgeInsets.only(top: 300),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (homeProvider.selectedDriver == null &&
                                  homeProvider.driverList == null) ...[
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CustomInput(
                                      controller: homeProvider.cpfController,
                                      keyboardType: TextInputType.number,
                                      textColor: ColorsConstants.textColor,
                                    ),
                                    CustomButton(
                                      label: HomeStrings.buttonSend,
                                      onPressed: () => _handleFetchDriver(
                                          context, homeProvider),
                                      textColor:
                                          ColorsConstants.backgroundColor,
                                      buttonColor: ColorsConstants.primaryColor,
                                    ),
                                  ],
                                ),
                              ],
                              if (homeProvider.selectedDriver == null &&
                                  homeProvider.driverList != null) ...[
                                CustomDropdown<DriverModel>(
                                  items: homeProvider.driverList,
                                  hint: HomeStrings.inputHintCompany,
                                  onChanged: (value) async {
                                    if (value == null) return;
                                    homeProvider.selectDriver(value);
                                  },
                                  itemText: (item) => item.company.name,
                                ),
                                CustomButton(
                                  label: HomeStrings.labelBack,
                                  onPressed: homeProvider.resetSelection,
                                  textColor: ColorsConstants.backgroundColor,
                                  buttonColor: ColorsConstants.primaryColor,
                                ),
                              ],
                              if (homeProvider.selectedDriver != null &&
                                  homeProvider.selectedVehicle == null) ...[
                                CustomDropdown<VehicleModel>(
                                  items: homeProvider.vehiclesList,
                                  hint: HomeStrings.inputHintVehicle,
                                  onChanged: (value) async {
                                    if (value == null) return;
                                    homeProvider.selectVehicle(value);
                                  },
                                  itemText: (item) =>
                                      '${item.plate} - ${item.manufacturer} / ${item.model}',
                                ),
                                CustomButton(
                                  label: HomeStrings.labelBack,
                                  onPressed: homeProvider.resetSelection,
                                  textColor: ColorsConstants.backgroundColor,
                                  buttonColor: ColorsConstants.primaryColor,
                                ),
                              ],
                              if (homeProvider.selectedDriver != null &&
                                  homeProvider.selectedVehicle != null) ...[
                                Text(
                                    'Motorista: ${homeProvider.selectedDriver!.name}'),
                                Text(
                                    'Empresa: ${homeProvider.selectedDriver!.company.name}'),
                                Text(
                                    'Veículo: ${homeProvider.selectedVehicle!.plate} - ${homeProvider.selectedVehicle!.manufacturer} / ${homeProvider.selectedVehicle!.model}'),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
