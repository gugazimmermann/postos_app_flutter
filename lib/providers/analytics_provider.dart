import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';

import '../models/driver.dart';
import '../models/vehicle.dart';

class AnalyticsProvider with ChangeNotifier {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
  FirebaseAnalytics get analytics => _analytics;

  Future<void> logLogin(DriverModel? driver, VehicleModel? vehicle) async {
    _analytics.logEvent(name: 'login', parameters: {
      "driverID": driver?.id,
      "vehicleID": vehicle?.id,
    });
  }
}
