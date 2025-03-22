import 'package:flutter/material.dart';

Widget BuildLegendItem(String title, Color color, String count) {
  return Row(
    children: [
      CircleAvatar(
        radius: 5,
        backgroundColor: color,
      ),
      const SizedBox(width: 8),
      Text(
        title,
        style: const TextStyle(fontSize: 14),
      ),
      const SizedBox(width: 8),
      Text(
        count,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      ),
    ],
  );
}
