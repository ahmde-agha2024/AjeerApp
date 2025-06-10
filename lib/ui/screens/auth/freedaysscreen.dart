import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

import '../../../controllers/common/auth_provider.dart';
import 'auth_screen.dart';

class FreeDaysScreen extends StatelessWidget {
  const FreeDaysScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // يمكنك استبدال AssetImage بالمسار الصحيح لشعار أجير وصورة علامة الصح إذا كانت لديك صور أصلية
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 30,),
            // شعار أجير في الأعلى
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Image.asset(
                  'assets/Icons/logo.png', // ضع مسار شعار أجير هنا
                  width: 106,
                  height: 43,
                ),
              ),
            ),
            const SizedBox(height: 40),
            // دائرة علامة الصح
            Image.asset(
              'assets/Icons/approved 1.png', // ضع مسار شعار أجير هنا
              width: 232,
              height: 232,
            ),
            const SizedBox(height: 32),
            // النص الرئيسي
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  Text(
                    'مبروك! لقد حصلت على 15 يوماً من الاستخدام المجاني.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Color(0xff636363),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'شكرًا لتقديم بياناتك! سيتم مراجعة بيانات حسابك خلال 24 ساعة كحد أقصى.\nبعد التأكد من صحتها، سيتواصل معك فريق أجير لتفعيل الحساب في أقرب وقت ممكن.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xff636363),
                    ),
                  ),
                ],
              ),
            ),

            // زر بدء الاستخدام
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff232323),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => context.read<Auth>().isProvider
                            ? AuthScreen()
                            : AuthScreen(),
                      ),
                          (route) => false,
                    );
                  },
                  child: Text(
                    'بدء الاستخدام',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
