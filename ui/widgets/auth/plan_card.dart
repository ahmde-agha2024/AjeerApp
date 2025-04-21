import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../constants/my_colors.dart';

// Custom Painter to create a dashed border
class DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashLength;
  final double dashGap;

  DashedBorderPainter({
    required this.color,
    this.strokeWidth = 5.0,
    this.dashLength = 10.0,
    this.dashGap = 5.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final Path path = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        Radius.circular(10), // Border radius
      ));

    _drawDashedLine(canvas, path, paint);
  }

  void _drawDashedLine(Canvas canvas, Path path, Paint paint) {
    final PathMetrics pathMetrics = path.computeMetrics();
    for (PathMetric pathMetric in pathMetrics) {
      double distance = 0.0;
      while (distance < pathMetric.length) {
        final double nextDistance = distance + dashLength;
        canvas.drawPath(
          pathMetric.extractPath(distance, nextDistance),
          paint,
        );
        distance = nextDistance + dashGap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class PlanCard extends StatelessWidget {
  final int planIndex;
  final String svgAsset;
  final String planName;
  final String requests;
  final String price;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const PlanCard({
    Key? key,
    required this.planIndex,
    required this.svgAsset,
    required this.planName,
    required this.requests,
    required this.price,
    required this.color,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: isSelected ? null : BoxDecoration(borderRadius: BorderRadius.circular(10)),
        child: CustomPaint(
          painter: isSelected
              ? DashedBorderPainter(
                  color: MyColors.MainBulma,
                  strokeWidth: 5.0,
                  dashLength: 8.0,
                  dashGap: 4.0,
                )
              : null, // Apply dashed border only if selected
          child: Card(
            margin: EdgeInsets.zero,
            color: color,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
              child: Column(
                children: [
                  SvgPicture.asset(svgAsset),
                  const SizedBox(height: 8),
                  Text(
                    planName,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: MyColors.MainGohan,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    requests,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: MyColors.MainGohan,

                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    price,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: MyColors.MainGohan,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
