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

  /// Cor opcional para o ícone do menu. Se não informado, usa Get.theme.colorScheme.onPrimary
  final Color? menuIconColor;

  /// Cor opcional para o texto do título. Se não informado, usa Get.theme.colorScheme.onPrimary
  final Color? titleColor;

  /// Cor opcional para o ícone de tema (light/dark). Se não informado, usa Get.theme.colorScheme.onPrimary
  final Color? themeIconColor;

  /// Cor opcional para os elementos do perfil. Se não informado, usa Get.theme.colorScheme.onPrimary
  final Color? profileColor;

  /// Cor opcional para o ícone de idioma. Se não informado, usa Get.theme.colorScheme.onPrimary
  final Color? languageIconColor;

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
    this.menuIconColor,
    this.titleColor,
    this.themeIconColor,
    this.profileColor,
    this.languageIconColor,
  });

  @override
  Widget build(BuildContext context) {
    final LayoutController layoutController = Get.find<LayoutController>();
    final brightness = Theme.of(context).brightness;

    // Cor padrão para todos os elementos do header
    final defaultOnPrimaryColor = Get.theme.colorScheme.onPrimary;

    return AppBar(
      title: logo ??
          Text(
            title,
            style: TextStyle(color: titleColor ?? defaultOnPrimaryColor),
          ),
      backgroundColor: brightness == Brightness.light
          ? lightBackgroundColor
          : darkBackgroundColor,
      foregroundColor: brightness == Brightness.light
          ? lightForegroundColor
          : darkForegroundColor,
      leading: showMenuButton
          ? IconButton(
              icon: Icon(
                Icons.menu,
                color: menuIconColor ?? defaultOnPrimaryColor,
              ),
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
          ThemeToggle(iconColor: themeIconColor ?? defaultOnPrimaryColor),
          LanguageSelector(iconColor: languageIconColor ?? defaultOnPrimaryColor),
        ],
        if (actions != null) ...actions!,
        if (userProfile != null)
          UserProfile(
            userName: userProfile!.userName,
            userEmail: userProfile!.userEmail,
            avatarUrl: userProfile!.avatarUrl,
            onProfileTap: userProfile!.onProfileTap,
            onLogout: userProfile!.onLogout,
            showFullProfile: userProfile!.showFullProfile,
            textColor: profileColor ?? defaultOnPrimaryColor,
            iconColor: profileColor ?? defaultOnPrimaryColor,
          ),
        const SizedBox(width: 16),
      ],
    );
  }
}
