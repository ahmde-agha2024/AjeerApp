import 'package:ajeer/ui/screens/about_app_screen.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';

import '../../../bussiness/drawer_provider.dart';
import '../../../constants/my_colors.dart';
import 'drawer_provider_screen.dart';
import 'home_provider_screen.dart';
import 'my_requests_provider_screen.dart';
import 'offers_provider_screen.dart';
import 'projects_provider_screen.dart';

class TabsProviderScreen extends StatefulWidget {
  @override
  _TabsProviderScreenState createState() => _TabsProviderScreenState();
}

class _TabsProviderScreenState extends State<TabsProviderScreen> {
  final List<String> iconList = [
    'assets/svg/tab_home.svg',
    'assets/svg/tab_orders.svg',
    'assets/svg/projects.svg',
    'assets/svg/offers.svg',
  ];

  int currentIndex = 0;

  final List<String> labelList = [
    'Home'.tr(),
    'My requests'.tr(),
    'Projects'.tr(),
    'Offers'.tr(),
  ];

  final List<Widget> _screens = [
    HomeProviderScreen(),
    MyRequestsProviderScreen(),
    ProjectsProviderScreen(),
    OffersProviderScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final indicatorWidth = screenWidth / 4;

    return ZoomDrawer(
      controller: Provider.of<DrawerProvider>(context, listen: false)
          .zoomDrawerController,
      mainScreenTapClose: true,
      mainScreenAbsorbPointer: false,
      menuScreen: CustomDrawer(),
      isRtl: true,
      mainScreen: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => AboutAppScreen()));
          },
          backgroundColor: Colors.white,
          child: Icon(
            color: MyColors.FourthService,
            Icons.support_agent,
            size: 35,
          ),
        ),
        body: _screens[currentIndex],
        bottomNavigationBar: _buildBottomNavigationBar(indicatorWidth),
      ),
      borderRadius: 24.0,
      showShadow: true,
      angle: 0.0,
      drawerShadowsBackgroundColor: Colors.grey.withOpacity(0.3),
      slideWidth: MediaQuery.of(context).size.width * 0.75,
      openCurve: Curves.easeOut,
      closeCurve: Curves.easeIn,
    );
  }

  Widget _buildBottomNavigationBar(double indicatorWidth) {
    return AnimatedBottomNavigationBar.builder(
      itemCount: iconList.length,
      height: 75,
      tabBuilder: (int index, bool isActive) {
        final color = isActive ? MyColors.MainBulma : Colors.grey;
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
      activeIndex: currentIndex,
      gapLocation: GapLocation.none,
      notchSmoothness: NotchSmoothness.smoothEdge,
      onTap: (index) {
        setState(() {
          currentIndex = index;
        });
      },
    );
  }
}
