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

  const ModSidebar({
    super.key,
    required this.menuGroups,
    this.backgroundColor,
    this.selectedColor,
    this.unselectedColor,
    this.header,
    this.footer,
    this.claims,
  });

  @override
  Widget build(BuildContext context) {
    final LayoutController controller = Get.find();
    final bool isInDrawer =
        context.findAncestorWidgetOfExactType<Drawer>() != null;

    // For mobile drawer, don't use Obx
    if (isInDrawer) {
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

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: width,
      child: Material(
        color: backgroundColor ?? Theme.of(context).drawerTheme.backgroundColor,
        child: Column(
          children: [
            if (header != null) header!,
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: menuGroups
                    .map((group) => _buildMenuGroup(
                          group,
                          isExpanded || isInDrawer,
                        ))
                    .toList(),
              ),
            ),
            if (footer != null) footer!,
          ],
        ),
      ),
    );
  }

  Widget _buildMenuGroup(MenuGroup group, bool showTitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showTitle)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: group.title,
          ),
        ...group.items.map((item) => _buildMenuItem(item, 0)),
      ],
    );
  }

  Widget _buildMenuItem(MenuItem item, int level) {
    if (claims != null && claims!.isNotEmpty) {
      if (!claims!.contains("${item.type}:${item.value}")) {
        return const SizedBox.shrink();
      }
    }

    return _ExpandableMenuItem(
      item: item,
      level: level,
      selectedColor: selectedColor,
      unselectedColor: unselectedColor,
      buildSubmenu: (subItem) => _buildMenuItem(subItem, level + 1),
    );
  }
}

class _ExpandableMenuItem extends StatefulWidget {
  final MenuItem item;
  final int level;
  final Color? selectedColor;
  final Color? unselectedColor;
  final Widget Function(MenuItem) buildSubmenu;

  const _ExpandableMenuItem({
    required this.item,
    required this.level,
    this.selectedColor,
    this.unselectedColor,
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
        leading: Icon(item.icon),
        title: Text(item.title),
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
      leading: Icon(item.icon),
      title: Text(item.title),
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
              color: isSelected
                  ? widget.selectedColor ?? Get.theme.primaryIconTheme.color
                  : widget.unselectedColor ?? Get.theme.iconTheme.color,
            ),
            title: isMenuExpanded
                ? Text(
                    widget.item.title,
                    style: TextStyle(
                      color: isSelected
                          ? widget.selectedColor ??
                              Get.theme.primaryIconTheme.color
                          : widget.unselectedColor ?? Get.theme.iconTheme.color,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  )
                : null,
            trailing: hasSubItems && isMenuExpanded
                ? Icon(
                    _isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: widget.unselectedColor ?? Get.theme.iconTheme.color,
                  )
                : null,
            selected: isSelected,
            onTap: () {
              if (hasSubItems) {
                if (!isMenuExpanded && !Get.isDialogOpen!) {
                  _showSubmenuPopup(context, widget.item.subItems!);
                } else {
                  if (mounted) setState(() => _isExpanded = !_isExpanded);
                }
              } else if (widget.item.route != null) {
                controller.setSelectedRoute(widget.item.route!);
                Get.offNamed(widget.item.route!);
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
}
