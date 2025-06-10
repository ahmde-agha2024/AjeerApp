import 'package:ajeer/models/customer/service_provider_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';

import '../../../NewDesign/blue_Provider.dart';
import '../../../constants/my_colors.dart';
import '../../../controllers/general/review_pass_provider.dart';
import '../../../models/common/chat_model.dart';
import '../../screens/provider_details_screen.dart';
import '../../screens/single_chat_screen.dart';
import '../button_styles.dart';
import '../provider/dialogcall.dart';
import '../show_report_to_admin.dart';

class ProviderProfileCardAll extends StatelessWidget {
  ServiceProvider serviceProvider;

  ProviderProfileCardAll({super.key, required this.serviceProvider});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.18),
                blurRadius: 32,
                offset: const Offset(0, 8),
              ),
            ],

          ),

          child: Column(
            children: [
              const SizedBox(height: 24),
              // صورة المزود
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Column(
                      children: [
                        Text(
                                        serviceProvider.name.length<=12?
                                        serviceProvider.name:serviceProvider.name.substring(0,10),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff232323),
                          ),
                        ),
                        SizedBox(height: 5,),
                        Text(
                          serviceProvider.category!.title.length<=20?
                          serviceProvider.category!.title:serviceProvider.category!.title.substring(0,10),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff636363),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 16),

                    CircleAvatar(
                      radius: 40,
                      backgroundImage:
                           NetworkImage(serviceProvider.image!)

                    ),
                    // اسم المزود

                  ],
                ),
              ),
              const SizedBox(height: 24),
              // زر عرض الملف
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xffE04836),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(28),
                    bottomRight: Radius.circular(28),
                  ),
                ),
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BlueProviderScreen(
                              providerId: serviceProvider.id,
                              serviceProvider: serviceProvider,
                            )));
                  },
                  child: const Text(
                    'عرض الملف',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

