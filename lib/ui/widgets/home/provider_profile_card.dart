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

class ProviderProfileCard extends StatelessWidget {
  ServiceProvider serviceProvider;

  ProviderProfileCard({super.key, required this.serviceProvider});

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsetsDirectional.only(end: 8, top: 60, start: 5),
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => BlueProviderScreen(
                        providerId: serviceProvider.id,
                    serviceProvider: serviceProvider,
                      )));
        },
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // البطاقة الأساسية
            Container(
              width: 201,
              padding: const EdgeInsets.only(
                  top: 10, left: 20, right: 20, bottom: 24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.10),
                    blurRadius: 18,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: SingleChildScrollView(
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
                     Text(
                      serviceProvider.name,
                      maxLines: 1,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        color: Color(0xff242728),
                      ),
                    ),
                    const SizedBox(height: 4),
                    // الوظيفة
                     Text(
                      serviceProvider.category?.title??"",
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
                        InkWell(
                          onTap: (){
                            showCallBottomSheet(context, serviceProvider.phone);
                          },
                          child: Image.asset(
                            "assets/Icons/Iconcall.png",
                            height: 38,
                            width: 38,
                          ),
                        ),

                        // زر المحادثة
                        InkWell(
                          onTap: (){
                            // Navigator.of(context).push(MaterialPageRoute(
                            //     builder: (context) => SingleChatScreen(
                            //       chatHead: ChatHead(
                            //         provider: serviceProvider,
                            //         customer: serviceProvider.
                            //             .offer.service!.customer,
                            //       ),
                            //       service: serviceProvider.,
                            //     )));
                          },
                          child: Image.asset(
                            "assets/Icons/Iconchat.png",
                            height: 38,
                            width: 38,
                          ),
                        ),
                        // التقييم
                        Row(
                          children:  [
                            Text( serviceProvider.stars.toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 18,
                                color: Color(0xff77838F),
                              ),
                            ),
                            SizedBox(width: 4),
                            Icon(Icons.star,
                                color: Color(0xffFFC529), size: 28),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // صورة البروفايل الدائرية (تتجاوز البطاقة من الأعلى)
            Positioned(
              top: -40,
              left: 0,
              right: 0,
              child: Center(
                child: CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(
                    serviceProvider.image!, // يمكنك تغيير الرابط لصورة أخرى
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

//
// child: Card(
// elevation: 3,
// color: Colors.white,
// shape:
// RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
// child: SizedBox(
// width: MediaQuery.of(context).size.width * 0.9,
// child: Row(
// children: [
// Padding(
// padding: const EdgeInsets.only(top: 16, bottom: 16, right: 8),
// child: ClipRRect(
// borderRadius: const BorderRadius.all(
// Radius.circular(16),
// ),
// child: CachedNetworkImage(
// imageUrl: serviceProvider.image ??
// 'IMAGE', // TODO: ADD DEFAULT IMAGE
// height: 60,
// width: 60,
// fit: BoxFit.cover,
// ),
// ),
// ),
// Expanded(
// child: Padding(
// padding: const EdgeInsets.symmetric(
// horizontal: 12, vertical: 16),
// child: Column(
// crossAxisAlignment: CrossAxisAlignment.start,
// mainAxisAlignment: MainAxisAlignment.spaceBetween,
// children: [
// Row(
// mainAxisAlignment: MainAxisAlignment.spaceBetween,
// children: [
// Flexible(
// child: Text(
// serviceProvider.name.tr(),
// style: const TextStyle(
// fontSize: 16,
// color: MyColors.Darkest,
// fontWeight: FontWeight.bold,
// ),
// ),
// ),
// ],
// ),
// Text(
// serviceProvider.category?.title ?? 'EMPTY'.tr(),
// style: const TextStyle(
// fontSize: 12,
// color: Colors.grey,
// ),
// ),
// Row(
// mainAxisAlignment: MainAxisAlignment.spaceBetween,
// children: [
// Row(
// children: [
// const Icon(
// Icons.star,
// color: Colors.amber,
// size: 16,
// ),
// Text(
// serviceProvider.stars.toString() ?? 'N/A',
// style: const TextStyle(
// fontSize: 12,
// color: MyColors.Darkest,
// fontWeight: FontWeight.bold,
// ),
// ),
// ],
// ),
// TextButton(
// onPressed: () {
// Navigator.push(
// context,
// MaterialPageRoute(
// builder: (context) =>
// ProviderDetailsScreen(
// providerId: serviceProvider.id,
// )));
// },
// style: flatButtonContinueStyle,
// child: Text(
// 'View Profile'.tr(),
// style: const TextStyle(
// fontSize: 12,
// color: Colors.white,
// ),
// ),
// ),
// ],
// ),
// ],
// ),
// ),
// ),
// ],
// ),
// ),
// ),
