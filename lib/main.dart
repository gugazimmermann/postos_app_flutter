import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'providers/app_provider.dart';

import 'constants/strings.dart';
import 'constants/colors.dart';

import 'widgets/custom_app_bar.dart';

import 'pages/sign_in.dart';
import 'pages/home_tabs.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Widget _buildDestinationWidget(AppProvider appProvider) {
    if (appProvider.selectedDriver != null &&
        appProvider.driverList != null &&
        appProvider.selectedVehicle != null &&
        appProvider.vehiclesList != null) {
      return const HomeTabs();
    } else {
      return const SignIn();
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: ColorsConstants.primaryColor,
    ));

    return ChangeNotifierProvider(
      create: (context) => AppProvider(),
      child: Consumer<AppProvider>(builder: (context, appProvider, child) {
        return MaterialApp(
          title: AppStrings.title,
          theme: ThemeData(
            primarySwatch: ColorsConstants.primarySwatch,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: Scaffold(
            appBar: CustomAppBar(
              isUserConnected: appProvider.selectedDriver != null &&
                  appProvider.driverList != null &&
                  appProvider.selectedVehicle != null &&
                  appProvider.vehiclesList != null,
            ),
            body: _buildDestinationWidget(appProvider),
          ),
        );
      }),
    );
  }
}
