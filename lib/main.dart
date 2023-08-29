import 'package:flutter/material.dart';
import 'constants/colors.dart';
import 'constants/constants.dart';
import 'pages/home.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.title,
      theme: ThemeData(
        primarySwatch: ColorsConstants.primarySwatch,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HomePage(),
    );
  }
}
