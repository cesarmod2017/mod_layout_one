import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageController extends GetxController {
  static const String languageKey = 'language_code';
  final currentLocale = ''.obs;
  final SharedPreferences _prefs;

  final Map<String, String> availableLanguages = {
    'en_US': 'English',
    'pt_BR': 'Português',
    'es_ES': 'Español',
  };

  LanguageController(this._prefs);

  @override
  void onInit() {
    super.onInit();
    loadLanguage();
    ever(currentLocale, (_) => _onLanguageChanged());
  }

  void loadLanguage() {
    final savedLanguage = _prefs.getString(languageKey);
    if (savedLanguage != null &&
        availableLanguages.containsKey(savedLanguage)) {
      currentLocale.value = savedLanguage;
    } else {
      // Define idioma padrão baseado no dispositivo ou inglês como fallback
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
    }
  }

  void changeLanguage(String languageCode) {
    if (availableLanguages.containsKey(languageCode)) {
      currentLocale.value = languageCode;
    }
  }
}
