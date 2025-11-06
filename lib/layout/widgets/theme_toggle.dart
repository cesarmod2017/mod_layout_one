import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/theme_controller.dart';

class ThemeToggle extends GetView<ThemeController> {
  /// Cor opcional para o ícone. Se não informado, usa Get.theme.colorScheme.onPrimary
  final Color? iconColor;

  const ThemeToggle({super.key, this.iconColor});

  @override
  Widget build(BuildContext context) {
    return Obx(() => IconButton(
          icon: Icon(
            controller.isDarkMode.value ? Icons.light_mode : Icons.dark_mode,
            color: iconColor ?? Get.theme.colorScheme.onPrimary,
          ),
          onPressed: controller.toggleTheme,
          tooltip:
              controller.isDarkMode.value ? 'light_mode'.tr : 'dark_mode'.tr,
        ));
  }
}
