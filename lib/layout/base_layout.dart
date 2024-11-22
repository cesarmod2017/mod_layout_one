import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mod_layout_one/layout/widgets/user_profile.dart';

import '../../controllers/layout_controller.dart';
import 'components/footer.dart';
import 'components/header.dart';
import 'components/sidebar.dart';

class ModBaseLayout extends StatelessWidget {
  final String title;
  final Widget? logo;
  final Widget body;
  final List<MenuItem> menuItems;
  final UserProfile? userProfile;
  final List<Widget>? appBarActions;
  final bool showDefaultActions;
  final Widget? sidebarHeader;
  final Widget? sidebarFooter;
  final Widget? footer;
  final Color? sidebarBackgroundColor;
  final Color? sidebarSelectedColor;
  final Color? sidebarUnselectedColor;

  const ModBaseLayout({
    super.key,
    required this.title,
    this.logo,
    required this.body,
    required this.menuItems,
    this.userProfile,
    this.appBarActions,
    this.showDefaultActions = true,
    this.sidebarHeader,
    this.sidebarFooter,
    this.footer,
    this.sidebarBackgroundColor,
    this.sidebarSelectedColor,
    this.sidebarUnselectedColor,
  });

  @override
  Widget build(BuildContext context) {
    final LayoutController layoutController = Get.find();
    layoutController.checkScreenSize(context);

    return Scaffold(
      key: GlobalKey<ScaffoldState>(),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: ModHeader(
          title: title,
          logo: logo,
          userProfile: userProfile,
          actions: appBarActions,
          showDefaultActions: showDefaultActions,
        ),
      ),
      drawer: Obx(() => layoutController.isMobile.value
          ? Drawer(
              child: ModSidebar(
                menuItems: menuItems,
                backgroundColor: sidebarBackgroundColor,
                selectedColor: sidebarSelectedColor,
                unselectedColor: sidebarUnselectedColor,
                header: sidebarHeader,
                footer: sidebarFooter,
              ),
            )
          : const SizedBox.shrink()),
      body: Obx(() => Row(
            children: [
              if (!layoutController.isMobile.value)
                ModSidebar(
                  menuItems: menuItems,
                  backgroundColor: sidebarBackgroundColor,
                  selectedColor: sidebarSelectedColor,
                  unselectedColor: sidebarUnselectedColor,
                  header: sidebarHeader,
                  footer: sidebarFooter,
                ),
              Expanded(
                child: Column(
                  children: [
                    Expanded(child: body),
                    if (footer != null) ModFooter(child: footer)
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
