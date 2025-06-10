import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class allCategory extends StatelessWidget {
  String title;
  String imagePath;
  VoidCallback onTapClick;

  allCategory({
    super.key,
    required this.title,
    required this.imagePath,
    required this.onTapClick,
  });



  @override
  Widget build(BuildContext context) {
    // Original circular design for other categories
    return InkWell(
      onTap: onTapClick,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(0.1),
            ),
            child: ClipOval(
              child: Image.network(
                imagePath,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: 80,
            child: Text(
              title.tr(),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}

class DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    const dashWidth = 5.0;
    const dashSpace = 5.0;
    double startX = 0;
    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, 0),
        Offset(startX + dashWidth, 0),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
