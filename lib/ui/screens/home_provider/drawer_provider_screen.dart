import 'dart:io';

import 'package:ajeer/controllers/general/review_pass_provider.dart';
import 'package:ajeer/controllers/general/wallet_provider_controller.dart';
import 'package:ajeer/ui/screens/auth/auth_screen.dart';
import 'package:ajeer/ui/screens/home_provider/AjeerCardDistrubutions.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../constants/my_colors.dart';
import '../../../controllers/common/auth_provider.dart';
import '../about_app_screen.dart';
import '../edit_profile_screen.dart';
import '../faq_screen.dart';
import '../support_center_screen.dart';
import '../terms_and_conditions_screen.dart';
import 'packages_screen.dart';
import 'waleetScreens/walletShowScreens.dart';

class CustomDrawer extends StatefulWidget {
  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Consumer<Auth>(
        builder: (context, authProvider, child) {
          return authProvider.provider == null
              ? Container(
                  color: Colors.white,
                )
              : Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withOpacity(0.8),
                            Colors.black.withOpacity(0.9),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 20, top: 80, bottom: 20),
                      child: SingleChildScrollView(
                        child: Column(
                          //crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Row(
                                children: [
                                  CachedNetworkImage(
                                    imageUrl: authProvider.isProvider
                                        ? authProvider.provider!.image ??
                                            'https://static.vecteezy.com/system/resources/previews/019/896/008/original/male-user-avatar-icon-in-flat-design-style-person-signs-illustration-png.png'
                                        : authProvider.customer!.image ??
                                            'https://static.vecteezy.com/system/resources/previews/019/896/008/original/male-user-avatar-icon-in-flat-design-style-person-signs-illustration-png.png',
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                      width: 32.0,
                                      height: 32.0,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.cover),
                                        border: Border.all(
                                          width: 3,
                                          color: Colors.white,
                                          style: BorderStyle.solid,
                                        ),
                                      ),
                                    ),
                                    placeholder: (context, url) =>
                                        const CircularProgressIndicator(
                                            color: MyColors.MainBulma),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error,
                                            color: MyColors.MainBulma),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          (authProvider.isProvider
                                              ? authProvider.provider!.name ??
                                                  'Provider'
                                              : authProvider.customer!.name ??
                                                  'Customer'),
                                          style: const TextStyle(
                                              color: Colors.white, fontSize: 16),
                                        ),
                                        const Text(
                                          'نشط الآن',
                                          style: TextStyle(
                                              color: Colors.green, fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 40),
                            buildMenuItem(
                              icon: Icons.person_outline,
                              label: 'الملف الشخصي',
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => EditProfileScreen()));
                              },
                            ),
                            // if (!Provider.of<ReviewPass>(context, listen: false)
                            //     .isAppleReview)
                            FutureBuilder(
                                future: WalletController().getstatus(),
                                builder: (contetx, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return SizedBox();
                                  } else if (snapshot.data == 1) {
                                    return buildMenuItem(
                                      icon: Icons.credit_card_outlined,
                                      label: 'الباقات',
                                      onTap: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    PackagesScreen()));
                                      },
                                    );
                                  } else {
                                    return SizedBox();
                                  }
                                }),
                            FutureBuilder(
                                future: WalletController().getstatus(),
                                builder: (contetx, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return SizedBox();
                                  } else if (snapshot.data == 1) {
                                    return buildMenuItem(
                                      icon: Icons.wallet,
                                      label: 'المحفظة',
                                      onTap: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    WalletScreen()));
                                      },
                                    );
                                  } else {
                                    return SizedBox();
                                  }
                                }),

                            buildMenuItem(
                              icon: Icons.map_outlined,
                              label: 'موزعين كروت أجير',
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => AjeerDistributionsScreen()));
                              },
                            ),
                            // buildMenuItem(
                            //   icon: Icons.bar_chart_outlined,
                            //   label: 'احصائيات',
                            //   onTap: () {},
                            // ),
                            if (!Provider.of<ReviewPass>(context, listen: false)
                                .isAppleReview)
                              buildMenuItem(
                                icon: Icons.info_outline,
                                label: 'عن التطبيق',
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => AboutAppScreen()));
                                },
                              ),
                            buildMenuItem(
                              icon: Icons.headset_mic_outlined,
                              label: 'الدعم الفني',
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        SupportCenterScreen()));
                              },
                            ),
                            if (!Provider.of<ReviewPass>(context, listen: false)
                                .isAppleReview)
                              buildMenuItem(
                                icon: Icons.help_outline,
                                label: 'الأسئلة الشائعة',
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => FaqScreen()));
                                },
                              ),
                            buildMenuItem(
                              icon: Icons.security_outlined,
                              label: 'الشروط و الأحكام',
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        const TermsAndConditionsScreen()));
                              },
                            ),

                            buildMenuItem(
                              icon: Icons.star_outline,
                              label: 'تقييم التطبيق',
                              onTap: () async {
                                final String androidUrl =
                                    'https://play.google.com/store/apps/details?id=com.app.ajeer';
                                final String iosUrl =
                                    'https://apps.apple.com/us/app/%D8%A3%D8%AC%D9%8A%D8%B1-ajeer/id6736632788';

                                try {
                                  final InAppReview inAppReview =
                                      InAppReview.instance;
                                  bool isAvailable =
                                      await inAppReview.isAvailable();

                                  // تحقق من وجود التطبيق على المتجر
                                  bool isAppOnStore = false;
                                  if (Platform.isAndroid) {
                                    isAppOnStore =
                                        await _checkAppOnStore(androidUrl);
                                  } else if (Platform.isIOS) {
                                    isAppOnStore =
                                        await _checkAppOnStore(iosUrl);
                                  }

                                  print(
                                      'inAppReview.isAvailable(): $isAvailable');
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
                            ),
                            buildMenuItem(
                              icon: Icons.delete_outline,
                              label: 'حذف الحساب',
                              onTap: () async{
                                bool? confirmDelete = await showDialog<bool>(
                                  context: context,
                                  builder: (context) => Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: AlertDialog(
                                      title: Align(
                                        alignment: Alignment.centerRight,
                                        child: Text('الدعم الفني'),
                                      ),
                                      content: Text(
                                        'للحفاظ على أمان بياناتك وضمان تجربة أفضل، يُرجى التواصل مع فريق الدعم الفني لإتمام عملية حذف الحساب.',
                                        textAlign: TextAlign.right,
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(false),
                                          child: Text('إلغاء'),
                                        ),
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(true),
                                          child: Text('موافق',
                                              style: TextStyle(color: Colors.red)),
                                        ),
                                      ],
                                    ),
                                  ),
                                );

                                // If user confirmed deletion
                                if (confirmDelete == true) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => AboutAppScreen()));
                                }
                              },
                            ),
                            // const Spacer(),
                            // تسجيل الخروج
                            buildMenuItem(
                              icon: Icons.exit_to_app,
                              label: 'تسجيل الخروج',
                              iconColor: Colors.red,
                              textColor: Colors.red,
                              onTap: () async {
                                await Provider.of<Auth>(context, listen: false)
                                    .logout();
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const AuthScreen()),
                                    (route) => false);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
        },
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

  // Widget لإنشاء عناصر القائمة
  Widget buildMenuItem({
    required IconData icon,
    required String label,
    Color iconColor = Colors.white,
    Color textColor = Colors.white,
    VoidCallback? onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: iconColor, size: 28),
      title: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontSize: 16,
        ),
      ),
    );
  }
}
