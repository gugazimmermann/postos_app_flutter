import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/constants.dart';
import '../providers/app_provider.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Color backgroundColor;
  final bool isUserConnected;

  const CustomAppBar({
    super.key,
    required this.backgroundColor,
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
              appProvider.resetSelection();
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
          const Text(AppConstants.title),
        ],
      ),
      actions: [
        if (isUserConnected)
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => _showLogoutDialog(context),
          ),
      ],
      backgroundColor: backgroundColor,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
