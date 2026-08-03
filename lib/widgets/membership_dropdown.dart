import 'package:flutter/material.dart';

class MembershipDropdown extends StatelessWidget {
  final String value;
  final ValueChanged<String?> onChanged;

  const MembershipDropdown({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
  initialValue: value,
  decoration: InputDecoration(
    labelText: "Abonement",
    prefixIcon: const Icon(Icons.workspace_premium),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
    ),
    filled: true,
  ),
      items: const [
        DropdownMenuItem(
          value: "1 oy",
          child: Text("1 oy"),
        ),
        DropdownMenuItem(
          value: "3 oy",
          child: Text("3 oy"),
        ),
        DropdownMenuItem(
          value: "6 oy",
          child: Text("6 oy"),
        ),
        DropdownMenuItem(
          value: "12 oy",
          child: Text("12 oy"),
        ),
      ],
      onChanged: onChanged,
    );
  }
}