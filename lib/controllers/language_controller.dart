import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../assets/app_images.dart';

class LanguageController extends GetxController {
  static const String languageKey = 'language_code';
  final currentLocale = ''.obs;
  final SharedPreferences _prefs;

  final Map<String, Map<String, String>> availableLanguages = {};

  LanguageController(this._prefs);

  @override
  void onInit() {
    super.onInit();
    _initializeAvailableLanguages();
    loadLanguage();
    ever(currentLocale, (_) => _onLanguageChanged());

    Future.delayed(const Duration(milliseconds: 650), () {
      _initializeAvailableLanguages();
    });
  }

  void _initializeAvailableLanguages() {
    availableLanguages.clear();
    availableLanguages.addAll({
      'en_US': {'name': 'language_english'.tr, 'flag': AppImages.flagUS},
      'pt_BR': {'name': 'language_portuguese'.tr, 'flag': AppImages.flagBR},
      'es_ES': {'name': 'language_spanish'.tr, 'flag': AppImages.flagES},
    });
    print(availableLanguages);
  }

  void loadLanguage() {
    final savedLanguage = _prefs.getString(languageKey);
    if (savedLanguage != null &&
        availableLanguages.containsKey(savedLanguage)) {
      currentLocale.value = savedLanguage;
    } else {
      final deviceLocale = Get.deviceLocale;
      final localeKey =
          '${deviceLocale?.languageCode}_${deviceLocale?.countryCode}';
      currentLocale.value =
          availableLanguages.containsKey(localeKey) ? localeKey : 'en_US';
    }

    _onLanguageChanged();
  }

  void _onLanguageChanged() {
    if (currentLocale.value.isNotEmpty) {
      final parts = currentLocale.value.split('_');
      final locale = Locale(parts[0], parts[1]);
      Get.updateLocale(locale);
      _prefs.setString(languageKey, currentLocale.value);

      _initializeAvailableLanguages();
    }
  }

  void changeLanguage(String languageCode) {
    if (availableLanguages.containsKey(languageCode)) {
      currentLocale.value = languageCode;
    }
  }
}
