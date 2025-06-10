import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';

import '../constants/utils.dart';
import '../controllers/service_provider/provider_subscriptions_provider.dart';
import '../ui/screens/home_provider/waleetScreens/walletpaymentScreens.dart';
import '../ui/screens/payment_webview.dart';
import '../ui/widgets/home/appbar_home.dart';
import '../ui/widgets/my_requests/appbar_my_requests.dart';
import '../ui/widgets/sized_box.dart';

class PackageFeature {
  final String name;
  final String active;

  PackageFeature({
    required this.name,
    required this.active,
  });

  factory PackageFeature.fromJson(Map<String, dynamic> json) {
    return PackageFeature(
      name: json['name'],
      active: json['active'],
    );
  }
}

class Package {
  final int id;
  int color;
  final String name;
  final double price;
  final double oldPrice;
  final int validityMonths;
  final List<PackageFeature> features;
  final bool hasDiscount;
  final double discountPercentage;

  Package({
    required this.id,
    required this.color,
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
      color: json['color'],
      name: json['name'],
      price: (json['price'] as num).toDouble(),
      oldPrice: (json['old_price'] as num).toDouble(),
      validityMonths: json['validity_months'],
      features: (json['features'] as List)
          .map((f) => PackageFeature.fromJson(f))
          .toList(),
      hasDiscount: json['has_discount'] ?? false,
      discountPercentage: (json['discount_percentage'] ?? 0).toDouble(),
    );
  }
}

