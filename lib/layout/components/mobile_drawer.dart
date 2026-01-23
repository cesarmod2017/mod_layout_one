import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:mod_layout_one/controllers/language_controller.dart';
import 'package:mod_layout_one/controllers/layout_controller.dart';
import 'package:mod_layout_one/controllers/theme_controller.dart';
import 'package:mod_layout_one/layout/models/menu_group.dart';
import 'package:mod_layout_one/layout/models/menu_item.dart';
import 'package:mod_layout_one/layout/models/module_model.dart';

class MobileDrawer extends StatelessWidget {
  final Widget? header;
  final List<MenuGroup> menuGroups;
  final List<ModuleMenu>? moduleMenuGroups;
  final List<String>? claims;
  final Color? backgroundColor;
  final Color? selectedColor;
  final Color? unselectedColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final double? iconSize;

  const MobileDrawer({
    super.key,
    this.header,
    required this.menuGroups,
    this.moduleMenuGroups,
    this.claims,
    this.backgroundColor,
    this.selectedColor,
    this.unselectedColor,
    this.fontSize,
    this.fontWeight,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    debugPrint('[MobileDrawer] Building drawer');
    debugPrint('[MobileDrawer] backgroundColor: $backgroundColor');
    debugPrint('[MobileDrawer] Theme brightness: ${Theme.of(context).brightness}');
    debugPrint('[MobileDrawer] Menu groups count: ${menuGroups.length}');
    
    final drawerColor = backgroundColor ?? 
        Theme.of(context).drawerTheme.backgroundColor ?? 
        Theme.of(context).scaffoldBackgroundColor;
    
    return Drawer(
      backgroundColor: drawerColor,
      child: SafeArea(
        child: Column(
          children: [
            if (header != null) header!,
            // Only show module selector if there's more than one visible module
            if (moduleMenuGroups != null && _filteredModules.length > 1)
              _buildModuleSelector(context),
            Expanded(
              child: _buildMenuContent(context),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                color: drawerColor,
                border: Border(
                  top: BorderSide(
                    color: Theme.of(context).dividerColor.withValues(alpha: 0.2),
                  ),
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
      ),
    );
  }

  Widget _buildMenuContent(BuildContext context) {
    // Get current menu groups based on selected module
    final LayoutController controller = Get.find();

    return Obx(() {
      // Get current menu groups from selected module or fallback to provided menuGroups
      final currentMenuGroups = controller.selectedModule.value?.menuGroups ?? menuGroups;

      debugPrint('[MobileDrawer] Building menu content with ${currentMenuGroups.length} groups');
      debugPrint('[MobileDrawer] Selected module: ${controller.selectedModule.value?.name}');

      if (currentMenuGroups.isEmpty) {
        return Center(
          child: Text(
            'No menu items available',
            style: TextStyle(
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
        );
      }

      // Find the first valid group to mark it for auto-expanding
      int firstValidGroupIndex = -1;
      for (int i = 0; i < currentMenuGroups.length; i++) {
        if (_hasValidGroupClaim(currentMenuGroups[i])) {
          firstValidGroupIndex = i;
          break;
        }
      }

      return ListView(
        padding: EdgeInsets.zero,
        physics: const AlwaysScrollableScrollPhysics(),
        children: currentMenuGroups.asMap().entries.map((entry) {
          final index = entry.key;
          final group = entry.value;
          debugPrint('[MobileDrawer] Building group: ${group.title}');
          return _DrawerMenuGroup(
            group: group,
            claims: claims,
            selectedColor: selectedColor,
            unselectedColor: unselectedColor,
            fontSize: fontSize,
            fontWeight: fontWeight,
            iconSize: iconSize,
            isFirstGroup: index == firstValidGroupIndex,
          );
        }).toList(),
      );
    });
  }

  bool _hasValidClaim(MenuItem item) {
    if (claims == null || claims!.isEmpty) {
      return true;
    }

    // First priority: check claimName
    if (item.claimName != null) {
      return claims!.contains(item.claimName!);
    }

    // Second priority: check type:value combination
    if (item.type != null && item.value != null) {
      return claims!.contains("${item.type}:${item.value}");
    }

    // If both are null and claims exist, don't show the item
    return false;
  }

  bool _hasValidGroupClaim(MenuGroup group) {
    if (claims == null || claims!.isEmpty) {
      return true;
    }

    // Check if MenuGroup has claimName and validate it
    if (group.claimName != null) {
      return claims!.contains(group.claimName!);
    }

    // If no claimName, check if any items are visible
    return group.items.any((item) => _hasValidClaim(item));
  }

  bool _hasValidModuleClaim(ModuleMenu module) {
    if (claims == null || claims!.isEmpty) {
      return true;
    }

    // Check if any menu group in the module is visible
    return module.menuGroups.any((group) => _hasValidGroupClaim(group));
  }

  List<ModuleMenu> get _filteredModules {
    return moduleMenuGroups?.where((module) => _hasValidModuleClaim(module)).toList() ?? [];
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
                  size: currentModule?.iconSize ?? iconSize ?? 24,
                  color: Theme.of(context).iconTheme.color,
                ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      currentModule?.name ?? 'Selecione um módulo',
                      style: TextStyle(
                        fontWeight: currentModule?.fontWeight ??
                            fontWeight ??
                            FontWeight.bold,
                        fontSize: currentModule?.fontSize ?? fontSize,
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
    final filteredModules = _filteredModules;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) => AlertDialog(
        title: Text('Selecionar Módulo'.tr),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: filteredModules.length,
            itemBuilder: (context, index) {
              final module = filteredModules[index];
              return Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    debugPrint('[MobileDrawer] Selecting module: ${module.name}');
                    controller.setSelectedModule(module);
                    
                    // Close dialog using Navigator instead of Get.back()
                    Navigator.of(dialogContext).pop();
                    
                    debugPrint('[MobileDrawer] Module selected and dialog closed');
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        // Leading icon/image
                        SizedBox(
                          width: 40,
                          height: 40,
                          child: module.image != null
                              ? module.image!
                              : Icon(
                                  module.icon ?? Icons.apps,
                                  size: module.iconSize ?? iconSize ?? 24,
                                ),
                        ),
                        const SizedBox(width: 16),
                        // Title and subtitle
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                module.name,
                                style: TextStyle(
                                  fontSize: module.fontSize ?? fontSize ?? 16,
                                  fontWeight: module.fontWeight ?? fontWeight ?? FontWeight.w500,
                                ),
                              ),
                              if (module.description != null)
                                Text(
                                  module.description!,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Theme.of(dialogContext).textTheme.bodySmall?.color,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
            },
            child: Text('Cancelar'.tr),
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

class _DrawerMenuGroup extends StatelessWidget {
  final MenuGroup group;
  final List<String>? claims;
  final Color? selectedColor;
  final Color? unselectedColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final double? iconSize;
  final bool isFirstGroup;

  const _DrawerMenuGroup({
    required this.group,
    this.claims,
    this.selectedColor,
    this.unselectedColor,
    this.fontSize,
    this.fontWeight,
    this.iconSize,
    this.isFirstGroup = false,
  });

  bool _hasValidClaim(MenuItem item) {
    if (claims == null || claims!.isEmpty) {
      return true;
    }

    // First priority: check claimName
    if (item.claimName != null) {
      return claims!.contains(item.claimName!);
    }

    // Second priority: check type:value combination
    if (item.type != null && item.value != null) {
      return claims!.contains("${item.type}:${item.value}");
    }

    // If both are null and claims exist, don't show the item
    return false;
  }

  bool _hasValidGroupClaim(MenuGroup group) {
    if (claims == null || claims!.isEmpty) {
      return true;
    }

    // Check if MenuGroup has claimName and validate it
    if (group.claimName != null) {
      return claims!.contains(group.claimName!);
    }

    // If no claimName, check if any items are visible
    return group.items.any((item) => _hasValidClaim(item));
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('[_DrawerMenuGroup] Building group with ${group.items.length} items, isFirstGroup: $isFirstGroup');

    // Check if the group should be visible
    if (!_hasValidGroupClaim(group)) {
      return const SizedBox.shrink();
    }

    // Track if we've found the first expandable item in the first group
    bool firstExpandableFound = false;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: DefaultTextStyle(
            style: TextStyle(
              color: Theme.of(context).textTheme.bodySmall?.color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
            child: group.title,
          ),
        ),
        ...group.items.map((item) {
          // Check if this item should be initially expanded (first expandable item in the first group)
          final hasSubItems = item.subItems?.isNotEmpty ?? false;
          final shouldExpandInitially = isFirstGroup && hasSubItems && !firstExpandableFound && _hasValidClaim(item);
          if (shouldExpandInitially) {
            firstExpandableFound = true;
          }
          return _DrawerMenuItem(
            item: item,
            level: 0,
            group: group,
            claims: claims,
            selectedColor: selectedColor,
            unselectedColor: unselectedColor,
            fontSize: fontSize,
            fontWeight: fontWeight,
            iconSize: iconSize,
            initiallyExpanded: shouldExpandInitially,
          );
        }),
      ],
    );
  }
}

class _DrawerMenuItem extends StatefulWidget {
  final MenuItem item;
  final int level;
  final MenuGroup group;
  final List<String>? claims;
  final Color? selectedColor;
  final Color? unselectedColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final double? iconSize;
  final bool initiallyExpanded;

  const _DrawerMenuItem({
    required this.item,
    required this.level,
    required this.group,
    this.claims,
    this.selectedColor,
    this.unselectedColor,
    this.fontSize,
    this.fontWeight,
    this.iconSize,
    this.initiallyExpanded = false,
  });

  @override
  State<_DrawerMenuItem> createState() => _DrawerMenuItemState();
}

class _DrawerMenuItemState extends State<_DrawerMenuItem> {
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    // Use initiallyExpanded to set the initial state
    _isExpanded = widget.initiallyExpanded;
  }

  bool _hasValidClaim(MenuItem item) {
    if (widget.claims == null || widget.claims!.isEmpty) {
      return true;
    }

    // First priority: check claimName
    if (item.claimName != null) {
      return widget.claims!.contains(item.claimName!);
    }

    // Second priority: check type:value combination
    if (item.type != null && item.value != null) {
      return widget.claims!.contains("${item.type}:${item.value}");
    }

    // If both are null and claims exist, don't show the item
    return false;
  }

  @override
  Widget build(BuildContext context) {
    // Check claims
    if (!_hasValidClaim(widget.item)) {
      return const SizedBox.shrink();
    }

    final LayoutController controller = Get.find();
    // Verificar seleção: priorizar id, depois rota
    final bool isSelected;
    if (widget.item.id != null) {
      isSelected = controller.selectedMenuId.value == widget.item.id;
    } else {
      isSelected = widget.item.route != null &&
          controller.selectedRoute.value == widget.item.route &&
          controller.selectedMenuId.value == null;
    }
    final hasSubItems = widget.item.subItems?.isNotEmpty ?? false;
    
    final effectiveFontSize = widget.item.fontSize ?? 
        widget.group.fontSize ?? 
        widget.fontSize ?? 
        14.0;
    
    final effectiveFontWeight = widget.item.fontWeight ?? 
        widget.group.fontWeight ?? 
        widget.fontWeight;
    
    final effectiveIconSize = widget.item.iconSize ?? 
        widget.group.iconSize ?? 
        widget.iconSize ?? 
        24.0;

    debugPrint('[_DrawerMenuItem] Item: ${widget.item.title}, isSelected: $isSelected, hasSubItems: $hasSubItems');
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              debugPrint('[_DrawerMenuItem] Tap on: ${widget.item.title}');

              if (hasSubItems) {
                setState(() => _isExpanded = !_isExpanded);
              } else if (widget.item.route != null) {
                debugPrint('[_DrawerMenuItem] Navigating to: ${widget.item.route}');
                controller.setSelectedRoute(widget.item.route!, menuId: widget.item.id);
                Navigator.of(context).pop(); // Close drawer first

                // Simplified navigation - avoid complex GetX route manipulations
                Future.delayed(const Duration(milliseconds: 200), () {
                  try {
                    // Check if should reload on navigate
                    if (widget.item.reloadOnNavigate) {
                      // Force reload by using offAllNamed to clear navigation stack
                      debugPrint('[_DrawerMenuItem] Reloading route: ${widget.item.route}');
                      if (widget.item.arguments != null) {
                        Get.offAllNamed(
                          widget.item.route!,
                          arguments: widget.item.arguments,
                        );
                      } else {
                        Get.offAllNamed(widget.item.route!);
                      }
                    } else {
                      // Only navigate if route is different from current
                      if (Get.currentRoute != widget.item.route) {
                        // Use simple navigation to avoid navigator history issues
                        if (widget.item.arguments != null) {
                          Get.toNamed(
                            widget.item.route!,
                            arguments: widget.item.arguments,
                          );
                        } else {
                          Get.toNamed(widget.item.route!);
                        }
                      }
                    }
                  } catch (e) {
                    debugPrint('[_DrawerMenuItem] Navigation error: $e');
                    // Show error instead of trying complex navigation
                    Get.snackbar(
                      'Erro de Navegação',
                      'Não foi possível navegar para ${widget.item.title}',
                      snackPosition: SnackPosition.BOTTOM,
                      duration: const Duration(seconds: 2),
                    );
                  }
                });
              }
            },
            child: Container(
              padding: EdgeInsets.only(
                left: 16.0 + (widget.level * 16.0),
                right: 16.0,
                top: 10.0,
                bottom: 10.0,
              ),
              decoration: BoxDecoration(
                color: isSelected
                    ? (widget.selectedColor ?? Theme.of(context).colorScheme.primary).withValues(alpha: 0.1)
                    : null,
                border: isSelected
                    ? Border(
                        left: BorderSide(
                          color: widget.selectedColor ?? Theme.of(context).colorScheme.primary,
                          width: 3,
                        ),
                      )
                    : null,
              ),
              child: Row(
                children: [
                  Icon(
                    widget.item.icon,
                    size: effectiveIconSize,
                    color: isSelected
                        ? widget.selectedColor ?? Theme.of(context).colorScheme.primary
                        : widget.unselectedColor ?? Theme.of(context).iconTheme.color,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.item.title,
                      style: TextStyle(
                        color: isSelected
                            ? widget.selectedColor ?? Theme.of(context).colorScheme.primary
                            : widget.unselectedColor ?? Theme.of(context).textTheme.bodyLarge?.color,
                        fontWeight: effectiveFontWeight ??
                            (isSelected ? FontWeight.w600 : FontWeight.normal),
                        fontSize: effectiveFontSize,
                      ),
                    ),
                  ),
                  if (hasSubItems)
                    Icon(
                      _isExpanded ? Icons.expand_less : Icons.expand_more,
                      size: 20,
                      color: widget.unselectedColor ?? Theme.of(context).iconTheme.color,
                    ),
                ],
              ),
            ),
          ),
        ),
        if (hasSubItems && _isExpanded)
          ...widget.item.subItems!.map((subItem) => _DrawerMenuItem(
            item: subItem,
            level: widget.level + 1,
            group: widget.group,
            claims: widget.claims,
            selectedColor: widget.selectedColor,
            unselectedColor: widget.unselectedColor,
            fontSize: widget.fontSize,
            fontWeight: widget.fontWeight,
            iconSize: widget.iconSize,
          )),
      ],
    );
  }
}
