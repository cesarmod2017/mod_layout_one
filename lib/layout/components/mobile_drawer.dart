import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:mod_layout_one/controllers/language_controller.dart';
import 'package:mod_layout_one/controllers/theme_controller.dart';
import 'package:mod_layout_one/layout/components/sidebar.dart';

class MobileDrawer extends StatelessWidget {
  final Widget? header;
  final List<MenuGroup> menuGroups;
  final List<String>? claims;
  final Color? backgroundColor;
  final Color? selectedColor;
  final Color? unselectedColor;

  const MobileDrawer({
    super.key,
    this.header,
    required this.menuGroups,
    this.claims,
    this.backgroundColor,
    this.selectedColor,
    this.unselectedColor,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 0.85;

    return Drawer(
      child: Column(
        children: [
          if (header != null) header!,
          Expanded(
            child: ModSidebar(
              claims: claims,
              menuGroups: menuGroups,
              backgroundColor: backgroundColor,
              selectedColor: selectedColor,
              unselectedColor: unselectedColor,
            ),
          ),
          Container(
            width: width,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Theme.of(context).dividerColor),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildThemeButton(),
                _buildLanguageButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeButton() {
    return IconButton(
      icon: const Icon(Icons.palette),
      onPressed: () {
        Get.dialog(
          AlertDialog(
            title: Text('theme'.tr),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.light_mode),
                  title: Text('light_mode'.tr),
                  onTap: () {
                    Get.find<ThemeController>().setTheme(false);
                    Get.back();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.dark_mode),
                  title: Text('dark_mode'.tr),
                  onTap: () {
                    Get.find<ThemeController>().setTheme(true);
                    Get.back();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLanguageButton() {
    return IconButton(
      icon: const Icon(Icons.language),
      onPressed: () {
        final controller = Get.find<LanguageController>();
        Get.dialog(
          AlertDialog(
            title: Text('language'.tr),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: controller.availableLanguages.entries.map((entry) {
                return ListTile(
                  leading: SvgPicture.asset(
                    entry.value['flag']!,
                    width: 24,
                    height: 24,
                  ),
                  title: Text(entry.value['name']!),
                  onTap: () {
                    controller.changeLanguage(entry.key);
                    Get.back();
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}
