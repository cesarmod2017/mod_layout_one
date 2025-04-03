import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:mod_layout_one/controllers/language_controller.dart';
import 'package:mod_layout_one/controllers/layout_controller.dart';
import 'package:mod_layout_one/controllers/theme_controller.dart';
import 'package:mod_layout_one/layout/components/sidebar.dart';
import 'package:mod_layout_one/layout/models/menu_group.dart';
import 'package:mod_layout_one/layout/models/module_model.dart';

class MobileDrawer extends StatelessWidget {
  final Widget? header;
  final List<MenuGroup> menuGroups;
  final List<ModuleMenu>? moduleMenuGroups;
  final List<String>? claims;
  final Color? backgroundColor;
  final Color? selectedColor;
  final Color? unselectedColor;

  const MobileDrawer({
    super.key,
    this.header,
    required this.menuGroups,
    this.moduleMenuGroups,
    this.claims,
    this.backgroundColor,
    this.selectedColor,
    this.unselectedColor,
  });

  @override
  Widget build(BuildContext context) {
    final LayoutController layoutController = Get.find();
    final width = MediaQuery.of(context).size.width * 0.85;

    return Drawer(
      child: Column(
        children: [
          if (header != null) header!,
          if (moduleMenuGroups != null && moduleMenuGroups!.isNotEmpty)
            _buildModuleSelector(context),
          Expanded(
            child: Obx(() {
              final List<MenuGroup> currentMenuGroups =
                  moduleMenuGroups != null &&
                          layoutController.selectedModule.value != null
                      ? layoutController.selectedModule.value!.menuGroups
                      : menuGroups;

              return ModSidebar(
                claims: claims,
                menuGroups: currentMenuGroups,
                backgroundColor: backgroundColor,
                selectedColor: selectedColor,
                unselectedColor: unselectedColor,
              );
            }),
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

  Widget _buildModuleSelector(BuildContext context) {
    final LayoutController controller = Get.find();

    return Obx(() {
      final currentModule = controller.selectedModule.value;

      return InkWell(
        onTap: () => _showModuleDialog(context),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Theme.of(context).dividerColor),
            ),
          ),
          child: Row(
            children: [
              if (currentModule?.image != null)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: currentModule!.image!,
                )
              else
                Icon(
                  currentModule?.icon ?? Icons.apps,
                  size: 24,
                  color: Theme.of(context).iconTheme.color,
                ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      currentModule?.name ?? 'Selecione um módulo',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (currentModule?.description != null)
                      Text(
                        currentModule!.description!,
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).textTheme.bodySmall?.color,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_drop_down),
            ],
          ),
        ),
      );
    });
  }

  void _showModuleDialog(BuildContext context) {
    final LayoutController controller = Get.find();

    Get.dialog(
      AlertDialog(
        title: Text('Selecionar Módulo'.tr),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: moduleMenuGroups!.length,
            itemBuilder: (context, index) {
              final module = moduleMenuGroups![index];
              return ListTile(
                leading: module.image != null
                    ? SizedBox(width: 24, height: 24, child: module.image)
                    : Icon(module.icon ?? Icons.apps),
                title: Text(module.name),
                subtitle: module.description != null
                    ? Text(
                        module.description!,
                        overflow: TextOverflow.ellipsis,
                      )
                    : null,
                onTap: () {
                  controller.setSelectedModule(module);
                  Get.back();
                },
              );
            },
          ),
        ),
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
