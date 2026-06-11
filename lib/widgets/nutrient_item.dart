import 'package:flutter/material.dart';

class NutrientItem extends StatelessWidget {
  final String label;
  final String value;
  final String unit;

  const NutrientItem({
    super.key,
    required this.label,
    required this.value,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black54,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 1),
        Text(
          unit,
          style: const TextStyle(
            fontSize: 10,
            color: Colors.black38,
          ),
        ),
      ],
    );
  }
}
