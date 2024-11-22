import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LayoutController extends GetxController {
  final isMenuExpanded = false.obs;
  final selectedRoute = ''.obs;
  final menuBackgroundColor = Rx<Color?>(null);
  final isMobile = false.obs;

  @override
  void onInit() {
    super.onInit();
    menuBackgroundColor.value = Get.theme.appBarTheme.backgroundColor;
    ever(menuBackgroundColor, (_) => update());

    // Monitor screen size changes
    ever(isMobile, (_) => update());
  }

  void toggleMenu() {
    isMenuExpanded.value = !isMenuExpanded.value;
  }

  void setSelectedRoute(String route) {
    selectedRoute.value = route;
  }

  void updateThemeColors() {
    menuBackgroundColor.value = Get.theme.appBarTheme.backgroundColor;
  }

  void checkScreenSize(BuildContext context) {
    isMobile.value = MediaQuery.of(context).size.width < 768;
  }
}
