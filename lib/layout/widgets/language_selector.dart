import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/language_controller.dart';

class LanguageSelector extends GetView<LanguageController> {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Icon(
        Icons.language,
        color: Get.theme.appBarTheme.foregroundColor,
      ),
      tooltip: 'language'.tr,
      onSelected: controller.changeLanguage,
      itemBuilder: (context) => controller.availableLanguages.entries
          .map(
            (entry) => PopupMenuItem<String>(
              value: entry.key,
              child: Text(entry.value),
            ),
          )
          .toList(),
    );
  }
}
