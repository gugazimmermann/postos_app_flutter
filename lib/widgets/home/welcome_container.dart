import 'package:flutter/material.dart';

import '../../constants/strings.dart';
import '../../constants/colors.dart';

class WelcomeContainer extends StatelessWidget {
  const WelcomeContainer({super.key});

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
            const Text(
              SignInStrings.welcome,
              style: TextStyle(
                fontSize: 24,
                color: ColorsConstants.textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              AppStrings.title,
              style: TextStyle(
                fontSize: 28,
                color: ColorsConstants.textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
