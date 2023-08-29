import 'package:flutter/material.dart';
import '../../constants/constants.dart';

class WelcomeContainer extends StatelessWidget {
  final Color textColor;

  const WelcomeContainer({super.key, required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 36,
      left: 0,
      right: 0,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/logos/logo144.png'),
            const SizedBox(height: 12),
            Text(
              AppConstants.welcome,
              style: TextStyle(
                fontSize: 24,
                color: textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              AppConstants.title,
              style: TextStyle(
                fontSize: 28,
                color: textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
