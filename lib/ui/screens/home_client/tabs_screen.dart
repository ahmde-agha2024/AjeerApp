import 'package:ajeer/constants/my_colors.dart';
import 'package:ajeer/ui/screens/home_client/location_user_screen.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';

import '../../../bussiness/tabs_provider.dart';
import '../service_request_add.dart';
import 'home_screen.dart';
import 'more_screen.dart';
import 'my_requests_screen.dart';

class TabsScreen extends StatelessWidget {
  final List iconList = [
    'assets/svg/tab_home.svg',
    'assets/svg/tab_orders.svg',
    'assets/svg/address_office.svg',
    'assets/svg/tab_profile.svg',
  ];

  int currentIndex = 0;

  final List<String> labelList = [
    'Home'.tr(),
    'My requests'.tr(),
    'العناوين'.tr(),
    'Profile'.tr(),
  ];

  final List<Widget> _screens = [
    const HomeScreen(),
    MyRequestsScreen(),
    // FavouriteScreen(),
    UserAddressesScreen(),
    MoreScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final indicatorWidth = screenWidth / 5; // Assuming 4 tabs
    final indicatorPosition = indicatorWidth * currentIndex;
    return Scaffold(

      body: Consumer<TabsProvider>(
        builder: (context, tabsProvider, child) {
          return _screens[tabsProvider.currentIndex];
        },
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 0,
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => ServiceRequestScreen()));
        },
        shape: const CircleBorder(),
        child: Container(
            width: 60,
            height: 60,
            decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(colors: [
                  MyColors.floatingGradiantStart,
                  MyColors.floatingGradiantEnd
                ])),
            child: const Icon(
              Icons.add,
              size: 30,
              color: Colors.white,
            )),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Consumer<TabsProvider>(
        builder: (context, tabsProvider, child) {
          return AnimatedBottomNavigationBar.builder(
            itemCount: iconList.length,
            height: 75,
            tabBuilder: (int index, bool isActive) {
              final color = isActive ? MyColors.MainBulma : Colors.grey;
              currentIndex = index;
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  if (isActive)
                    SizedBox(
                      width: indicatorWidth,
                      child: Container(
                        height: 2,
                        color: MyColors.MainBulma,
                      ),
                    ),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          iconList[index],
                          width: 24,
                          height: 24,
                          color: color,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          labelList[index].tr(),
                          style: TextStyle(
                            color: color,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 4),
                        if (isActive)
                          Container(
                            margin: const EdgeInsets.only(top: 4),
                            height: 2,
                            width: 20,
                            color: MyColors.MainBulma,
                          ),
                      ],
                    ),
                  ),
                ],
              );
            },
            activeIndex: tabsProvider.currentIndex,
            gapLocation: GapLocation.center,

            notchSmoothness: NotchSmoothness.smoothEdge,
            onTap: (index) => tabsProvider.updateIndex(index),
          );
        },
      ),
    );
  }
}
