import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../themes/app_theme.dart';

class ThemeController extends GetxController {
  static const String themeKey = 'theme_mode';
  final isDarkMode = false.obs;
  final SharedPreferences _prefs;

  ThemeController(this._prefs);

  @override
  void onInit() {
    super.onInit();
    loadThemeMode();
    ever(isDarkMode, (_) => _onThemeChanged());
  }

  void loadThemeMode() {
    final savedTheme = _prefs.getBool(themeKey);
    if (savedTheme != null) {
      isDarkMode.value = savedTheme;
      _onThemeChanged();
    }
  }

  void _onThemeChanged() {
    Get.changeTheme(isDarkMode.value ? AppTheme.dark : AppTheme.light);
    _prefs.setBool(themeKey, isDarkMode.value);
  }

  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
  }
}
