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

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  SignInState createState() => SignInState();
}

class SignInState extends State<SignIn> with WidgetsBindingObserver {
  bool isKeyboardVisible = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    final bottomInset = WidgetsBinding.instance.window.viewInsets.bottom;
    setState(() {
      isKeyboardVisible = bottomInset > 0.0;
    });
  }

  List<Widget> _buildDriverDocument(
      AppProvider appProvider, BuildContext context) {
    return [
      CustomInput(
        controller: appProvider.signInProvider.cpfController,
        keyboardType: TextInputType.number,
        textColor: ColorsConstants.textColor,
        borderColor: ColorsConstants.primaryColor,
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
    await appProvider.signInProvider.fetchDriver();
    if (appProvider.signInProvider.driverList != null &&
        appProvider.signInProvider.driverList!.isNotEmpty) {
      final isConfirmed = await _confirmDriverDialog(
          navigator, appProvider.signInProvider.driverList![0].name);
      if (isConfirmed == true) {
        if (appProvider.signInProvider.driverList!.length == 1) {
          appProvider.signInProvider
              .selectDriver(appProvider.signInProvider.driverList![0]);
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
        items: appProvider.signInProvider.driverList,
        hint: SignInStrings.inputHintCompany,
        onChanged: (value) {
          if (value != null) appProvider.signInProvider.selectDriver(value);
        },
        itemText: (item) => item.company.name,
        textColor: ColorsConstants.textColor,
        borderColor: ColorsConstants.primaryColor,
      ),
      CustomButton(
        label: GeneralStrings.buttonBack,
        onPressed: appProvider.signInProvider.resetSelection,
        textColor: ColorsConstants.white,
        buttonColor: ColorsConstants.primaryColor,
      ),
    ];
  }

  List<Widget> _buildVehicleSelection(
      AppProvider appProvider, BuildContext context) {
    return [
      CustomDropdown<VehicleModel>(
        items: appProvider.signInProvider.vehiclesList,
        hint: SignInStrings.inputHintVehicle,
        onChanged: (value) {
          if (value != null) appProvider.signInProvider.selectVehicle(value);
        },
        itemText: (item) =>
            '${item.plate} - ${item.manufacturer} / ${item.model}',
        textColor: ColorsConstants.textColor,
        borderColor: ColorsConstants.primaryColor,
      ),
      CustomButton(
        label: GeneralStrings.buttonSend,
        onPressed: appProvider.signInProvider.resetSelection,
        textColor: ColorsConstants.white,
        buttonColor: ColorsConstants.primaryColor,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        if (appProvider.signInProvider.selectedVehicle != null) {
          Future.delayed(Duration.zero, () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeTabs()),
            );
          });
        }
        return ValueListenableBuilder<String?>(
          valueListenable: appProvider.signInProvider.errorNotifier,
          builder: (context, errorMessage, _) {
            if (errorMessage != null) {
              customFlushBarError(errorMessage, context);
              appProvider.signInProvider.errorNotifier.value = null;
            }
            return Scaffold(
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Stack(
                  children: [
                    WelcomeContainer(isKeyboardVisible: isKeyboardVisible),
                    if (appProvider.signInProvider.isLoading)
                      const Center(child: CircularProgressIndicator()),
                    if (!appProvider.signInProvider.isLoading)
                      SingleChildScrollView(
                        padding:
                            EdgeInsets.only(top: isKeyboardVisible ? 150 : 300),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (appProvider.signInProvider.selectedDriver ==
                                    null &&
                                appProvider.signInProvider.driverList == null)
                              ..._buildDriverDocument(appProvider, context),
                            if (appProvider.signInProvider.selectedDriver ==
                                    null &&
                                appProvider.signInProvider.driverList != null)
                              ..._buildCompanySelection(appProvider, context),
                            if (appProvider.signInProvider.selectedDriver !=
                                    null &&
                                appProvider.signInProvider.selectedVehicle ==
                                    null)
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
