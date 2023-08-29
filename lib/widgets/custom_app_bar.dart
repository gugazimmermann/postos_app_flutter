import 'package:flutter/material.dart';
import '../constants/constants.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Color backgroundColor;

  const CustomAppBar({super.key, required this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        children: [
          Image.asset(
            'assets/logos/logo36.png',
            fit: BoxFit.cover,
            height: 40.0,
          ),
          const SizedBox(width: 12),
          const Text(AppConstants.title),
        ],
      ),
      backgroundColor: backgroundColor,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
