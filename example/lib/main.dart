import 'dart:developer';

import 'package:example/controllers/app_controller.dart';
import 'package:example/controllers/textcopy_binding.dart';
import 'package:example/pages/avatars_page.dart';
import 'package:example/pages/buttons_page.dart';
import 'package:example/pages/card_page.dart';
import 'package:example/pages/charts_page.dart';
import 'package:example/pages/dialogs_page.dart';
import 'package:example/pages/dropdown_page.dart';
import 'package:example/pages/home_page.dart';
import 'package:example/pages/loading_page.dart';
import 'package:example/pages/login_page.dart';
import 'package:example/pages/modal_page.dart';
import 'package:example/pages/progress_page.dart';
import 'package:example/pages/tables_page.dart';
import 'package:example/pages/tabs_page.dart';
import 'package:example/pages/textbox_page.dart';
import 'package:example/pages/textcopy_page.dart';
import 'package:example/pages/toast_page.dart';
import 'package:example/pages/tree_view_page.dart';
import 'package:example/services/auth_service.dart';
import 'package:example/services/storage_service.dart';
import 'package:example/theme/app_theme.dart';
import 'package:example/translation/app_translation.dart';
import 'package:example/widgets/profile_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mod_layout_one/mod_layout_one.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();

  final authService = AuthService(prefs);
  final storageService = StorageService(prefs);

  Get.put(authService, permanent: true);
  Get.put(storageService, permanent: true);
  Get.put(AppController(), permanent: true);

  await ModLayout.init(
    config: ModLayoutConfig(
      appTitle: 'Example App',
      darkTheme: MyAppTheme.dark,
      lightTheme: MyAppTheme.light,
      menuItems: [
        MenuItem(
          title: 'avatars'.tr,
          icon: Icons.account_circle,
          route: '/avatars',
        ),
        MenuItem(
          title: 'textCopy'.tr,
          icon: Icons.text_decrease,
          route: '/textCopy',
          reloadOnNavigate: true,
        ),
        MenuItem(
          title: 'buttons'.tr,
          icon: Icons.dangerous,
          route: '/buttons',
        ),
        MenuItem(
          title: 'cards'.tr,
          icon: Icons.style,
          route: '/cards',
        ),
        MenuItem(
          title: 'dialogs'.tr,
          icon: Icons.chat_bubble_outline,
          route: '/dialogs',
        ),
        MenuItem(
          title: 'home'.tr,
          icon: Icons.home,
          route: '/home',
        ),
        MenuItem(
          title: 'tabs'.tr,
          icon: Icons.tab,
          route: '/tabs',
        ),
        MenuItem(
          title: 'tables'.tr,
          icon: Icons.table_chart,
          route: '/tables',
        ),
        MenuItem(
          title: 'modals'.tr,
          icon: Icons.window,
          route: '/modals',
        ),
        MenuItem(
          title: 'textboxes'.tr,
          icon: Icons.text_fields,
          route: '/textboxes',
        ),
        MenuItem(
          title: 'dropdowns'.tr,
          icon: Icons.arrow_drop_down_circle,
          route: '/dropdowns',
        ),
        MenuItem(
          title: 'tables'.tr,
          icon: Icons.table_chart,
          route: '/tables',
        ),
        MenuItem(
          title: 'charts'.tr,
          icon: Icons.bar_chart,
          route: '/charts',
        ),
        MenuItem(
          title: 'toast'.tr,
          icon: Icons.notifications,
          route: '/toast',
        ),
        MenuItem(
          title: 'progress'.tr,
          icon: Icons.trending_up,
          route: '/progress',
        ),
      ],
      customTranslations:
          AppTranslations().keys, // Pass the translations directly
    ),
    prefs: prefs,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return Obx(() => GetMaterialApp(
          title: 'Mod Layout Example',
          theme: MyAppTheme.light,
          darkTheme: MyAppTheme.dark,
          themeMode: themeController.isDarkMode.value
              ? ThemeMode.dark
              : ThemeMode.light,
          navigatorObservers: [
            ModLoadingNavigatorObserver(),
          ],
          translations: AppTranslations(),
          locale: Get.find<LanguageController>().currentLocale.value.isNotEmpty
              ? Locale(
                  Get.find<LanguageController>()
                      .currentLocale
                      .value
                      .split('_')[0],
                  Get.find<LanguageController>()
                      .currentLocale
                      .value
                      .split('_')[1],
                )
              : const Locale('en', 'US'),
          fallbackLocale: const Locale('en', 'US'),
          debugShowCheckedModeBanner: false,
          getPages: [
            GetPage(
              name: '/login',
              page: () => const LoginPage(),
              transition: Transition.noTransition,
              preventDuplicates: true,
            ),
            GetPage(
              name: '/home',
              page: () => const HomePage(),
              transition: Transition.noTransition,
              preventDuplicates: true,
            ),
            GetPage(
              name: '/dialogs',
              page: () => const DialogsPage(),
              transition: Transition.noTransition,
              preventDuplicates: true,
            ),
            GetPage(
              name: '/cards',
              page: () => const CardPage(),
              transition: Transition.noTransition,
              preventDuplicates: true,
            ),
            GetPage(
              name: '/buttons',
              page: () => const ButtonsPage(),
              transition: Transition.noTransition,
              preventDuplicates: true,
            ),
            GetPage(
              name: '/avatars',
              page: () => const AvatarsPage(),
              transition: Transition.noTransition,
              preventDuplicates: true,
            ),
            GetPage(
              name: '/textCopy',
              page: () => const TextCopyPage(),
              binding: TextCopyBinding(),
              transition: Transition.noTransition,
              preventDuplicates: true,
            ),
            GetPage(
              name: '/modals',
              page: () => const ModalPage(),
              transition: Transition.noTransition,
              preventDuplicates: true,
            ),
            GetPage(
              name: '/textboxes',
              page: () => const TextBoxPage(),
              transition: Transition.noTransition,
              preventDuplicates: true,
            ),
            GetPage(
              name: '/dropdowns',
              page: () => const DropdownPage(),
              transition: Transition.noTransition,
              preventDuplicates: true,
            ),
            GetPage(
              name: '/tables',
              page: () => const TablesPage(),
              transition: Transition.noTransition,
              preventDuplicates: true,
            ),
            GetPage(
              name: '/tabs',
              page: () => const TabsPage(),
              transition: Transition.noTransition,
              preventDuplicates: true,
            ),
            GetPage(
              name: '/loading',
              page: () => const LoadingPage(),
              transition: Transition.noTransition,
              preventDuplicates: true,
            ),
            GetPage(
              name: '/treeview',
              page: () => const TreeViewPage(),
              transition: Transition.noTransition,
              preventDuplicates: true,
            ),
            GetPage(
              name: '/charts',
              page: () => const ChartsPage(),
              transition: Transition.noTransition,
              preventDuplicates: true,
            ),
            GetPage(
              name: '/toast',
              page: () => const ToastPage(),
              transition: Transition.noTransition,
              preventDuplicates: true,
            ),
            GetPage(
              name: '/progress',
              page: () => const ProgressPage(),
              transition: Transition.noTransition,
              preventDuplicates: true,
            ),
          ],
          initialRoute: '/home',
        ));
  }
}

