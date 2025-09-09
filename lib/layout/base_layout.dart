import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mod_layout_one/controllers/layout_controller.dart';
import 'package:mod_layout_one/layout/components/footer.dart';
import 'package:mod_layout_one/layout/components/header.dart';
import 'package:mod_layout_one/layout/components/mobile_drawer.dart';
import 'package:mod_layout_one/layout/components/no_access_screen.dart';
import 'package:mod_layout_one/layout/components/sidebar.dart';
import 'package:mod_layout_one/layout/models/menu_group.dart';
import 'package:mod_layout_one/layout/models/menu_item.dart';
import 'package:mod_layout_one/layout/models/module_model.dart';
import 'package:mod_layout_one/layout/widgets/module_selector_widget.dart';
import 'package:mod_layout_one/layout/widgets/user_profile.dart';

class ModBaseLayout extends StatefulWidget {
  final String title;
  final Widget? logo;
  final Widget? body;
  final List<String>? claims;
  final List<MenuGroup>? menuGroups;
  final List<ModuleMenu>? moduleMenuGroups;
  final UserProfile? userProfile;
  final List<Widget>? appBarActions;
  final bool showDefaultActions;
  final Widget? sidebarHeader;
  final Widget? sidebarFooter;
  final Widget? footer;
  final Border? footerBorder;
  final Color? sidebarBackgroundColor;
  final Color? sidebarSelectedColor;
  final Color? sidebarUnselectedColor;
  final double footerHeight;
  final Widget? drawerHeader;
  final Color? lightBackgroundColor;
  final Color? darkBackgroundColor;
  final Color? lightForegroundColor;
  final Color? darkForegroundColor;
  final bool showAppBar;
  final Color? drawerBackgroundColor;
  final String? loginRoute;
  final VoidCallback? onNoAccessRedirect;
  final bool disableClaimsValidation;

  const ModBaseLayout({
    super.key,
    required this.title,
    this.logo,
    required this.body,
    this.claims,
    this.menuGroups,
    this.moduleMenuGroups,
    this.userProfile,
    this.appBarActions,
    this.showDefaultActions = true,
    this.sidebarHeader,
    this.sidebarFooter,
    this.footer,
    this.footerBorder,
    this.sidebarBackgroundColor,
    this.sidebarSelectedColor,
    this.sidebarUnselectedColor,
    this.footerHeight = 50.0,
    this.drawerHeader,
    this.lightBackgroundColor,
    this.darkBackgroundColor,
    this.lightForegroundColor,
    this.darkForegroundColor,
    this.showAppBar = true,
    this.drawerBackgroundColor,
    this.loginRoute,
    this.onNoAccessRedirect,
    this.disableClaimsValidation = false,
  }) : assert(menuGroups != null || moduleMenuGroups != null,
            'Pelo menos um de menuGroups ou moduleMenuGroups deve ser fornecido');

  @override
  State<ModBaseLayout> createState() => _ModBaseLayoutState();
}

