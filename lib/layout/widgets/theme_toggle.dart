import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/theme_controller.dart';

class ThemeToggle extends GetView<ThemeController> {
  const ThemeToggle({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => IconButton(
          icon: Icon(
            controller.isDarkMode.value ? Icons.light_mode : Icons.dark_mode,
            color: Get.theme.appBarTheme.foregroundColor,
          ),
          onPressed: controller.toggleTheme,
          tooltip:
              controller.isDarkMode.value ? 'light_mode'.tr : 'dark_mode'.tr,
        ));
  }
}
