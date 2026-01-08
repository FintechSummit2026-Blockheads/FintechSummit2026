import 'package:flutter/material.dart';
import 'package:mingle/styles/colors.dart';

class RoleSelector extends StatelessWidget {
  final bool isUser;
  final ValueChanged<bool> onChanged;

  const RoleSelector({
    super.key,
    required this.isUser,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ChoiceChip(
          label: const Text("User"),
          selected: isUser,
          selectedColor: secondary,
          labelStyle: TextStyle(
            color: isUser ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
          onSelected: (_) => onChanged(true),
        ),
        const SizedBox(width: 12),
        ChoiceChip(
          label: const Text("Restaurant"),
          selected: !isUser,
          selectedColor: secondary,
          labelStyle: TextStyle(
            color: !isUser ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
          onSelected: (_) => onChanged(false),
        ),
      ],
    );
  }
}
