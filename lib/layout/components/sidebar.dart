import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mod_layout_one/layout/models/menu_group.dart';
import 'package:mod_layout_one/layout/models/menu_item.dart';

import '../../controllers/layout_controller.dart';

class ModSidebar extends StatelessWidget {
  final List<MenuGroup> menuGroups;
  final Color? backgroundColor;
  final Color? selectedColor;
  final Color? unselectedColor;
  final Widget? header;
  final Widget? footer;
  final List<String>? claims;
  final double? fontSize;
  final FontWeight? fontWeight;
  final double? iconSize;

  const ModSidebar({
    super.key,
    required this.menuGroups,
    this.backgroundColor,
    this.selectedColor,
    this.unselectedColor,
    this.header,
    this.footer,
    this.claims,
    this.fontSize,
    this.fontWeight,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    final LayoutController controller = Get.find();
    final bool isInDrawer =
        context.findAncestorWidgetOfExactType<Drawer>() != null;
    
    // Debug logs
    debugPrint('[ModSidebar] Building sidebar - isInDrawer: $isInDrawer');
    debugPrint('[ModSidebar] Device width: ${MediaQuery.of(context).size.width}');
    debugPrint('[ModSidebar] Is mobile: ${controller.isMobile.value}');
    debugPrint('[ModSidebar] Theme mode: ${Theme.of(context).brightness}');

    // For mobile/tablet drawer, don't use Obx
    if (isInDrawer) {
      debugPrint('[ModSidebar] Building drawer content for mobile/tablet');
      return _buildSidebarContent(context, true, true);
    }

    // For desktop, keep Obx
    return Obx(() => _buildSidebarContent(
          context,
          controller.isMenuExpanded.value,
          false,
        ));
  }

  Widget _buildSidebarContent(
      BuildContext context, bool isExpanded, bool isInDrawer) {
    final width = isInDrawer
        ? MediaQuery.of(context).size.width * 0.85
        : (isExpanded ? 240.0 : 70.0);
    
    debugPrint('[ModSidebar] Content - width: $width, isExpanded: $isExpanded, isInDrawer: $isInDrawer');
    debugPrint('[ModSidebar] Menu groups count: ${menuGroups.length}');
    
    // Get proper colors for drawer
    final drawerBackgroundColor = isInDrawer
        ? Theme.of(context).drawerTheme.backgroundColor ?? Theme.of(context).scaffoldBackgroundColor
        : (backgroundColor ?? Theme.of(context).drawerTheme.backgroundColor);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: width,
      child: Material(
        color: drawerBackgroundColor,
        elevation: isInDrawer ? 0 : 2,
        child: Column(
          children: [
            if (header != null) header!,
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                physics: const AlwaysScrollableScrollPhysics(),
                children: menuGroups
                    .map((group) {
                      debugPrint('[ModSidebar] Building menu group: ${group.title}');
                      return _buildMenuGroup(
                        group,
                        isExpanded || isInDrawer,
                      );
                    })
                    .toList(),
              ),
            ),
            if (footer != null) footer!,
          ],
        ),
      ),
    );
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

  Widget _buildMenuGroup(MenuGroup group, bool showTitle) {
    debugPrint('[ModSidebar] Building group with ${group.items.length} items, showTitle: $showTitle');
    
    // Check if the group should be visible
    if (!_hasValidGroupClaim(group)) {
      return const SizedBox.shrink();
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showTitle)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: DefaultTextStyle(
              style: TextStyle(
                color: Theme.of(Get.context!).textTheme.bodyMedium?.color,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              child: group.title,
            ),
          ),
        ...group.items.map((item) {
          debugPrint('[ModSidebar] Building menu item: ${item.title}');
          return _buildMenuItem(item, 0, group);
        }),
      ],
    );
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

  Widget _buildMenuItem(MenuItem item, int level, MenuGroup group) {
    if (!_hasValidClaim(item)) {
      return const SizedBox.shrink();
    }

    return _ExpandableMenuItem(
      item: item,
      level: level,
      selectedColor: selectedColor,
      unselectedColor: unselectedColor,
      fontSize: item.fontSize ?? group.fontSize ?? fontSize,
      fontWeight: item.fontWeight ?? group.fontWeight ?? fontWeight,
      iconSize: item.iconSize ?? group.iconSize ?? iconSize,
      buildSubmenu: (subItem) => _buildMenuItem(subItem, level + 1, group),
    );
  }
}

class _ExpandableMenuItem extends StatefulWidget {
  final MenuItem item;
  final int level;
  final Color? selectedColor;
  final Color? unselectedColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final double? iconSize;
  final Widget Function(MenuItem) buildSubmenu;

