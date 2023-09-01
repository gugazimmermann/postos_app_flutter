import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:permission_handler/permission_handler.dart';

import '../constants/colors.dart';
import '../utils/shared_preferences.dart';

class NotificationProvider {
  final FlutterLocalNotificationsPlugin notifications =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    await _initializeNotifications();
  }

  Future<void> _initializeNotifications() async {
    await Permission.notification.request();

    const AndroidInitializationSettings settingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_notification');

    const DarwinInitializationSettings settingsIOS =
        DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );

    const InitializationSettings initSettings =
        InitializationSettings(android: settingsAndroid, iOS: settingsIOS);

    await notifications.initialize(initSettings);
  }

  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'touch_sistemas_postos',
      'Touch Sistemas Postos',
      channelDescription: 'Touch Sistemas Postos Notificações',
      importance: Importance.max,
      priority: Priority.high,
      color: ColorsConstants.primaryColor,
      icon: '@mipmap/ic_notification',
    );

    const DarwinNotificationDetails iOSDetails = DarwinNotificationDetails(
      sound: 'default',
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iOSDetails,
    );

    await notifications.show(
      id,
      title,
      body,
      notificationDetails,
    );

    await PreferencesHelper.incrementNotificationsCount();
    bool isSupported = await FlutterAppBadger.isAppBadgeSupported();
    if (isSupported) {
      int badgeCount = await PreferencesHelper.getNotificationsCount();
      FlutterAppBadger.updateBadgeCount(badgeCount);
    }
  }

  Future<void> clearAllUnreadNotifications() async {
    await PreferencesHelper.clearNotificationsCount();
    bool isSupported = await FlutterAppBadger.isAppBadgeSupported();
    if (isSupported) {
      FlutterAppBadger.removeBadge();
    }
  }
}
