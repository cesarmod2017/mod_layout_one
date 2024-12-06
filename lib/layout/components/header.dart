import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mod_layout_one/layout/widgets/language_selector.dart';
import 'package:mod_layout_one/layout/widgets/theme_toggle.dart';

import '../../controllers/layout_controller.dart';
import '../widgets/user_profile.dart';

class ModHeader extends StatelessWidget {
  final String title;
  final Widget? logo;
  final bool showMenuButton;
  final VoidCallback? onMenuPressed;
  final UserProfile? userProfile;
  final List<Widget>? actions;
  final bool showDefaultActions;
  final GlobalKey<ScaffoldState> scaffoldKey;
  const ModHeader({
    super.key,
    required this.title,
    this.logo,
    this.showMenuButton = true,
    this.onMenuPressed,
    this.userProfile,
    this.actions,
    this.showDefaultActions = true,
    required this.scaffoldKey,
  });

  @override
  Widget build(BuildContext context) {
    final LayoutController layoutController = Get.find<LayoutController>();

    return AppBar(
      title: logo ?? Text(title),
      leading: showMenuButton
          ? IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                if (layoutController.isMobile.value) {
                  scaffoldKey.currentState?.openDrawer();
                } else {
                  layoutController.toggleMenu();
                }
              },
            )
          : null,
      actions: [
        if (showDefaultActions && !layoutController.isMobile.value) ...[
          const ThemeToggle(),
          const LanguageSelector(),
        ],
        if (actions != null) ...actions!,
        if (userProfile != null) userProfile!,
        const SizedBox(width: 16),
      ],
    );
  }
}
