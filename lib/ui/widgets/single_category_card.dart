import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class SingleCategoryCard extends StatelessWidget {
  String title;
  String imagePath;
  VoidCallback onTapClick;

  SingleCategoryCard({
    super.key,
    required this.title,
    required this.imagePath,
    required this.onTapClick,
  });

  bool _isSpecialService(String title) {
    List<String> specialServices = [
      "أعطال الأجهزة الكهربائية",
      "أعمال يدوية",
      "أعمال تنظيف",
      "خدمات متفرقة",
      "بستنة حدائق و مزروعات",
      "العناية النسائية",
      "خدمات المركبات"
    ];
    return specialServices.contains(title);
  }

  @override
  Widget build(BuildContext context) {
    if (_isSpecialService(title)) {
      return InkWell(
        onTap: onTapClick,
        child: Container(
          padding: EdgeInsets.all(4),
          width: 160,
          height: 220,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12), bottom: Radius.circular(12)),
                child: Image.network(
                  imagePath,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    CustomPaint(
                      size: Size(double.infinity, 1),
                      painter: DashedLinePainter(),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      title.tr(),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,

                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

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
