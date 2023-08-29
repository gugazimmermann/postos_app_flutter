import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'pages/driver_home.dart';
import 'providers/app_provider.dart';
import 'constants/colors.dart';
import 'constants/constants.dart';
import 'widgets/custom_app_bar.dart';
import 'pages/home.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Widget _buildDestinationWidget(AppProvider appProvider) {
    if (appProvider.selectedDriver != null &&
        appProvider.driverList != null &&
        appProvider.selectedVehicle != null &&
        appProvider.vehiclesList != null) {
      return const DriverHome();
    } else {
      return const HomePage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppProvider(),
      child: Consumer<AppProvider>(builder: (context, appProvider, child) {
        return MaterialApp(
          title: AppConstants.title,
          theme: ThemeData(
            primarySwatch: ColorsConstants.primarySwatch,
            primaryColor: ColorsConstants.primaryColor,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: Scaffold(
            appBar: CustomAppBar(
              backgroundColor: ColorsConstants.primaryColor,
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
