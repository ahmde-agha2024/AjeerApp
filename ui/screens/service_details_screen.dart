import 'package:ajeer/constants/my_colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../widgets/appbar_service_details.dart';
import '../widgets/border_radius_card.dart';
import '../widgets/button_styles.dart';
import '../widgets/home/background_appbar_home.dart';
import '../widgets/home/most_requested_list_view.dart';
import '../widgets/sized_box.dart';
import '../widgets/title_section.dart';
import 'request_service_screen.dart';

class ServiceDetailsScreen extends StatelessWidget {
  const ServiceDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Stack(
            children: [
              BackgroundAppbarHome(
                imageAssetPath: 'assets/Icons/service_image.png',
                opacityFrom: 0.2,
                opacityTo: 0.8,
                height: null,
                width: null,
              ),
            ],
          ),
          Column(
            children: [
              const SafeArea(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: AppbarServiceDetails(),
                ),
              ),
              Expanded(
                child: ClipRRect(
                  borderRadius: topBorderRadiusCard,
                  child: ListView(
                    children: [
                      SizedBox(height: MediaQuery.of(context).size.height * 0.15),
                      Card(
                        color: Colors.white,
                        margin: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(borderRadius: topBorderRadiusCard),
                        child: SizedBox(
                          width: double.infinity,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'تركيب سباكة كاملة للمنزل',
                                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                        ),
                                        Card(
                                          color: MyColors.cardPriceBackgroundColor,
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                          child: const Padding(
                                            padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                                            child: Text(
                                              '20 دينار',
                                              style: TextStyle(fontSize: 12, color: MyColors.MainPrimary),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBoxedH16,
                                    const Text(
                                      'تركيب سباكة كاملة للمنزل تركيب سباكة كاملة للمنزل تركيب سباكة كاملة للمنزل تركيب سباكة كاملة للمنزل تركيب سباكة كاملة للمنزل تركيب سباكة كاملة للمنزل تركيب سباكة كاملة للمنزل تركيب سباكة كاملة للمنزل تركيب سباكة كاملة للمنزل',
                                      style: TextStyle(fontSize: 14, color: Colors.grey),
                                    ),
                                    SizedBoxedH16,
                                    Row(
                                      children: [
                                        SvgPicture.asset('assets/svg/location.svg'),
                                        const SizedBox(width: 8),
                                        const Text(
                                          'مدينة نصر - القاهرة',
                                          style: TextStyle(fontSize: 14, color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                    SizedBoxedH16,
                                    Row(
                                      children: [
                                        Card(
                                          color: MyColors.cardBackgroundColor,
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                                            child: Row(
                                              children: [
                                                SvgPicture.asset('assets/svg/fix_tools.svg'),
                                                const SizedBox(width: 6),
                                                const Text(
                                                  'صيانة',
                                                  style: TextStyle(fontSize: 14, color: MyColors.Darkest),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Card(
                                          color: MyColors.cardBackgroundColor,
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                                            child: Row(
                                              children: [
                                                SvgPicture.asset('assets/svg/store.svg'),
                                                const SizedBox(width: 6),
                                                const Text(
                                                  '250',
                                                  style: TextStyle(fontSize: 14, color: MyColors.Darkest),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Card(
                                          color: MyColors.cardBackgroundColor,
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                                            child: Row(
                                              children: [
                                                SvgPicture.asset('assets/svg/star.svg'),
                                                const SizedBox(width: 6),
                                                const Text(
                                                  '5.0',
                                                  style: TextStyle(fontSize: 14, color: MyColors.Darkest),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Divider(
                                thickness: 6,
                                color: MyColors.LightDark.withOpacity(0.1),
                              ),
                              SizedBoxedH16,
                              TitleSections(title: 'مقدم الخدمة', isViewAll: false, onTapView: () {}),
                              SizedBoxedH16,
                              ListTile(
                                leading: CachedNetworkImage(
                                  imageUrl: 'https://static.vecteezy.com/system/resources/previews/019/896/008/original/male-user-avatar-icon-in-flat-design-style-person-signs-illustration-png.png',
                                  imageBuilder: (context, imageProvider) => Container(
                                    width: 64.0,
                                    height: 64.0,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                                      border: Border.all(
                                        width: 3,
                                        color: Colors.white,
                                        style: BorderStyle.solid,
                                      ),
                                    ),
                                  ),
                                  placeholder: (context, url) => const CircularProgressIndicator(color: MyColors.MainBulma),
                                  errorWidget: (context, url, error) => const Icon(Icons.error, color: MyColors.MainBulma),
                                ),
                                title: const Text('خليل إبراهيم مرسي'),
                                subtitle: const Text(
                                  'فني تركيب تكييفات',
                                  style: TextStyle(color: Colors.grey),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SvgPicture.asset('assets/svg/message_provider.svg'),
                                    const SizedBox(width: 12),
                                    SvgPicture.asset('assets/svg/call_provider.svg'),
                                  ],
                                ),
                              ),
                              SizedBoxedH16,
                              Divider(
                                thickness: 6,
                                color: MyColors.LightDark.withOpacity(0.1),
                              ),
                              SizedBoxedH16,
                              TitleSections(title: 'أخر الاعمال', isViewAll: false, onTapView: () {}),
                              const SizedBox(height: 8),
                              SizedBox(
                                height: 80,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: 5,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.asset(
                                          'assets/Icons/home_background.jpeg',
                                          width: 80,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              SizedBoxedH16,
                              Divider(
                                thickness: 6,
                                color: MyColors.LightDark.withOpacity(0.1),
                              ),
                              SizedBoxedH16,
                              TitleSections(title: 'خدمات ذات صلة', isViewAll: false, onTapView: () {}),
                              SizedBoxedH16,
                               MostRequestedListView(mostRequested: []),
                              SizedBoxedH16,
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: SizedBox(
                                  width: double.infinity,
                                  height: 60,
                                  child: TextButton(
                                    style: flatButtonPrimaryStyle,
                                    onPressed: () async {
                                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => RequestServiceScreen()));
                                    },
                                    child: Text(
                                      'حجز الخدمة'.tr(),
                                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBoxedH24,
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
