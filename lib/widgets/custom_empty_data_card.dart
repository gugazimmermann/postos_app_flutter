import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../constants/constants.dart';

class EmptyDataCard extends StatelessWidget {
  const EmptyDataCard({
    super.key,
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Card(
        elevation: Lists.elevation,
        shape: Lists.shape,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ColorsConstants.danger,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
