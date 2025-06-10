import 'package:flutter/material.dart';

class TestUserCardScreen extends StatelessWidget {
  const TestUserCardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: TestUserCard(),
      ),
    );
  }
}

class TestUserCard extends StatelessWidget {
  const TestUserCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // البطاقة الأساسية
          Container(
            width: 240,
            padding:
                const EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.10),
                  blurRadius: 32,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // أيقونة المزيد
                Align(
                  alignment: Alignment.topRight,
                  child: Row(
                    children: [
                      Image.asset(
                        "assets/Icons/Iconsmore.png",
                        height: 18,
                        width: 18,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                // الاسم
                const Text(
                  'محمد علي',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: Color(0xff242728),
                  ),
                ),
                const SizedBox(height: 4),
                // الوظيفة
                const Text(
                  'فني تكييف',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    color: Color(0xff929B9C),
                  ),
                ),
                const SizedBox(height: 28),
                // التقييم وأزرار المحادثة والاتصال
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    // زر الاتصال
                    Image.asset(
                      "assets/Icons/Iconcall.png",
                      height: 38,
                      width: 38,
                    ),

                    // زر المحادثة
                    Image.asset(
                      "assets/Icons/Iconchat.png",
                      height: 38,
                      width: 38,
                    ),
                    // التقييم
                    Row(
                      children: const [
                        Text(
                          '(4.7)',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                            color: Color(0xff77838F),
                          ),
                        ),
                        SizedBox(width: 4),

                        Icon(Icons.star, color: Color(0xffFFC529), size: 28),

                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          // صورة البروفايل الدائرية (تتجاوز البطاقة من الأعلى)
          Positioned(
            top: -50,
            left: 0,
            right: 0,
            child: Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(

                  'https://images.pexels.com/photos/1707828/pexels-photo-1707828.jpeg', // يمكنك تغيير الرابط لصورة أخرى

                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