Future<List<Package>> fetchPackages() async {
  final response = await http.get(Uri.parse(
      'https://dev.ajeer.cloud/provider/new-packages?sort_order=asc'));
  print(response.body);
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
    final List<Color> mainColors = [
      Color(0xFF487AEB), // Blue
      Color(0xFFEFA711), // Yellow
      Color(0xFF55AE40), // Green
    ];
    final List<Color> opColors = [
      Color(0xFF749DF9), // Light Blue
      Color(0xFFF6CE40), // Light Yellow
      Color(0xFF61D147), // Light Green
    ];
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 72),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Image.asset(
                    'assets/Icons/IconProjectUser.png',
                    width: 35,
                    height: 35,
                  ),
                ),
                SizedBox(width: 15),
                Text(
                  "الباقات",
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                      color: Color(0xff1F1F1F)),
                ),
              ],
            ),
          ),
          SizedBoxedH24,
          Container(
            height: 2, // thickness of the divider
            decoration: BoxDecoration(
              color: Colors.white, // or any background color
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  offset: Offset(0, 2), // shadow only at bottom
                  blurRadius: 4,
                ),
              ],
            ),
          ),
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

                    final color = mainColors[index];
                    final colorop = opColors[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          PlanCard(
                            package_id: pkg.id,
                            colorFromPanel: pkg.color,
                            color: color,
                            colorop: colorop,
                            price: pkg.price,
                            oldPrice: '${pkg.oldPrice} دينار',
                            duration: pkg.validityMonths == 1
                                ? 'شهري'
                                : '${pkg.validityMonths} أشهر',
                            badgeText: pkg.hasDiscount
                                ? 'خصم ${pkg.discountPercentage.toStringAsFixed(0)}%'
                                : '',
                            badgeIcon: Icons.stars_rounded,
                            features: pkg.features,
                          ),
                          const SizedBox(height: 12),
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

class PlanCard extends StatelessWidget {
  final int package_id;
  final Color color;
  final Color colorop;
  final int colorFromPanel;
  final double price;
  final String oldPrice;
  final String duration;
  final String badgeText;
  final IconData badgeIcon;
  final List<PackageFeature> features;

  const PlanCard({
    super.key,
    required this.package_id,
    required this.color,
    required this.colorop,
    required this.colorFromPanel,
    required this.price,
    required this.oldPrice,
    required this.duration,
    required this.badgeText,
    required this.badgeIcon,
    required this.features,
  });

  // Badge Widget
  Widget specialBadge(
      {required String text,
      required Color color,
      required Color borderColor,
      required List<BoxShadow> boxShadow}) {
    return Container(
      width: 93,
      height: 30,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(
          color: borderColor,
          width: 4,
        ),
        // boxShadow: boxShadow,
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
              gradient: LinearGradient(
                colors: [color, colorop],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.15),
                  blurRadius: 8,
                ),
              ],
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 24, bottom: 8),
                  child: Column(
                    children: [
                      Text(
                        price.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 24,
                        ),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Text(
                        oldPrice,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 18,
                          decoration: TextDecoration.lineThrough,
                          decorationColor: Colors.white,
                        ),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Text(
                        duration,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
                // مساحة للصورة فوق الخط الفاصل
                SizedBox(height: 20),
                // الميزات
                Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.only(
                          right: 24,
                          left: 24,
                          top: colorFromPanel == 3 ? 40 : 80,
                          bottom: 24),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.vertical(bottom: Radius.circular(32)),
                      ),
                      child: Column(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: features
                                .map(
                                  (feature) => Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 4),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Icon(Icons.check_circle,
                                            color: feature.active == "1"
                                                ? color
                                                : Color(0xffD5D1E1),
                                            size: 14),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            feature.name,
                                            textAlign: TextAlign.right,
                                            style: TextStyle(
                                                color: color,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                          const SizedBox(height: 30),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () async{
                                    // TODO: Add your action here
                                    ResponseHandler<String> response =
                                        await Provider.of<
                                        ProviderSubscriptions>(
                                        context,
                                        listen: false)
                                        .subscribetylink(
                                        packageId: package_id);

                                    if (response.status ==
                                        ResponseStatus.success) {
                                      // TODO: Add your action here
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  SubscriptionPaymentScreen(
                                                    selectedUrl:
                                                    "https://test-buyer.tlync.ly/tdi/xyZWOj8wJ57VyPp1LvgG8n3eMBYb24GJ9aARo0zOKa9WqdjlmxD6NZQXEJRqw0nG",
                                                  )));

                                    } else if (response.errorMessage != null) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                          content: Text(
                                              response.errorMessage!)));
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                          content:
                                          Text('Error Occurred'.tr())));
                                    }

                                  },
                                  style: OutlinedButton.styleFrom(
                                      side: BorderSide(
                                        color: color,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      // foregroundColor: color,
                                      backgroundColor: color),
                                  child: Text(
                                    'اشترك الان',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () async {

                                    // TODO: Add your action here
                                    ResponseHandler<String> response =
                                        await Provider.of<
                                                    ProviderSubscriptions>(
                                                context,
                                                listen: false)
                                            .subscribeToAPackage(
                                                packageId: package_id);

                                    if (response.status ==
                                        ResponseStatus.success) {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  WalletPaymentScreen(
                                                    package_id: package_id,
                                                  )));
                                    } else if (response.errorMessage != null) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(
                                                  response.errorMessage!)));
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content:
                                                  Text('Error Occurred'.tr())));
                                    }
                                  },
                                  style: OutlinedButton.styleFrom(
                                    side: BorderSide(
                                      color: color,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    //foregroundColor: color,
                                  ),
                                  child: Text(
                                    'الاشتراك بالمحفظة',
                                    style: TextStyle(
                                      color: color,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // الأيقونة الزرقاء في منتصف البطاقة وعلى الخط الفاصل
          Positioned(
            top: 132, // عدّل الرقم حسب الحاجة
            left: 0,
            right: 0,
            child: (colorFromPanel == 1)
                ? Center(
                    child: Image.asset(
                      'assets/Icons/blue_star.png',
                      width: 60,
                      height: 60,
                    ),
                  )
                : (colorFromPanel == 2)
                    ? Center(
                        child: Image.asset(
                          'assets/Icons/gold_star.png',
                          width: 60,
                          height: 60,
                        ),
                      )
                    : Center(
                        child: Image.asset(
                          'assets/Icons/green_star.png',
                          width: 60,
                          height: 60,
                        ),
                      ),
          ),
          // الشارة الخاصة (badge)
          Positioned(
            top: 195, // عدّل الرقم حسب الحاجة ليكون أسفل الأيقونة الزرقاء
            left: 0,
            right: 0,
            child: Center(
              child: (colorFromPanel == 1)
                  ? specialBadge(
                      text: 'فني مميز',
                      color: const Color(0xFF719BF8),
                      borderColor: const Color(0xFF4174E8),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF5B9EFF).withOpacity(0.35),
                          blurRadius: 40,
                          spreadRadius: 10,
                        ),
                      ],
                    )
                  : (colorFromPanel == 2)
                      ? specialBadge(
                          text: 'فني محترف',
                          color: const Color(0xFFEE9F07).withAlpha(150),
                          borderColor: const Color(0xFFEFA711).withAlpha(150),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFEFA711).withOpacity(0.25),
                              blurRadius: 40,
                              spreadRadius: 10,
                            ),
                          ],
                        )
                      : SizedBox(),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom Bottom Sheet for Call Confirmation
void showCallBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(32),
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 32.0, bottom: 24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Icon in circle
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Image.asset(
                          'assets/Icons/call_plus.png', // <-- Use your call+ icon asset here
                          width: 40,
                          height: 40,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Title
                    Text(
                      'هل ترغب في بدء المكالمة الآن؟',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Color(0xff232F3E),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Description
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'يتم إجراء المكالمة من خلال التطبيق لضمان التوثيق وحفظ الحقوق لك وللعميل.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xff7B7B7B),
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Call Button
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            showCallBottomSheet(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFE04836),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: Text(
                            'بدء المكالمة',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Close button
              Positioned(
                top: 16,
                left: 16,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: Icon(Icons.close, color: Color(0xff7B7B7B)),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
