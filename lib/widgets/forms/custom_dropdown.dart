import 'package:flutter/material.dart';

class CustomDropdown<T> extends StatelessWidget {
  final List<T>? items;
  final String hint;
  final ValueChanged<T?> onChanged;
  final String Function(T item) itemText;

  const CustomDropdown({
    Key? key,
    required this.items,
    required this.hint,
    required this.onChanged,
    required this.itemText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: DropdownButton<T>(
        isExpanded: true,
        hint: Text(hint),
        onChanged: onChanged,
        items: items!
            .map((e) => DropdownMenuItem(
                  value: e,
                  child: Text(itemText(e)),
                ))
            .toList(),
      ),
    );
  }
}
