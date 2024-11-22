import 'package:example/assets/app_images.dart';
import 'package:example/models/user_model.dart';
import 'package:example/services/auth_service.dart';
import 'package:example/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mod_layout_one/mod_layout_one.dart';

class AppController extends GetxController {
  final isDarkMode = false.obs;
  final currentLocale = 'pt_BR'.obs;

  final Rx<UserModel> user = UserModel(
    name: 'John Doe',
    email: 'john.doe@example.com',
    avatarPath: AppImages.avatar1,
  ).obs;

  @override
  void onInit() {
    super.onInit();
    // Observa mudanças no tema e idioma
    ever(isDarkMode, _onThemeChanged);
    ever(currentLocale, _onLocaleChanged);
  }

  void _onThemeChanged(bool isDark) {
    Get.changeTheme(isDark ? AppTheme.dark : AppTheme.light);
    Get.find<LayoutController>().updateThemeColors();
    if (Get.isRegistered<StorageService>()) {
      Get.find<StorageService>().saveThemeMode(isDark);
    }
  }

  void _onLocaleChanged(String locale) {
    Get.updateLocale(Locale(locale.split('_')[0], locale.split('_')[1]));
    if (Get.isRegistered<StorageService>()) {
      Get.find<StorageService>().saveLanguage(locale);
    }
  }

  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
  }

  void changeLocale(String locale) {
    currentLocale.value = locale;
  }

  void updateUserData(UserModel newUser) {
    user.value = newUser;
  }

  Future<void> logout() async {
    final authService = Get.find<AuthService>();
    await authService.logout();
  }
}
