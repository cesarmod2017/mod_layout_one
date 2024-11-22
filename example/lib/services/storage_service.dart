import 'package:example/controllers/app_controller.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String themeKey = 'theme_mode';
  static const String languageKey = 'language_code';

  final SharedPreferences _prefs;

  StorageService(this._prefs);

  // Tema
  Future<void> saveThemeMode(bool isDark) async {
    await _prefs.setBool(themeKey, isDark);
  }

  bool? getThemeMode() {
    return _prefs.getBool(themeKey);
  }

  // Idioma
  Future<void> saveLanguage(String languageCode) async {
    await _prefs.setString(languageKey, languageCode);
  }

  String? getLanguage() {
    return _prefs.getString(languageKey);
  }
}

// Inicialização do StorageService
// Adicione esta função no main.dart
Future<void> initializeSettings() async {
  final prefs = await SharedPreferences.getInstance();
  final storageService = StorageService(prefs);
  Get.put(storageService, permanent: true);

  // Carrega as configurações salvas
  final savedTheme = storageService.getThemeMode();
  final savedLanguage = storageService.getLanguage();

  final appController = Get.find<AppController>();
  if (savedTheme != null) {
    appController.isDarkMode.value = savedTheme;
  }
  if (savedLanguage != null) {
    appController.changeLocale(savedLanguage);
  }
}
