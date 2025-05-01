import 'dart:io';

import 'package:ajeer/constants/my_colors.dart';
import 'package:ajeer/controllers/common/auth_provider.dart';
import 'package:ajeer/ui/screens/auth/auth_screen.dart';
import 'package:ajeer/ui/widgets/sized_box.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../about_app_screen.dart';
import '../edit_profile_screen.dart';
import '../faq_screen.dart';
import '../support_center_screen.dart';
import '../terms_and_conditions_screen.dart';
import 'location_user_screen.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.35,
                width: double.infinity,
                color: MyColors.DarkestBackMore,
              ),
              Positioned(
                  top: 0,
                  right: 0,
                  child: SvgPicture.asset(
                    'assets/svg/more_overlay.svg',
                  )),
              Positioned(
                  top: 0,
                  right: 0,
                  left: 0,
                  bottom: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CachedNetworkImage(
                          imageUrl: context.read<Auth>().customer?.image ?? '',
                          imageBuilder: (context, imageProvider) => Container(
                            width: 80.0,
                            height: 80.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: imageProvider, fit: BoxFit.cover),
                            ),
                          ),
                          placeholder: (context, url) =>
                              CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),
                        SizedBoxedH8,
                        Text(
                          context.read<Auth>().customer?.name ?? 'customer',
                          style: const TextStyle(
                            color: MyColors.MainGohan,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  )),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
              child: ListView(
                shrinkWrap: true,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => EditProfileScreen(),
                        ),
                      );
                    },
                    child: ListTile(
                      leading: SvgPicture.asset('assets/svg/more_profile.svg'),
                      title: const Text('الملف الشخصي'),
                    ),
                  ),
                  Divider(
                    color: MyColors.LightDark.withOpacity(0.2),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => UserAddressesScreen(),
                        ),
                      );
                    },
                    child: ListTile(
                      leading: SvgPicture.asset('assets/svg/more_rate.svg'),
                      title: const Text('العناوين'),
                    ),
                  ),
                  Divider(
                    color: MyColors.LightDark.withOpacity(0.2),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const AboutAppScreen(),
                        ),
                      );
                    },
                    child: ListTile(
                      leading:
                          SvgPicture.asset('assets/svg/more_about_app.svg'),
                      title: const Text('عن التطبيق'),
                    ),
                  ),
                  // Divider(
                  //   color: MyColors.LightDark.withOpacity(0.2),
                  // ),
                  // InkWell(
                  //   onTap: () {
                  //     if (Platform.isIOS) {
                  //       Share.share(
                  //           'https://apps.apple.com/us/app/%D8%A3%D8%AC%D9%8A%D8%B1-ajeer/id6736632788');
                  //     } else
                  //     {
                  //       Share.share(
                  //           'https://play.google.com/store/apps/details?id=com.ajeer.ajeer');
                  //     }
                  //   },
                  //   child: ListTile(
                  //     leading: SvgPicture.asset('assets/svg/more_share.svg'),
                  //     title: const Text('مشاركة التطبيق'),
                  //   ),
                  // ),
                  Divider(
                    color: MyColors.LightDark.withOpacity(0.2),
                  ),
                  InkWell(
                    onTap: () async {
                      final String androidUrl =
                          'https://play.google.com/store/apps/details?id=com.ajeer.ajeer';
                      final String iosUrl =
                          'https://apps.apple.com/us/app/%D8%A3%D8%AC%D9%8A%D8%B1-ajeer/id6736632788';

                      try {
                        final InAppReview inAppReview = InAppReview.instance;
                        bool isAvailable = await inAppReview.isAvailable();

                        // تحقق من وجود التطبيق على المتجر
                        bool isAppOnStore = false;
                        if (Platform.isAndroid) {
                          isAppOnStore = await _checkAppOnStore(androidUrl);
                        } else if (Platform.isIOS) {
                          isAppOnStore = await _checkAppOnStore(iosUrl);
                        }

                        print('inAppReview.isAvailable(): $isAvailable');
                        print('App on store: $isAppOnStore');

                        if (isAvailable && isAppOnStore) {
                          inAppReview.requestReview();
                        } else {
                          if (Platform.isAndroid) {
                            launchUrl(Uri.parse(androidUrl));
                          } else {
                            launchUrl(Uri.parse(iosUrl));
                          }
                        }
                      } catch (e) {
                        print(e);
                        if (Platform.isAndroid) {
                          launchUrl(Uri.parse(androidUrl));
                        } else {
                          launchUrl(Uri.parse(iosUrl));
                        }
                      }
                    },
                    child: ListTile(
                      leading: SvgPicture.asset('assets/svg/more_rate.svg'),
                      title: const Text('تقييم التطبيق'),
                    ),
                  ),
                  Divider(
                    color: MyColors.LightDark.withOpacity(0.2),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const FaqScreen()));
                    },
                    child: ListTile(
                      leading: SvgPicture.asset('assets/svg/more_faq.svg'),
                      title: const Text('الاسئلة الشائعة'),
                    ),
                  ),
                  Divider(
                    color: MyColors.LightDark.withOpacity(0.2),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => SupportCenterScreen()));
                    },
                    child: ListTile(
                      leading: SvgPicture.asset('assets/svg/more_help.svg'),
                      title: const Text('الدعم الفني'),
                    ),
                  ),
                  Divider(
                    color: MyColors.LightDark.withOpacity(0.2),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              const TermsAndConditionsScreen()));
                    },
                    child: ListTile(
                      leading: SvgPicture.asset('assets/svg/more_terms.svg'),
                      title: const Text('الشروط & الاحكام'),
                    ),
                  ),
                  Divider(
                    color: MyColors.LightDark.withOpacity(0.2),
                  ),
                  InkWell(
                    onTap: () async {
                      // عرض التنبيه
                      bool? confirmLogout = await showDialog<bool>(
                        context: context,
                        builder: (BuildContext context) {
                          return Directionality(
                            textDirection: TextDirection.rtl,
                            child: AlertDialog(
                              title: Text("Confirmation Log Out".tr()),
                              content:
                                  Text("Are you sure you want to log out?".tr()),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(false);
                                  },
                                  child: Text('No'.tr()),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(true);
                                  },
                                  child: Text(
                                    'Yes'.tr(),
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                      );

                      if (confirmLogout == true) {
                        await Provider.of<Auth>(context, listen: false)
                            .logout();
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => const AuthScreen()),
                          (route) => false,
                        );
                      }
                    },
                    child: ListTile(
                      leading: SvgPicture.asset('assets/svg/more_logout.svg'),
                      title: const Text('تسجيل الخروج'),
                    ),
                  ),
                  SizedBoxedH24,
                  SizedBoxedH24,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> _checkAppOnStore(String url) async {
    try {
      final response = await Dio().head(url);
      return response.statusCode == 200;
    } catch (e) {
      print('Error checking app on store: $e');
      return false;
    }
  }
}
