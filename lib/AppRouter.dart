import 'package:flutter/material.dart';

class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
      // return MaterialPageRoute(builder: (_) => SplashScreen());
      case '/into_language_screen':
      // return MaterialPageRoute(builder: (_) => const SelectLanguageScreen());
    }
  }
}
