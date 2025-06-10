import 'dart:ui';
import 'dart:convert';
import 'package:http/http.dart' as http;

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

class Package {
  final int id;
  final String name;
  final double price;
  final double oldPrice;
  final int validityMonths;
  final List<String> features;
  final bool hasDiscount;
  final double discountPercentage;

  Package({
    required this.id,
    required this.name,
    required this.price,
    required this.oldPrice,
    required this.validityMonths,
    required this.features,
    required this.hasDiscount,
    required this.discountPercentage,
  });

  factory Package.fromJson(Map<String, dynamic> json) {
    return Package(
      id: json['id'],
      name: json['name'],
      price: (json['price'] as num).toDouble(),
      oldPrice: (json['old_price'] as num).toDouble(),
      validityMonths: json['validity_months'],
      features: List<String>.from(json['features']),
      hasDiscount: json['has_discount'],
      discountPercentage: (json['discount_percentage'] as num).toDouble(),
    );
  }
}

Future<List<Package>> fetchPackages() async {
  final response = await http.get(Uri.parse('https://dev.ajeer.cloud/provider/packages'));
  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    final List packagesJson = data['data'];
    return packagesJson.map((json) => Package.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load packages');
  }
}

class PlansScreen extends StatelessWidget {
  const PlansScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ... your app bar and header code ...
          Expanded(
            child: FutureBuilder<List<Package>>(
              future: fetchPackages(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('حدث خطأ أثناء جلب البيانات'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('لا توجد باقات متاحة'));
                }
                final packages = snapshot.data!;
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  itemCount: packages.length,
                  itemBuilder: (context, index) {
                    final pkg = packages[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Column(
                        children: [
                          // PlanCard(
                          //   color: Color(0xFF487AEB), // You can set color based on index or data
                          //   colorop: Color(0xFF749DF9),
                          //   price: '${pkg.price} دينار',
                          //   oldPrice: '${pkg.oldPrice} دينار',
                          //   duration: '${pkg.validityMonths} أشهر',
                          //   badgeText: pkg.hasDiscount ? 'خصم ${pkg.discountPercentage.toStringAsFixed(0)}%' : '',
                          //   badgeIcon: Icons.stars_rounded,
                          //   features: pkg.features,
                          // ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: OutlinedButton(
                              onPressed: () {
                                // TODO: Add your action here
                              },
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Color(0xFF3B6ED5), width: 2),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                foregroundColor: const Color(0xFF3B6ED5),
                                textStyle: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 24,
                                ),
                              ),
                              child: const Text(
                                'اطلب الآن',
                                style: TextStyle(
                                  color: Color(0xFF3B6ED5),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 24,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
