import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mod_layout_one/layout/components/mobile_drawer.dart';
import 'package:mod_layout_one/layout/widgets/user_profile.dart';

import '../../controllers/layout_controller.dart';
import 'components/footer.dart';
import 'components/header.dart';
import 'components/sidebar.dart';

class ModBaseLayout extends StatefulWidget {
  final String title;
  final Widget? logo;
  final Widget body;
  final List<String>? claims;
  final List<MenuGroup> menuGroups;
  final UserProfile? userProfile;
  final List<Widget>? appBarActions;
  final bool showDefaultActions;
  final Widget? sidebarHeader;
  final Widget? sidebarFooter;
  final Widget? footer;
  final Color? sidebarBackgroundColor;
  final Color? sidebarSelectedColor;
  final Color? sidebarUnselectedColor;
  final double footerHeight;
  final Widget? drawerHeader;
  final Color? lightBackgroundColor;
  final Color? darkBackgroundColor;
  final Color? lightForegroundColor;
  final Color? darkForegroundColor;

  const ModBaseLayout({
    super.key,
    required this.title,
    this.logo,
    required this.body,
    this.claims,
    required this.menuGroups,
    this.userProfile,
    this.appBarActions,
    this.showDefaultActions = true,
    this.sidebarHeader,
    this.sidebarFooter,
    this.footer,
    this.sidebarBackgroundColor,
    this.sidebarSelectedColor,
    this.sidebarUnselectedColor,
    this.footerHeight = 50.0,
    this.drawerHeader,
    this.lightBackgroundColor,
    this.darkBackgroundColor,
    this.lightForegroundColor,
    this.darkForegroundColor,
  });

  @override
  State<ModBaseLayout> createState() => _ModBaseLayoutState();
}

class _ModBaseLayoutState extends State<ModBaseLayout> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  bool isDrawerOpen = false;
  @override
  Widget build(BuildContext context) {
    final LayoutController layoutController = Get.find();
    layoutController.checkScreenSize(context);

    // Add this line
    if (layoutController.isMobile.value) {
      layoutController.isMenuExpanded.value = true;
    }

    return PopScope(
      onPopInvokedWithResult: (didPop, result) async {
        if (isDrawerOpen) {
          Navigator.of(context).pop();
          if (mounted) setState(() => isDrawerOpen = false);
          return;
        }
        return;
      },
      child: Scaffold(
        key: scaffoldKey, // Use the key
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: ModHeader(
            title: widget.title,
            logo: widget.logo,
            userProfile: widget.userProfile,
            actions: widget.appBarActions,
            showDefaultActions: widget.showDefaultActions,
            scaffoldKey: scaffoldKey,
            lightBackgroundColor: widget.lightBackgroundColor,
            darkBackgroundColor: widget.darkBackgroundColor,
            lightForegroundColor: widget.lightForegroundColor,
            darkForegroundColor: widget.darkForegroundColor,
          ),
        ),
        drawer: layoutController.isMobile.value
            ? MobileDrawer(
                header: widget.drawerHeader,
                menuGroups: widget.menuGroups,
                claims: widget.claims,
                backgroundColor: widget.sidebarBackgroundColor,
                selectedColor: widget.sidebarSelectedColor,
                unselectedColor: widget.sidebarUnselectedColor,
              )
            : null,
        body: Obx(() => Row(
              children: [
                if (!layoutController.isMobile.value)
                  ModSidebar(
                    claims: widget.claims,
                    menuGroups: widget.menuGroups,
                    backgroundColor: widget.sidebarBackgroundColor,
                    selectedColor: widget.sidebarSelectedColor,
                    unselectedColor: widget.sidebarUnselectedColor,
                    header: widget.sidebarHeader,
                    footer: widget.sidebarFooter,
                  ),
                Expanded(
                  child: Column(
                    children: [
                      Expanded(child: widget.body),
                      if (widget.footer != null)
                        ModFooter(
                            height: widget.footerHeight, child: widget.footer)
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
