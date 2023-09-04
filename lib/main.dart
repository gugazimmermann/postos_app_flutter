import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'firebase_options.dart';
import 'providers/app_provider.dart';

import 'constants/strings.dart';
import 'constants/colors.dart';

import 'widgets/custom_app_bar.dart';

import 'pages/sign_in.dart';
import 'pages/home_tabs.dart';

import 'utils/log.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  Widget _buildDestinationWidget(AppProvider appProvider) {
    if (appProvider.signInProvider.isUserConnected) {
      return const HomeTabs();
    } else {
      return const SignIn();
    }
  }

  void _handleFirebaseMessagingToken(BuildContext context) async {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    await FirebaseMessaging.instance.setAutoInitEnabled(true);
    logger.d("FCMToken $fcmToken");
  }

  @override
  Widget build(BuildContext context) {
    _handleFirebaseMessagingToken(context);
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
              isUserConnected: appProvider.signInProvider.isUserConnected,
            ),
            body: _buildDestinationWidget(appProvider),
          ),
        );
      }),
    );
  }
}
