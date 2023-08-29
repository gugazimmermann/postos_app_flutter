import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';
import '../constants/colors.dart';

void customSnackBarError(String message, BuildContext context) {
  Flushbar(
    messageText: Row(
      children: [
        const Icon(Icons.error_outline, color: Colors.white),
        const SizedBox(width: 8.0),
        Expanded(
            child: Text(message,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold))),
      ],
    ),
    backgroundColor: ColorsConstants.danger,
    flushbarPosition: FlushbarPosition.TOP,
    margin: const EdgeInsets.all(8.0),
    borderRadius: BorderRadius.circular(8.0),
    duration: const Duration(seconds: 5),
  ).show(context);
}
