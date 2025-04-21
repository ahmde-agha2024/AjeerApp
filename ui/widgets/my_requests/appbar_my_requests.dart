import 'package:ajeer/ui/screens/messages_screen.dart';
import 'package:ajeer/ui/screens/notifications_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../constants/my_colors.dart';

class AppbarHomeCustom extends StatelessWidget {
  String title;

  AppbarHomeCustom({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('${title}'.tr(), style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w900)),
          Row(
            children: [
              const SizedBox(width: 8),
              Stack(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => MessagesScreen()));
                    },
                    child: Container(
                      width: 42.0,
                      height: 42.0,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: MyColors.lightGreyBackground,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SvgPicture.asset('assets/svg/message-text.svg'),
                      ),
                    ),
                  ),
                  // Positioned(
                  //   right: 0,
                  //   top: 0,
                  //   child: Container(
                  //     width: 20.0,
                  //     height: 20.0,
                  //     decoration: BoxDecoration(
                  //         shape: BoxShape.circle,
                  //         color: MyColors.MainBulma,
                  //         border: Border.all(
                  //           width: 2,
                  //           color: Colors.white,
                  //         )),
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
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => NotificationsScreen()));
                },
                child: Container(
                  width: 42.0,
                  height: 42.0,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: MyColors.lightGreyBackground,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SvgPicture.asset('assets/svg/notification-bing.svg'),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
