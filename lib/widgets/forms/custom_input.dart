import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../constants/strings.dart';

class CustomInput extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType keyboardType;
  final Color textColor;

  const CustomInput({
    super.key,
    required this.controller,
    required this.keyboardType,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          SignInStrings.labelDocument,
          style: TextStyle(
            fontSize: 21,
            color: textColor,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: const InputDecoration(
            contentPadding:
                EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
            labelText: SignInStrings.placeholderDocument,
            border: OutlineInputBorder(
              borderSide:
                  BorderSide(color: ColorsConstants.primaryColor, width: 2.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: ColorsConstants.primaryColor, width: 2.0),
            ),
          ),
        ),
      ],
    );
  }
}
