import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../controllers/language_controller.dart';

class LanguageSelector extends GetView<LanguageController> {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Obx(() {
        final currentFlag = controller
            .availableLanguages[controller.currentLocale.value]?['flag'];
        return currentFlag != null
            ? SvgPicture.asset(
                currentFlag,
                width: 24,
                height: 24,
              )
            : Icon(
                Icons.language,
                color: Get.theme.appBarTheme.foregroundColor,
              );
      }),
      tooltip: 'language'.tr,
      onSelected: controller.changeLanguage,
      itemBuilder: (context) => controller.availableLanguages.entries
          .map(
            (entry) => PopupMenuItem<String>(
              value: entry.key,
              child: Row(
                children: [
                  SvgPicture.asset(
                    entry.value['flag']!,
                    width: 24,
                    height: 24,
                  ),
                  const SizedBox(width: 8),
                  Text(entry.value['name']!),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}
