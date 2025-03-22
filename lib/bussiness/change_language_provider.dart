import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../constants/get_storage.dart';

class LanguageProvider extends ChangeNotifier {
  Locale _locale = const Locale('ar');

  LanguageProvider() : _locale = translator.activeLocale; // Get initial locale

  Locale get locale => _locale;

  void changeLanguage(String languageCode, BuildContext context) {
    translator.setNewLanguage(
      context,
      newLanguage: languageCode,
      // restart: false,
    );
    storage.write('language', languageCode);

    _locale = Locale(languageCode);

    notifyListeners();
  }
}
