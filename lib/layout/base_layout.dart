import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mod_layout_one/controllers/layout_controller.dart';
import 'package:mod_layout_one/layout/components/footer.dart';
import 'package:mod_layout_one/layout/components/header.dart';
import 'package:mod_layout_one/layout/components/mobile_drawer.dart';
import 'package:mod_layout_one/layout/components/sidebar.dart';
import 'package:mod_layout_one/layout/models/menu_group.dart';
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

    // Se tivermos módulos e nenhum módulo estiver selecionado, selecione o primeiro
    if (widget.moduleMenuGroups != null &&
        widget.moduleMenuGroups!.isNotEmpty &&
        Get.find<LayoutController>().selectedModule.value == null) {
      Get.find<LayoutController>()
          .setSelectedModule(widget.moduleMenuGroups!.first);
    }
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
        widget.moduleMenuGroups!.isNotEmpty &&
        layoutController.selectedModule.value == null) {
      layoutController.setSelectedModule(widget.moduleMenuGroups!.first);
    }
  }

  @override
  Widget build(BuildContext context) {
    final LayoutController layoutController = Get.find();
    layoutController.checkScreenSize(context);

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
                backgroundColor: widget.sidebarBackgroundColor,
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
                      if (widget.moduleMenuGroups != null)
                        SizedBox(
                          width: isExpanded ? expandedWidth : collapsedWidth,
                          child: ModuleSelector(
                            modules: widget.moduleMenuGroups!,
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
