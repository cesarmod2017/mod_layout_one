library;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mod_layout_one/controllers/language_controller.dart';
import 'package:mod_layout_one/controllers/layout_controller.dart';
import 'package:mod_layout_one/controllers/theme_controller.dart';
import 'package:mod_layout_one/layout/models/menu_item.dart';
import 'package:mod_layout_one/themes/app_theme.dart';
import 'package:mod_layout_one/translations/base_translations.dart';
import 'package:shared_preferences/shared_preferences.dart';

export 'package:mod_layout_one/layout/models/chatbot_config.dart';
export 'package:mod_layout_one/layout/models/menu_group.dart';
export 'package:mod_layout_one/layout/models/menu_item.dart';
export 'package:mod_layout_one/layout/models/module_model.dart';
export 'package:mod_layout_one/widgets/avatars/avatars.dart';

export 'controllers/language_controller.dart';
export 'controllers/layout_controller.dart';
// Controllers
export 'controllers/theme_controller.dart';
// Layout Components
export 'layout/base_layout.dart';
export 'layout/components/footer.dart';
export 'layout/components/header.dart';
export 'layout/components/no_access_screen.dart';
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
export 'widgets/buttons/popup_buttom.dart';
// Cards
export 'widgets/cards/card_default.dart';
// Charts
export 'widgets/charts/charts.dart';
export 'widgets/charts/mod_bar_chart.dart';
export 'widgets/charts/models/chart_action_button_theme.dart';
export 'widgets/datatable/datatable.dart';
export 'widgets/datatable/datatable_modal.dart';
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
export 'widgets/labels/label.dart';
export 'widgets/loading/loading.dart';
export 'widgets/modal/modal.dart';
export 'widgets/tabs/tabs.dart';
export 'widgets/text/text_copy.dart';
export 'widgets/text/text_divider.dart';
export 'widgets/textbox/textbox.dart';
// Toast
export 'widgets/toast/mod_toast.dart';
export 'widgets/toast/toast_manager.dart';
export 'widgets/treeview/mod_treeview.dart';
// Code Example
export 'widgets/code_example/code_example.dart';
// Progress
export 'widgets/progress/mod_progress.dart';
export 'widgets/progress/mod_progress_controller.dart';
export 'widgets/progress/mod_progress_manager.dart';
// Wheel Slider
export 'widgets/wheel_slider/mod_wheel_slider.dart';
export 'widgets/wheel_slider/mod_wheel_date_picker.dart';

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
