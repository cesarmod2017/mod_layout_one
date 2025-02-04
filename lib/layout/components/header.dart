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
  final Color? lightBackgroundColor;
  final Color? darkBackgroundColor;
  final Color? lightForegroundColor;
  final Color? darkForegroundColor;

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
    this.lightBackgroundColor,
    this.darkBackgroundColor,
    this.lightForegroundColor,
    this.darkForegroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final LayoutController layoutController = Get.find<LayoutController>();
    final brightness = Theme.of(context).brightness;

    return AppBar(
      title: logo ?? Text(title),
      backgroundColor: brightness == Brightness.light
          ? lightBackgroundColor
          : darkBackgroundColor,
      foregroundColor: brightness == Brightness.light
          ? lightForegroundColor
          : darkForegroundColor,
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
