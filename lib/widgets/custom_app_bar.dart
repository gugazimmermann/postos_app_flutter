import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../constants/colors.dart';
import '../constants/strings.dart';
import 'config/user_dialog.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isUserConnected;

  const CustomAppBar({
    super.key,
    this.isUserConnected = false,
  });

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => UserDialog(dialogContext),
    );
  }

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
          const Expanded(
            child: Text(
              AppStrings.title,
              style: TextStyle(fontSize: 21, color: ColorsConstants.textColor),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      actions: [
        if (isUserConnected)
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
              icon: Icon(
                MdiIcons.cardAccountDetailsOutline,
                size: 36.0,
                color: ColorsConstants.textColor,
              ),
              onPressed: () => _showDialog(context),
            ),
          ),
      ],
      backgroundColor: ColorsConstants.white,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