class _ModBaseLayoutState extends State<ModBaseLayout> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  bool isDrawerOpen = false;

  @override
  void initState() {
    super.initState();

    // Se tivermos módulos visíveis e nenhum módulo estiver selecionado, selecione o primeiro
    if (widget.moduleMenuGroups != null &&
        _filteredModules.isNotEmpty &&
        Get.find<LayoutController>().selectedModule.value == null) {
      Get.find<LayoutController>().setSelectedModule(_filteredModules.first);
    }
  }

  bool _hasValidClaim(MenuItem item) {
    if (widget.claims == null || widget.claims!.isEmpty) {
      return true;
    }

    // First priority: check claimName
    if (item.claimName != null) {
      return widget.claims!.contains(item.claimName!);
    }

    // Second priority: check type:value combination
    if (item.type != null && item.value != null) {
      return widget.claims!.contains("${item.type}:${item.value}");
    }

    // If both are null and claims exist, don't show the item
    return false;
  }

  bool _hasValidGroupClaim(MenuGroup group) {
    if (widget.claims == null || widget.claims!.isEmpty) {
      return true;
    }

    // Check if MenuGroup has claimName and validate it
    if (group.claimName != null) {
      return widget.claims!.contains(group.claimName!);
    }

    // If no claimName, check if any items are visible
    return group.items.any((item) => _hasValidClaim(item));
  }

  bool _hasValidModuleClaim(ModuleMenu module) {
    if (widget.claims == null || widget.claims!.isEmpty) {
      return true;
    }

    // Check if any menu group in the module is visible
    return module.menuGroups.any((group) => _hasValidGroupClaim(group));
  }

  List<ModuleMenu> get _filteredModules {
    // If claims validation is disabled, return all modules
    if (widget.disableClaimsValidation) {
      return widget.moduleMenuGroups ?? [];
    }

    return widget.moduleMenuGroups
            ?.where((module) => _hasValidModuleClaim(module))
            .toList() ??
        [];
  }

  bool get _shouldShowNoAccessScreen {
    // Never show no access screen if claims validation is disabled
    if (widget.disableClaimsValidation) {
      return false;
    }

    // Only show no access screen if claims are provided and no modules are available
    if (widget.claims == null || widget.claims!.isEmpty) {
      return false;
    }

    // Check if using modules system
    if (widget.moduleMenuGroups != null) {
      return _filteredModules.isEmpty;
    }

    // Check if using menu groups system
    if (widget.menuGroups != null) {
      return !widget.menuGroups!.any((group) => _hasValidGroupClaim(group));
    }

    return false;
  }

  List<MenuGroup> get currentMenuGroups {
    final LayoutController controller = Get.find();

    if (widget.moduleMenuGroups != null &&
        controller.selectedModule.value != null) {
      return controller.selectedModule.value!.menuGroups;
    }

    return widget.menuGroups ?? [];
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final LayoutController layoutController = Get.find();

    // Atualizar o layout controller quando as dependências mudarem
    if (widget.moduleMenuGroups != null &&
        _filteredModules.isNotEmpty &&
        layoutController.selectedModule.value == null) {
      layoutController.setSelectedModule(_filteredModules.first);
    }
  }

  @override
  Widget build(BuildContext context) {
    final LayoutController layoutController = Get.find();
    layoutController.checkScreenSize(context);

    // Show no access screen if user has no permissions
    if (_shouldShowNoAccessScreen) {
      debugPrint('[ModBaseLayout] Showing NoAccessScreen');
      debugPrint('[ModBaseLayout] loginRoute: ${widget.loginRoute}');
      debugPrint('[ModBaseLayout] onNoAccessRedirect callback: ${widget.onNoAccessRedirect != null}');
      debugPrint('[ModBaseLayout] claims: ${widget.claims}');
      debugPrint('[ModBaseLayout] filteredModules count: ${_filteredModules.length}');
      
      return NoAccessScreen(
        loginRoute: widget.loginRoute,
        onLoginRedirect: widget.onNoAccessRedirect,
      );
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
        key: scaffoldKey,
        appBar: widget.showAppBar
            ? PreferredSize(
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
              )
            : null,
        drawer: layoutController.isMobile.value
            ? MobileDrawer(
                header: widget.drawerHeader,
                menuGroups: currentMenuGroups,
                moduleMenuGroups: widget.moduleMenuGroups,
                claims: widget.claims,
                backgroundColor: widget.drawerBackgroundColor ??
                    widget.sidebarBackgroundColor,
                selectedColor: widget.sidebarSelectedColor,
                unselectedColor: widget.sidebarUnselectedColor,
              )
            : null,
        body: Row(
          children: [
            if (!layoutController.isMobile.value)
              Obx(() {
                // Observe apenas o estado de expansão do menu e o módulo selecionado
                final isExpanded = layoutController.isMenuExpanded.value;
                //final selectedModule = layoutController.selectedModule.value;

                const double collapsedWidth = 70.0;
                const double expandedWidth = 240.0;

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: isExpanded ? expandedWidth : collapsedWidth,
                  child: Column(
                    children: [
                      if (widget.moduleMenuGroups != null &&
                          _filteredModules.isNotEmpty)
                        SizedBox(
                          width: isExpanded ? expandedWidth : collapsedWidth,
                          child: ModuleSelector(
                            modules: _filteredModules,
                            claims: widget.claims,
                            onModuleSelected: (module) {
                              layoutController.setSelectedModule(module);
                              setState(() {});
                            },
                          ),
                        ),
                      Expanded(
                        child: ModSidebar(
                          claims: widget.claims,
                          menuGroups: currentMenuGroups,
                          backgroundColor: widget.sidebarBackgroundColor,
                          selectedColor: widget.sidebarSelectedColor,
                          unselectedColor: widget.sidebarUnselectedColor,
                          header: widget.sidebarHeader,
                          footer: widget.sidebarFooter,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            Expanded(
              child: Column(
                children: [
                  Expanded(child: widget.body ?? const SizedBox.shrink()),
                  if (widget.footer != null)
                    ModFooter(
                        height: widget.footerHeight,
                        border: widget.footerBorder,
                        child: widget.footer)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
