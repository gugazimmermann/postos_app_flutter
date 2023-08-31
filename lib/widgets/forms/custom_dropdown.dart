import 'package:flutter/material.dart';

import '../../constants/colors.dart';

class CustomDropdown<T> extends StatelessWidget {
  final List<T>? items;
  final String hint;
  final ValueChanged<T?> onChanged;
  final String Function(T item) itemText;
  final Color textColor;
  final Color borderColor;

  const CustomDropdown({
    Key? key,
    required this.items,
    required this.hint,
    required this.onChanged,
    required this.itemText,
    required this.textColor,
    required this.borderColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: borderColor, width: 2.0),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          dropdownColor: ColorsConstants.white,
          isExpanded: true,
          hint: Text(hint, style: TextStyle(color: textColor)),
          onChanged: onChanged,
          items: items!
              .map((e) => DropdownMenuItem(
                    value: e,
                    child:
                        Text(itemText(e), style: TextStyle(color: textColor)),
                  ))
              .toList(),
        ),
      ),
    );
  }
}
