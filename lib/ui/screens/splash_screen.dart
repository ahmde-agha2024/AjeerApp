import 'dart:async';
import 'dart:io';

import 'package:ajeer/constants/get_storage.dart';
import 'package:ajeer/controllers/common/auth_provider.dart';
import 'package:ajeer/ui/screens/auth/auth_screen.dart';
import 'package:ajeer/ui/screens/home_client/tabs_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../../controllers/general/review_pass_provider.dart';
import '../../services/force_update_service.dart';
import 'auth/on_boarding_screen.dart';
import 'home_provider/tabs_provider_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
 // late VideoPlayerController _controller;
  double _opacity = 0.0;  // Start with zero opacity

  @override
  void initState() {
    Provider.of<ReviewPass>(context, listen: false);
    loadSplashScreen();
    super.initState();
    // _controller = VideoPlayerController.asset("assets/video/ajeer.MP4")
    //   ..initialize().then((_) {
    //     setState(() {});
    //     _controller.play();
    //   });
    // // Trigger the fade-in animation after a brief delay
    // Future.delayed(const Duration(milliseconds: 100), () {
    //   setState(() {
    //     _opacity = 1.0;
    //   });
    // });
  }

  @override
  void dispose() {
    //_controller.dispose();
    super.dispose();
  }
  Future<void> _checkForUpdate() async {
    await ForceUpdateService.checkForUpdate();
   // final needsUpdate =
    // await ForceUpdateService.checkForUpdate();
   // if (needsUpdate && mounted) {
      ForceUpdateService.showUpdateDialog(context);
  //  }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset('assets/Icons/logo.png',width: 294,height: 183,),
      ),
    );
  }


  loadSplashScreen() async{
    // Check for updates first
    await _checkForUpdate();
    Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      timer.cancel();
      // check if user already seen onboarding screen
      final String? seenOnBoarding = storage.read('seen_onboarding');
      if (seenOnBoarding == null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => OnBoardingScreen(),
          ),
        );
        return;
      } else {
        // check if user already logged in

        Provider.of<Auth>(context, listen: false).checkAuth().then((isAuth) {
          if (context.mounted) {
            if (isAuth) {
              final String userType = storage.read('user_type');
              Provider.of<Auth>(context, listen: false)
                  .tryAutoLogin()
                  .then((_) {
                if (context.mounted) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => userType == 'provider'
                          ? TabsProviderScreen()
                          : TabsScreen(),
                    ),
                  );
                }
              });
            } else {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const AuthScreen(),
                ),
              );
            }
          }
        });
      }
    });
  }
}