  const _ExpandableMenuItem({
    required this.item,
    required this.level,
    this.selectedColor,
    this.unselectedColor,
    this.fontSize,
    this.fontWeight,
    this.iconSize,
    required this.buildSubmenu,
  });

  @override
  State<_ExpandableMenuItem> createState() => _ExpandableMenuItemState();
}

class _ExpandableMenuItemState extends State<_ExpandableMenuItem> {
  bool _isExpanded = false;
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    _checkIfShouldBeExpanded();
  }

  void _checkIfShouldBeExpanded() {
    if (!Get.find<LayoutController>().isMobile.value) {
      final selectedRoute = Get.find<LayoutController>().selectedRoute.value;
      _isExpanded = _checkIfContainsRoute(widget.item, selectedRoute);
    }
  }

  bool _checkIfContainsRoute(MenuItem item, String? selectedRoute) {
    if (item.route == selectedRoute) return true;

    if (item.subItems != null) {
      for (var subItem in item.subItems!) {
        if (_checkIfContainsRoute(subItem, selectedRoute)) return true;
      }
    }
    return false;
  }

  @override
  void didUpdateWidget(_ExpandableMenuItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    _checkIfShouldBeExpanded();
  }

  void _showSubmenuPopup(BuildContext context, List<MenuItem> subItems) {
    final RenderBox button = context.findRenderObject() as RenderBox;
    final RenderBox overlay =
        Navigator.of(context).overlay!.context.findRenderObject() as RenderBox;
    final buttonPosition = button.localToGlobal(Offset.zero, ancestor: overlay);

    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: _removeOverlay,
              behavior: HitTestBehavior.translucent,
              child: Container(color: Colors.transparent),
            ),
          ),
          Positioned(
            left: buttonPosition.dx + button.size.width,
            top: buttonPosition.dy,
            child: Material(
              elevation: 8,
              borderRadius: BorderRadius.circular(4),
              child: Container(
                width: 200,
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height -
                      buttonPosition.dy -
                      10,
                ),
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: subItems
                        .map((item) => _buildPopupMenuItem(context, item))
                        .toList(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  Widget _buildPopupMenuItem(BuildContext context, MenuItem item) {
    final hasSubItems = item.subItems?.isNotEmpty ?? false;
    final LayoutController controller = Get.find();

    if (!hasSubItems) {
      return ListTile(
        leading: Icon(
          item.icon,
          size: widget.iconSize,
        ),
        title: Text(
          item.title,
          style: TextStyle(
            fontSize: widget.fontSize,
            fontWeight: widget.fontWeight,
          ),
        ),
        onTap: () {
          if (item.route != null) {
            controller.setSelectedRoute(item.route!);
            Get.offNamed(item.route!);
            _removeOverlay();
          }
        },
      );
    }

    return ExpansionTile(
      leading: Icon(
        item.icon,
        size: widget.iconSize,
      ),
      title: Text(
        item.title,
        style: TextStyle(
          fontSize: widget.fontSize,
          fontWeight: widget.fontWeight,
        ),
      ),
      trailing: const Icon(Icons.chevron_right),
      children: item.subItems!
          .map((subItem) => _buildPopupMenuItem(context, subItem))
          .toList(),
    );
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final LayoutController controller = Get.find();
    final bool isInDrawer = context.findAncestorWidgetOfExactType<Drawer>() != null;
    
    debugPrint('[_ExpandableMenuItem] Building item: ${widget.item.title}, isInDrawer: $isInDrawer');

    // For drawer on mobile/tablet, simplify the widget tree
    if (isInDrawer) {
      return _buildSimpleMenuItem(context, controller);
    }

    // For desktop, keep the reactive Obx
    return Obx(() {
      final isMenuExpanded = controller.isMenuExpanded.value;
      final isSelected = widget.item.route != null &&
          controller.selectedRoute.value == widget.item.route;
      final hasSubItems = widget.item.subItems?.isNotEmpty ?? false;

      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            contentPadding: EdgeInsets.only(
              left: 16.0 + (widget.level * (isMenuExpanded ? 16.0 : 0)),
              right: 16.0,
            ),
            leading: Icon(
              widget.item.icon,
              size: widget.iconSize ?? 24.0,
              color: isSelected
                  ? widget.selectedColor ?? Theme.of(context).colorScheme.primary
                  : widget.unselectedColor ?? Theme.of(context).iconTheme.color,
            ),
            title: isMenuExpanded
                ? Text(
                    widget.item.title,
                    style: TextStyle(
                      color: isSelected
                          ? widget.selectedColor ?? Theme.of(context).colorScheme.primary
                          : widget.unselectedColor ?? Theme.of(context).textTheme.bodyLarge?.color,
                      fontWeight: widget.fontWeight ??
                          (isSelected ? FontWeight.bold : FontWeight.normal),
                      fontSize: widget.fontSize ?? 14.0,
                    ),
                  )
                : null,
            trailing: hasSubItems && isMenuExpanded
                ? Icon(
                    _isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: widget.unselectedColor ?? Theme.of(context).iconTheme.color,
                  )
                : null,
            selected: isSelected,
            selectedTileColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
            onTap: () {
              debugPrint('[_ExpandableMenuItem] Tap detected on: ${widget.item.title}');
              if (hasSubItems) {
                if (!isMenuExpanded && !Get.isDialogOpen!) {
                  _showSubmenuPopup(context, widget.item.subItems!);
                } else {
                  if (mounted) setState(() => _isExpanded = !_isExpanded);
                }
              } else if (widget.item.route != null) {
                debugPrint('[_ExpandableMenuItem] Navigating to: ${widget.item.route}');
                controller.setSelectedRoute(widget.item.route!);
                
                // Simplified navigation to avoid navigator issues
                try {
                  // Only navigate if route is different from current
                  if (Get.currentRoute != widget.item.route) {
                    // Check if route exists before navigating
                    if (widget.item.arguments != null) {
                      Get.toNamed(
                        widget.item.route!,
                        arguments: widget.item.arguments,
                      );
                    } else {
                      Get.toNamed(widget.item.route!);
                    }
                  }
                } catch (e) {
                  debugPrint('[_ExpandableMenuItem] Navigation error: $e');
                  // Show error instead of trying complex navigation
                  Get.snackbar(
                    'Erro de Navegação',
                    'Não foi possível navegar para ${widget.item.title}',
                    snackPosition: SnackPosition.BOTTOM,
                    duration: const Duration(seconds: 2),
                  );
                }
                
                if (Get.isDialogOpen ?? false) Get.back();
                if (Get.width < 768 && !isMenuExpanded) Get.back();
              }
            },
          ),
          if (hasSubItems && _isExpanded && isMenuExpanded)
            AnimatedSize(
              duration: const Duration(milliseconds: 200),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: widget.item.subItems!
                    .map((subItem) => widget.buildSubmenu(subItem))
                    .toList(),
              ),
            ),
        ],
      );
    });
  }

  Widget _buildSimpleMenuItem(BuildContext context, LayoutController controller) {
    final isSelected = widget.item.route != null &&
        controller.selectedRoute.value == widget.item.route;
    final hasSubItems = widget.item.subItems?.isNotEmpty ?? false;
    
    debugPrint('[_ExpandableMenuItem] Simple item - isSelected: $isSelected, hasSubItems: $hasSubItems');
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              debugPrint('[_ExpandableMenuItem] Drawer tap on: ${widget.item.title}');
              if (hasSubItems) {
                if (mounted) setState(() => _isExpanded = !_isExpanded);
              } else if (widget.item.route != null) {
                debugPrint('[_ExpandableMenuItem] Drawer navigating to: ${widget.item.route}');
                controller.setSelectedRoute(widget.item.route!);
                Navigator.of(context).pop(); // Close drawer first
                
                // Simplified navigation - avoid complex GetX route manipulations
                Future.delayed(const Duration(milliseconds: 200), () {
                  try {
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
                  } catch (e) {
                    debugPrint('[_ExpandableMenuItem] Navigation error: $e');
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
                top: 12.0,
                bottom: 12.0,
              ),
              color: isSelected
                  ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.1)
                  : null,
              child: Row(
                children: [
                  Icon(
                    widget.item.icon,
                    size: widget.iconSize ?? 24.0,
                    color: isSelected
                        ? widget.selectedColor ?? Theme.of(context).colorScheme.primary
                        : widget.unselectedColor ?? Theme.of(context).iconTheme.color,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      widget.item.title,
                      style: TextStyle(
                        color: isSelected
                            ? widget.selectedColor ?? Theme.of(context).colorScheme.primary
                            : widget.unselectedColor ?? Theme.of(context).textTheme.bodyLarge?.color,
                        fontWeight: widget.fontWeight ??
                            (isSelected ? FontWeight.bold : FontWeight.normal),
                        fontSize: widget.fontSize ?? 14.0,
                      ),
                    ),
                  ),
                  if (hasSubItems)
                    Icon(
                      _isExpanded ? Icons.expand_less : Icons.expand_more,
                      color: widget.unselectedColor ?? Theme.of(context).iconTheme.color,
                    ),
                ],
              ),
            ),
          ),
        ),
        if (hasSubItems && _isExpanded)
          Column(
            mainAxisSize: MainAxisSize.min,
            children: widget.item.subItems!
                .map((subItem) => widget.buildSubmenu(subItem))
                .toList(),
          ),
      ],
    );
  }
}
