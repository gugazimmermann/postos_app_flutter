import 'package:flutter/material.dart';
import 'package:postos_flutter_app/constants/colors.dart';
import 'package:provider/provider.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../constants/strings.dart';

import '../providers/app_provider.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isUserConnected;

  const CustomAppBar({
    super.key,
    this.isUserConnected = false,
  });

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text("Sair"),
        content: const Text("Você deseja sair?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text("Cancelar"),
          ),
          TextButton(
            onPressed: () {
              final appProvider =
                  Provider.of<AppProvider>(context, listen: false);
              appProvider.signInProvider.resetSelection();
              Navigator.of(dialogContext).pop();
            },
            child: const Text("Sair"),
          ),
        ],
      ),
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
          const Text(AppStrings.title,
              style: TextStyle(fontSize: 21, color: ColorsConstants.textColor)),
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
              onPressed: () => _showLogoutDialog(context),
            ),
          ),
      ],
      backgroundColor: ColorsConstants.white,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
