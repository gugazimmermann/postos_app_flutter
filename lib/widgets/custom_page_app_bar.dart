import 'package:flutter/material.dart';

import '../constants/colors.dart';

class CustomPageAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomPageAppBar({
    super.key,
    required this.title,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: ColorsConstants.white,
      titleTextStyle: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 21,
        color: ColorsConstants.textColor,
      ),
      title: Text(title),
    );
  }
}
