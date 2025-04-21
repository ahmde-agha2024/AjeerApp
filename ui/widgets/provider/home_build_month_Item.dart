import 'package:flutter/material.dart';

Widget BuildMonthItem(String month, bool isSelected) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    decoration: BoxDecoration(
      color: isSelected ? Colors.black : Colors.grey.shade200,
      borderRadius: BorderRadius.circular(16),
    ),
    child: Text(
      month,
      style: TextStyle(
        color: isSelected ? Colors.white : Colors.black,
      ),
    ),
  );
}
