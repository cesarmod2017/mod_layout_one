import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/layout_controller.dart';

class MenuItem {
  final String title;
  final IconData icon;
  final String route;
  final List<MenuItem>? subItems;
  final String? type;
  final String? value;
  final String? url;
  final VoidCallback? onTap; // Added onTap parameter

  const MenuItem({
    required this.title,
    required this.icon,
    required this.route,
    this.subItems,
    this.type,
    this.value,
    this.url,
    this.onTap, // Added onTap parameter
  });
}

class ModSidebar extends StatelessWidget {
  final List<MenuItem> menuItems;
  final Color? backgroundColor;
  final Color? selectedColor;
  final Color? unselectedColor;
  final Widget? header;
  final Widget? footer;

  const ModSidebar({
    super.key,
    required this.menuItems,
    this.backgroundColor,
    this.selectedColor,
    this.unselectedColor,
    this.header,
    this.footer,
  });

  @override
  Widget build(BuildContext context) {
    final LayoutController controller = Get.find();
    return Obx(() {
      final isExpanded = controller.isMenuExpanded.value;

      return AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: isExpanded ? 240 : 70,
        color: backgroundColor ?? Theme.of(context).drawerTheme.backgroundColor,
        child: Column(
          children: [
            if (header != null) header!,
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children:
                    menuItems.map((item) => _buildMenuItem(item)).toList(),
              ),
            ),
            if (footer != null) footer!,
          ],
        ),
      );
    });
  }

  Widget _buildMenuItem(MenuItem item) {
    final LayoutController controller = Get.find();

    return Obx(() {
      final isSelected = controller.selectedRoute.value == item.route;
      final isExpanded = controller.isMenuExpanded.value;

      return ListTile(
        leading: Icon(
          item.icon,
          color: isSelected
              ? selectedColor ?? Get.theme.primaryIconTheme.color
              : unselectedColor ?? Get.theme.iconTheme.color,
        ),
        title: isExpanded
            ? Text(
                item.title,
                style: TextStyle(
                  color: isSelected
                      ? selectedColor ?? Get.theme.primaryIconTheme.color
                      : unselectedColor ?? Get.theme.iconTheme.color,
                ),
              )
            : null,
        selected: isSelected,
        onTap: item.onTap ??
            () {
              // Check if onTap is provided
              controller.setSelectedRoute(item.route);
              Get.offNamed(item.route); // Alterado de toNamed para offNamed
              if (Get.isDialogOpen ?? false) Get.back();
              if (Get.width < 768) Get.back();
            },
      );
    });
  }
}