class CustomLayout extends StatelessWidget {
  final String title;
  final Widget body;
  final Widget? footer;
  const CustomLayout(
      {super.key, required this.title, required this.body, this.footer});

  @override
  Widget build(BuildContext context) {
    return ModBaseLayout(
      showAppBar: true,
      title: title,
      lightBackgroundColor: Colors.blue,
      lightForegroundColor: Colors.white,
      darkBackgroundColor: const Color.fromARGB(255, 117, 4, 119),
      darkForegroundColor: Colors.white,
      sidebarSelectedColor: Colors.red,
      footerBackgroundColor: Get.theme.scaffoldBackgroundColor,
      appBarActions: const [
        ProfileWidget(
          showFullProfile: true,
        )
      ],
      drawerHeader: Container(
        padding: const EdgeInsets.all(16),
        child: const Column(
          children: [
            CircularProgressIndicator(),
            Text('User Name'),
            Text('user@email.com'),
          ],
        ),
      ),
      loginRoute: '/login',
      claims: const [
        'menu:avatars',
        'menu:textCopy',
        'menu:buttons',
        'menu:cards',
        'menu:dialogs',
        'menu:home',
        'menu:tabs',
        'menu:modals',
        'menu:textboxes',
        'menu:dropdowns',
        'menu:tables',
        'menu:loading',
        'menu:treeview',
        'menu:charts',
        'menu:toast',
        'menu:progress',
        'module:administrativo',
        'module:documentos',
      ],
      moduleMenuGroups: [
        ModuleMenu(
          name: 'Administrativo',
          icon: Icons.admin_panel_settings,
          fontSize: 14.0,
          fontWeight: FontWeight.w600,
          iconSize: 18.0,
          description: 'Módulo de administração do sistema',
          onSelect: (module) async {
            // Ação a ser executada quando o módulo for selecionado
            log('Module selected: ${module.name}');
          },
          menuGroups: [
            const MenuGroup(
              title: Text('Components Administrativo'),
              fontSize: 14.0,
              claimName: 'module:administrativo',
              items: [
                MenuItem(
                  title: 'Corporate',
                  icon: Icons.business,
                  //fontSize: 10.0,
                  //iconSize: 10.0,
                  //route: '/avatars',
                  // type: 'menu',
                  // value: 'avatars',
                  claimName: 'menu:avatars',
                  subItems: [
                    MenuItem(
                      title: 'avatars',
                      icon: Icons.telegram,
                      type: 'menu',
                      value: 'avatars',
                      subItems: [
                        MenuItem(
                          title: 'avatars',
                          icon: Icons.account_circle,
                          route: '/avatars',
                          type: 'menu',
                          value: 'avatars',
                        ),
                      ],
                    ),
                    MenuItem(
                      title: 'buttons',
                      icon: Icons.smart_button,
                      route: '/buttons',
                      type: 'menu',
                      value: 'buttons',
                    ),
                  ],
                ),
                MenuItem(
                  title: 'textCopy',
                  icon: Icons.text_decrease,
                  route: '/textCopy',
                  type: 'menu',
                  value: 'textCopy',
                  reloadOnNavigate: true,
                ),
                MenuItem(
                  title: 'avatars',
                  icon: Icons.account_circle,
                  route: '/avatars',
                  type: 'menu',
                  value: 'avatars',
                ),
                MenuItem(
                  title: 'buttons',
                  icon: Icons.smart_button,
                  route: '/buttons',
                  type: 'menu',
                  value: 'buttons',
                ),
                MenuItem(
                  title: 'cards',
                  icon: Icons.style,
                  route: '/cards',
                  type: 'menu',
                  value: 'cards',
                ),
                MenuItem(
                  title: 'dialogs',
                  icon: Icons.chat_bubble_outline,
                  route: '/dialogs',
                  type: 'menu',
                  value: 'dialogs',
                ),
                MenuItem(
                  title: 'home',
                  icon: Icons.home,
                  route: '/home',
                  type: 'menu',
                  value: 'home',
                ),
                MenuItem(
                  title: 'tabs',
                  icon: Icons.tab,
                  route: '/tabs',
                  type: 'menu',
                  value: 'tabs',
                ),
                MenuItem(
                  title: 'modals',
                  icon: Icons.window,
                  route: '/modals',
                  type: 'menu',
                  value: 'modals',
                ),
                MenuItem(
                  title: 'textboxes',
                  icon: Icons.text_fields,
                  route: '/textboxes',
                  type: 'menu',
                  value: 'textboxes',
                ),
                MenuItem(
                  title: 'dropdowns',
                  icon: Icons.arrow_drop_down_circle,
                  route: '/dropdowns',
                  type: 'menu',
                  value: 'dropdowns',
                ),
                MenuItem(
                  title: 'tables',
                  icon: Icons.table_chart,
                  route: '/tables',
                  type: 'menu',
                  value: 'tables',
                ),
                MenuItem(
                  title: 'loading',
                  icon: Icons.hourglass_empty,
                  route: '/loading',
                  type: 'menu',
                  value: 'loading',
                ),
                MenuItem(
                  title: 'treeview',
                  icon: Icons.folder_open,
                  route: '/treeview',
                  type: 'menu',
                  value: 'treeview',
                ),
                MenuItem(
                  title: 'charts',
                  icon: Icons.bar_chart,
                  route: '/charts',
                  type: 'menu',
                  value: 'charts',
                ),
                MenuItem(
                  title: 'toast',
                  icon: Icons.notifications,
                  route: '/toast',
                  type: 'menu',
                  value: 'toast',
                ),
                MenuItem(
                  title: 'progress',
                  icon: Icons.telegram,
                  route: '/progress',
                  type: 'menu',
                  value: 'progress',
                ),
              ],
            ),
          ],
        ),
        ModuleMenu(
          name: 'Documentos',
          icon: Icons.description,
          description: 'Gestão de documentos',
          fontSize: 16.0,
          fontWeight: FontWeight.w600,
          iconSize: 28.0,
          onSelect: (module) async {
            // Ação a ser executada quando o módulo for selecionado
            log('Module selected: ${module.name}');
            // Removed Get.offAllNamed('/home') to avoid navigation issues
          },
          menuGroups: [
            const MenuGroup(
              title: Text('Components'),
              fontSize: 14.0,
              fontWeight: FontWeight.w500,
              iconSize: 22.0,
              claimName: 'module:documentos',
              items: [
                MenuItem(
                  title: 'Corporate',
                  icon: Icons.business,
                  fontSize: 13.0,
                  fontWeight: FontWeight.w400,
                  iconSize: 20.0,
                  //route: '/avatars',
                  type: 'menu',
                  value: 'avatars',
                  subItems: [
                    MenuItem(
                      title: 'avatars',
                      icon: Icons.telegram,
                      fontSize: 12.0,
                      iconSize: 18.0,
                      type: 'menu',
                      value: 'avatars',
                      subItems: [
                        MenuItem(
                          title: 'avatars',
                          icon: Icons.account_circle,
                          route: '/avatars',
                          type: 'menu',
                          value: 'avatars',
                        ),
                      ],
                    ),
                  ],
                ),
                MenuItem(
                  title: 'textCopy',
                  icon: Icons.text_decrease,
                  route: '/textCopy',
                  type: 'menu',
                  value: 'textCopy',
                  reloadOnNavigate: true,
                ),
              ],
            ),
          ],
        ),
      ],
      body: body,
      footer: footer,
    );
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomLayout(
      title: 'settings'.tr,
      footer: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('footer'.tr),
          Spacer(),
          Text('footer'.tr),
        ],
      ),
      body: Center(
        child: ModCard(
          header: Text('settings'.tr),
          content: Text('settings_content'.tr),
        ),
      ),
    );
  }
}
