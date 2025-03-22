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

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTapClick,
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
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
              '${title.tr()}',
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
