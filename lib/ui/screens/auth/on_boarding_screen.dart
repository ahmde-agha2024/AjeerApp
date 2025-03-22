import 'package:ajeer/ui/widgets/common/loader_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';

import '../../../constants/get_storage.dart';
import '../../../constants/my_colors.dart';
import '../../../controllers/general/on_boarding_provider.dart';
import '../../widgets/bottom_curve_clipper.dart';
import 'auth_screen.dart';

class OnBoardingScreen extends StatefulWidget {
  OnBoardingScreen({super.key});

  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  int currentPage = 0;
  String currentLang = 'ar';

  @override
  void initState() {
    storage.write('seen_onboarding', 'true');

    currentLang = storage.read('language') ?? 'ar';
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<OnBoardingProvider>(context, listen: false).fetchOnBoardings();
    });
  }

  void _onNextTap(OnBoardingProvider onBoardingProvider, BuildContext context) async {
    if (currentPage < onBoardingProvider.onBoardings.length - 1) {
      setState(() {
        currentPage++;
      });
    } else {
      await storage.write('seen_onboarding', 'true');
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const AuthScreen(),
        ),
      );
    }
  }

  void _onSwipeLeft(OnBoardingProvider onBoardingProvider) {
    if (currentPage < onBoardingProvider.onBoardings.length - 1) {
      setState(() {
        currentPage++;
      });
    }
  }

  void _onSwipeRight() {
    if (currentPage > 0) {
      setState(() {
        currentPage--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<OnBoardingProvider>(
        builder: (context, onBoardingProvider, child) {
          if (onBoardingProvider.isLoading) {
            return loaderWidget(context,type: "onBoarding");
          }

          if (onBoardingProvider.errorMessage != null) {
            return Center(child: Text(onBoardingProvider.errorMessage!));
          }

          final onBoarding = onBoardingProvider.onBoardings[currentPage];

          return GestureDetector(
            onHorizontalDragEnd: (details) {
              if (details.primaryVelocity! < 0) {
                if (currentLang == 'en') {
                  _onSwipeLeft(onBoardingProvider);
                } else {
                  _onSwipeRight();
                }
              } else if (details.primaryVelocity! > 0) {
                if (currentLang == 'en') {
                  _onSwipeRight();
                } else {
                  _onSwipeLeft(onBoardingProvider);
                }
              }
            },
            child: Column(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: ClipPath(
                          clipper: BottomCurveClipper(),
                          child: Container(
                            color: MyColors.LightGrey,
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: ClipPath(
                            clipper: BottomCurveClipper(),
                            child: CachedNetworkImage(
                              key: ValueKey<int>(currentPage),
                              imageUrl: onBoarding.image,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => const Center(
                                  child: CircularProgressIndicator(
                                color: MyColors.MainBulma,
                              )),
                              errorWidget: (context, url, error) => const Icon(Icons.error),
                            ),
                          ),
                        ),
                      ),
                      SafeArea(
                        child: Container(
                          alignment: currentLang == 'en' ? Alignment.topLeft : Alignment.topRight,
                          margin: currentLang == 'en' ? const EdgeInsets.only(top: 12, left: 16) : const EdgeInsets.only(top: 12, right: 16),
                          child: InkWell(
                            onTap: () async {
                              await storage.write('seen_onboarding', 'true');
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const AuthScreen(),
                                ),
                              );
                            },
                            child: Text(
                              'Skip'.tr(),
                              style: const TextStyle(
                                color: MyColors.Darkest,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: HtmlWidget(
                    onBoarding.title,
                    textStyle: const TextStyle(
                      color: MyColors.MainBulma,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    customStylesBuilder: (element) {
                      if (element.localName == 'p') {
                        return {
                          'max-lines': '2',
                          'text-overflow': 'ellipsis',
                          'text-align': 'center',
                        };
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: HtmlWidget(
                      onBoarding.content,
                      key: ValueKey<int>(currentPage),
                      textStyle: const TextStyle(
                        color: MyColors.LightDark,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                      customStylesBuilder: (element) {
                        return {
                          'text-align': 'center',
                        };
                      },
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(onBoardingProvider.onBoardings.length, (index) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      child: SvgPicture.asset(currentPage == index ? 'assets/svg/on_boarding_active.svg' : 'assets/svg/on_boarding_inactive.svg'),
                    );
                  }),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.only(bottom: 32, top: 8),
                  child: InkWell(
                    onTap: () => _onNextTap(onBoardingProvider, context),
                    child: Container(
                      width: MediaQuery.of(context).size.width - 36,
                      height: 60,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: const LinearGradient(
                          colors: [MyColors.Darkest, MyColors.Darkest],
                        ),
                      ),
                      child: Text(
                        currentPage == (onBoardingProvider.onBoardings.length - 1) ? "Start Now".tr() : "Continue".tr(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          );
        },
      ),
    );
  }
}
