library mod_layout_one;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mod_layout_one/controllers/language_controller.dart';
import 'package:mod_layout_one/controllers/layout_controller.dart';
import 'package:mod_layout_one/controllers/theme_controller.dart';
import 'package:mod_layout_one/layout/components/sidebar.dart';
import 'package:mod_layout_one/themes/app_theme.dart';
import 'package:mod_layout_one/translations/base_translations.dart';
import 'package:shared_preferences/shared_preferences.dart';

export 'package:mod_layout_one/widgets/avatars/avatars.dart';

export 'controllers/language_controller.dart';
export 'controllers/layout_controller.dart';
// Controllers
export 'controllers/theme_controller.dart';
// Layout Components
export 'layout/base_layout.dart';
export 'layout/components/footer.dart';
export 'layout/components/header.dart';
export 'layout/components/sidebar.dart';
export 'layout/widgets/language_selector.dart';
// Widgets
export 'layout/widgets/theme_toggle.dart';
export 'layout/widgets/user_profile.dart';
// Theme
export 'themes/app_theme.dart';
export 'themes/dark_theme.dart';
export 'themes/light_theme.dart';
// Translations
export 'translations/base_translations.dart';
export 'translations/en_us.dart';
export 'translations/es_es.dart';
export 'translations/pt_br.dart';
export 'widgets/buttons/buttons.dart';
export 'widgets/buttons/icon_buttom.dart';
// Cards
export 'widgets/cards/card_default.dart';
export 'widgets/datatable/datatable.dart';
export 'widgets/dialogs/dialog.dart';
export 'widgets/dropdown/dropdown.dart';
export 'widgets/dropdown_search/dropdown_search.dart';
// Grid
export 'widgets/grid/mod_grid.dart';
// Grid System
export 'widgets/grid_system/enuns/column_size.dart';
export 'widgets/grid_system/enuns/screen_size.dart';
export 'widgets/grid_system/grid_system.dart';
export 'widgets/grid_system/grid_system_colums.dart';
export 'widgets/grid_system/grid_system_container.dart';
export 'widgets/grid_system/grid_system_rows.dart';
export 'widgets/loading/loading.dart';
export 'widgets/modal/modal.dart';
export 'widgets/tabs/tabs.dart';
export 'widgets/text/text_divider.dart';
export 'widgets/textbox/textbox.dart';

// Configuration
class ModLayoutConfig {
  final String appTitle;
  final String? appLogo;
  final ThemeData? lightTheme;
  final ThemeData? darkTheme;
  final Map<String, Map<String, String>>? customTranslations;
  final Widget Function(BuildContext)? customProfileBuilder;
  final Widget Function(BuildContext)? customFooterBuilder;
  final List<MenuItem> menuItems;

  ModLayoutConfig({
    required this.appTitle,
    this.appLogo,
    this.lightTheme,
    this.darkTheme,
    this.customTranslations,
    this.customProfileBuilder,
    this.customFooterBuilder,
    required this.menuItems,
  });
}

// Initialize package
class ModLayout {
  static Future<void> init({
    required ModLayoutConfig config,
    required SharedPreferences prefs,
  }) async {
    // Initialize controllers
    Get.put(ThemeController(prefs), permanent: true);
    Get.put(LanguageController(prefs), permanent: true);
    Get.put(LayoutController(), permanent: true);

    // Initialize translations with custom translations if provided
    Get.put(BaseTranslations(customTranslations: config.customTranslations));

    // Get theme controller
    final themeController = Get.find<ThemeController>();

    // Set initial themes
    AppTheme.lightTheme = config.lightTheme ?? AppTheme.light;
    AppTheme.darkTheme = config.darkTheme ?? AppTheme.dark;

    // Load saved preferences
    themeController.loadThemeMode();
    Get.find<LanguageController>().loadLanguage();
  }
}
