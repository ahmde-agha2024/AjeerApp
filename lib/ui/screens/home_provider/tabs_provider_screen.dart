import 'package:ajeer/ui/screens/about_app_screen.dart';
import 'package:ajeer/ui/screens/support_center_screen.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';

import '../../../NewDesign/plans.dart';
import '../../../bussiness/drawer_provider.dart';
import '../../../constants/my_colors.dart';
import '../../../controllers/service_provider/provider_home_page_provider.dart';
import 'AjeerCardDistrubutions.dart';
import 'drawer_provider_screen.dart';
import 'home_provider_screen.dart';
import 'my_requests_provider_screen.dart';
import 'offers_provider_screen.dart';
import 'projects_provider_screen.dart';

class TabsProviderScreen extends StatefulWidget {
  @override
  _TabsProviderScreenState createState() => _TabsProviderScreenState();
}

class _TabsProviderScreenState extends State<TabsProviderScreen> with AutomaticKeepAliveClientMixin {
  final List<String> iconList = [
    'assets/svg/tab_home.svg',
    'assets/svg/tab_orders.svg',
    'assets/svg/projects.svg',
    'assets/svg/offers.svg',
  ];

  int currentIndex = 0;
  bool _isLoading = true;
  bool _isFirstLoad = true;
  final FocusNode _focusNode = FocusNode();

  final List<String> labelList = [
    'Home'.tr(),
    'My requests'.tr(),
    'Projects'.tr(),
    'Offers'.tr(),
  ];

  final List<Widget> _screens = [
    HomeProviderScreen(),
    MyRequestsProviderScreen(),
    ProjectsForUserScreen(),
    OffersProviderScreen(),
  ];

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
   // _focusNode.addListener(_onFocusChange);
    _checkAndLoadData();
    // Add navigation listener
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _addNavigationListener();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isFirstLoad) {
      print("Dependencies changed");
      // Only check subscription if we're not navigating to a new screen
      if (ModalRoute.of(context)?.isCurrent ?? false) {
        _checkAndLoadData();
      }
    }
    _isFirstLoad = false;
  }

  @override
  void dispose() {
    // _focusNode.removeListener(_onFocusChange);
    // _focusNode.dispose();
    super.dispose();
  }

  // void _onFocusChange() {
  //   if (_focusNode.hasFocus) {
  //     print("Screen focused");
  //     _checkAndLoadData();
  //   }
  // }

  void _addNavigationListener() {
    ModalRoute? route = ModalRoute.of(context);
    if (route != null) {
      route.addScopedWillPopCallback(() async {
        print("Back button pressed");
        final hasActiveSubscription =
            await Provider.of<ProviderHomePageProvider>(context, listen: false)
                .checkSubscriptionStatus();

        if (!hasActiveSubscription) {
          _showSubscriptionDialog(context);
          return false;
        }
        return true;
      });
    }
  }

  Future<void> _checkAndLoadData() async {
    setState(() {
      _isLoading = true;
    });

    final hasActiveSubscription =
        await Provider.of<ProviderHomePageProvider>(context, listen: false)
            .checkSubscriptionStatus();

    if (mounted) {
      setState(() {
        _isLoading = false;
      });

      if (!hasActiveSubscription) {
        _showSubscriptionDialog(context);
      }
    }
  }

  void _showSubscriptionDialog(BuildContext rootContext) {
    showDialog(
      barrierDismissible: false,
      context: rootContext,
      builder: (dialogContext) => Dialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 14.0),
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  clipBehavior: Clip.antiAlias,
                  height: 110,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Color(0xffE5E5E5),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  child: Image.asset(
                    'assets/Icons/IconDialogLock.png',
                    color: Colors.grey,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 73,
                  left: 0,
                  right: -200,
                  child: Container(
                    width: 68,
                    height: 68,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 4),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Image.asset(
                        'assets/Icons/LockedTokenIcon.png',
                        width: 56,
                        height: 56,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 40.0, vertical: 12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.topRight,
                    child: Text(
                      'الحساب مقفل',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.topRight,
                    child: Text(
                      'تم تجميد حسابك مؤقتاً بسبب انتهاء الاشتراك، ولم يعد حسابك يظهر للزبائن. فعّل اشتراكك الآن وابدأ باستقبال الطلبات من جديد وزيادة دخلك!',
                      textAlign: TextAlign.end,
                      style: TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                  ),
                  Container(
                    height: 2,
                    margin: EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: Color(0xff979797).withAlpha(50),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(dialogContext).pop();
                            Navigator.push(
                              rootContext,
                              MaterialPageRoute(
                                builder: (context) => AjeerDistributionsScreen(),
                                fullscreenDialog: true,
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            minimumSize: Size(152, 48),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(color: Color(0xffC5C5C5)),
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                          ),
                          child: const Text(
                            'موزعين كروت أجير',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Color(0xffC5C5C5),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(dialogContext).pop();
                            Navigator.push(
                              rootContext,
                              MaterialPageRoute(
                                builder: (context) => PlansScreen(),
                                fullscreenDialog: true,
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFC5C5C5),
                            minimumSize: Size(152, 48),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                          ),
                          child: Directionality(
                            textDirection: TextDirection.rtl,
                            child: Text(
                              'تصفح الإشتراكات',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 50),
                  InkWell(
                    onTap: (){
                      Navigator.of(dialogContext).pop();
                      Navigator.push(
                        rootContext,
                        MaterialPageRoute(
                          builder: (context) => SupportCenterScreen(),
                          fullscreenDialog: true,
                        ),
                      );
                    },
                    child: const Text(
                      'الدعم الفني',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xffC5C5C5),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    height: 2,
                    width: 63,
                    margin: EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: Color(0xff979797).withAlpha(50),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : ZoomDrawer(
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
              bottomNavigationBar: _buildBottomNavigationBar(
                  MediaQuery.of(context).size.width / 4),
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
