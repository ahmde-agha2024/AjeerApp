import 'package:ajeer/controllers/common/auth_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../bussiness/drawer_provider.dart';
import '../../../constants/my_colors.dart';
import '../../screens/messages_screen.dart';
import '../../screens/notifications_screen.dart';

class AppbarHome extends StatelessWidget {
  AppbarHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<Auth>(
      builder: (context, authProvider, child) {
        return authProvider.isProvider
            ? authProvider.provider == null
                ? Container(
                    color: Colors.white,
                  )
                : Column(
                    children: [
                      const SizedBox(height: 25),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // InkWell(
                          //   onTap: () {
                          //     if (authProvider.isProvider) {
                          //       Provider.of<DrawerProvider>(context,
                          //           listen: false)
                          //           .openDrawer();
                          //     }
                          //   },
                          //   child: CachedNetworkImage(
                          //     imageUrl: authProvider.isProvider
                          //         ? authProvider.provider?.image ??
                          //         'https://static.vecteezy.com/system/resources/previews/019/896/008/original/male-user-avatar-icon-in-flat-design-style-person-signs-illustration-png.png'
                          //         : authProvider.customer?.image ??
                          //         'https://static.vecteezy.com/system/resources/previews/019/896/008/original/male-user-avatar-icon-in-flat-design-style-person-signs-illustration-png.png',
                          //     imageBuilder: (context, imageProvider) =>
                          //         Container(
                          //           width: 48.0,
                          //           height: 48.0,
                          //           decoration: BoxDecoration(
                          //             shape: BoxShape.circle,
                          //             image: DecorationImage(
                          //                 image: imageProvider, fit: BoxFit.cover),
                          //             border: Border.all(
                          //               width: 3,
                          //               color: Colors.white,
                          //               style: BorderStyle.solid,
                          //             ),
                          //           ),
                          //         ),
                          //     placeholder: (context, url) =>
                          //     const CircularProgressIndicator(
                          //         color: MyColors.MainBulma),
                          //     errorWidget: (context, url, error) => const Icon(
                          //         Icons.error,
                          //         color: MyColors.MainBulma),
                          //   ),
                          // ),
                          InkWell(
                            onTap: () {
                              if (authProvider.isProvider) {
                                Provider.of<DrawerProvider>(context,
                                        listen: false)
                                    .openDrawer();
                              }
                            },
                            child: authProvider.isProvider
                                ? Image.asset(
                                    "assets/Icons/Home_Provider_Icon_List.png",
                                    width: 44,
                                    height: 44,
                                  )
                                : CachedNetworkImage(
                                    imageUrl: authProvider.customer?.image ??
                                        'https://static.vecteezy.com/system/resources/previews/019/896/008/original/male-user-avatar-icon-in-flat-design-style-person-signs-illustration-png.png',
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                      width: 48.0,
                                      height: 48.0,
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
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Welcome back, '.tr() +
                                      (authProvider.isProvider
                                          ? authProvider.provider!.name ??
                                              'Provider Name'
                                          : authProvider.customer?.name ??
                                              'User Name'),
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w900),
                                ),
                                Text(
                                  'Enjoy the best offers and discounts'.tr(),
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w100),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Stack(
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => MessagesScreen()));
                                },
                                child: Image.asset(
                                  'assets/Icons/chatIcon.png',
                                  width: 44,
                                  height: 44,
                                ),
                              ),
                              // Positioned(
                              //   right: 0,
                              //   top: 0,
                              //   child: Container(
                              //     width: 20.0,
                              //     height: 20.0,
                              //     decoration: BoxDecoration(shape: BoxShape.circle, color: MyColors.MainBulma, border: Border.all(width: 2, color: Colors.white)),
                              //     child: const Center(
                              //       child: Text(
                              //         '3',
                              //         style: TextStyle(color: Colors.white, fontSize: 12),
                              //       ),
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                          const SizedBox(width: 8),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => NotificationsScreen()));
                            },
                            child: Image.asset(
                              'assets/Icons/Notification_Icon_New.png',
                              width: 44,
                              height: 44,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 16),
                    ],
                  )
            : Column(
                children: [
                  const SizedBox(height: 46),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          if (authProvider.isProvider) {
                            Provider.of<DrawerProvider>(context, listen: false)
                                .openDrawer();
                          }
                        },
                        child: CachedNetworkImage(
                          imageUrl: authProvider.isProvider
                              ? authProvider.provider?.image ??
                                  'https://static.vecteezy.com/system/resources/previews/019/896/008/original/male-user-avatar-icon-in-flat-design-style-person-signs-illustration-png.png'
                              : authProvider.customer?.image ??
                                  'https://static.vecteezy.com/system/resources/previews/019/896/008/original/male-user-avatar-icon-in-flat-design-style-person-signs-illustration-png.png',
                          imageBuilder: (context, imageProvider) => Container(
                            width: 48.0,
                            height: 48.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: imageProvider, fit: BoxFit.cover),
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
                          errorWidget: (context, url, error) => const Icon(
                              Icons.error,
                              color: MyColors.MainBulma),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Welcome back, '.tr() +
                                  (authProvider.isProvider
                                      ? authProvider.provider!.name ??
                                          'Provider Name'
                                      : authProvider.customer?.name ??
                                          'User Name'),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900),
                            ),
                            Text(
                              'Enjoy the best offers and discounts'.tr(),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w100),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Stack(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => MessagesScreen()));
                            },
                            child: Container(
                              width: 42.0,
                              height: 42.0,
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle, color: Colors.white),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SvgPicture.asset(
                                    'assets/svg/message-text.svg'),
                              ),
                            ),
                          ),
                          // Positioned(
                          //   right: 0,
                          //   top: 0,
                          //   child: Container(
                          //     width: 20.0,
                          //     height: 20.0,
                          //     decoration: BoxDecoration(shape: BoxShape.circle, color: MyColors.MainBulma, border: Border.all(width: 2, color: Colors.white)),
                          //     child: const Center(
                          //       child: Text(
                          //         '3',
                          //         style: TextStyle(color: Colors.white, fontSize: 12),
                          //       ),
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                      const SizedBox(width: 8),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => NotificationsScreen()));
                        },
                        child: Container(
                          width: 42.0,
                          height: 42.0,
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: Colors.white),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SvgPicture.asset(
                                'assets/svg/notification-bing.svg'),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                ],
              );
      },
    );
  }
}
