import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../constants/strings.dart';

class NotificationDialog extends StatelessWidget {
  final RemoteMessage message;

  const NotificationDialog({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    String? imageUrl = message.notification!.android!.imageUrl;
    String? extension = imageUrl?.split('.').last;
    bool isValidImage = extension != null &&
        (extension == 'png' || extension == 'jpg' || extension == 'webp');
    return AlertDialog(
      title: Text(message.notification!.title ?? 'Notificação',
          style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 21.0,
              color: ColorsConstants.textColor)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (imageUrl != null && isValidImage) Image.network(imageUrl),
          Text(message.notification!.body ?? '',
              style: const TextStyle(
                  fontSize: 16.0, color: ColorsConstants.textColor)),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text(GeneralStrings.buttonClose),
        ),
      ],
    );
  }
}
