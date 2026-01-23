import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mod_layout_one/layout/models/module_model.dart';

class LayoutController extends GetxController {
  final isMenuExpanded = false.obs;
  final selectedRoute = ''.obs;
  /// Identificador único do item de menu selecionado.
  /// Usado para distinguir entre diferentes MenuItems com a mesma rota.
  final selectedMenuId = Rx<String?>(null);
  final menuBackgroundColor = Rx<Color?>(null);
  final isMobile = false.obs;
  var selectedModule = Rx<ModuleMenu?>(null);

  @override
  void onInit() {
    super.onInit();
    menuBackgroundColor.value = Get.theme.appBarTheme.backgroundColor;
    ever(menuBackgroundColor, (_) => update());

    // Monitor screen size changes
    ever(isMobile, (_) => update());
  }

  void toggleMenu() {
    isMenuExpanded.value = !isMenuExpanded.value;
  }

  void setSelectedRoute(String route, {String? menuId}) {
    selectedRoute.value = route;
    selectedMenuId.value = menuId;
  }

  /// Define o id do menu selecionado.
  void setSelectedMenuId(String? menuId) {
    selectedMenuId.value = menuId;
  }

  void setSelectedModule(ModuleMenu module) {
    selectedModule.value = module;
    // Trigger the onSelect callback if it exists
    module.onSelect?.call(module);
  }

  void checkScreenSize(BuildContext context) {
    isMobile.value = MediaQuery.of(context).size.width < 768;
  }

  void updateThemeColors() {
    menuBackgroundColor.value = Get.theme.appBarTheme.backgroundColor;
  }
}
