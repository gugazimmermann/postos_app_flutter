import 'package:flutter/material.dart';
import '../../constants/strings.dart';

class CustomInput extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType keyboardType;
  final Color textColor;
  final Color borderColor;

  const CustomInput({
    super.key,
    required this.controller,
    required this.keyboardType,
    required this.textColor,
    required this.borderColor,
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
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
            labelText: SignInStrings.placeholderDocument,
            border: OutlineInputBorder(
              borderSide: BorderSide(color: borderColor, width: 2.0),
              borderRadius: BorderRadius.circular(8.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: borderColor, width: 2.0),
              borderRadius: BorderRadius.circular(8.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: borderColor, width: 2.0),
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
      ],
    );
  }
}
