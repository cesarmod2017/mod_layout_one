import 'package:example/controllers/app_controller.dart';
import 'package:example/pages/avatars_page.dart';
import 'package:example/pages/buttons_page.dart';
import 'package:example/pages/card_page.dart';
import 'package:example/pages/dialogs_page.dart';
import 'package:example/pages/home_page.dart';
import 'package:example/pages/loading_page.dart';
import 'package:example/pages/modal_page.dart';
import 'package:example/pages/tables_page.dart';
import 'package:example/pages/tabs_page.dart';
import 'package:example/pages/textbox_page.dart';
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
          title: 'buttons'.tr,
          icon: Icons.smart_button,
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
          title: 'tables'.tr,
          icon: Icons.table_chart,
          route: '/tables',
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
      title: title,
      lightBackgroundColor: Colors.blue,
      lightForegroundColor: Colors.white,
      darkBackgroundColor: Colors.green,
      darkForegroundColor: Colors.white,
      sidebarSelectedColor: Colors.red,
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
      claims: const [
        'menu:avatars',
        'menu:buttons',
        'menu:cards',
        'menu:dialogs',
        'menu:home',
        'menu:tabs',
        'menu:modals',
        'menu:textboxes',
        'menu:tables',
        'menu:loading',
      ],
      menuGroups: const [
        MenuGroup(
          title: Text('Components'),
          items: [
            MenuItem(
              title: 'Corporate',
              icon: Icons.business,
              //route: '/avatars',
              type: 'menu',
              value: 'avatars',
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
                    MenuItem(
                      title: 'avatars',
                      icon: Icons.account_circle,
                      route: '/avatars',
                      type: 'menu',
                      value: 'avatars',
                    ),
                    MenuItem(
                      title: 'avatars',
                      icon: Icons.account_circle,
                      route: '/avatars',
                      type: 'menu',
                      value: 'avatars',
                    ),
                    MenuItem(
                      title: 'avatars 4',
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
      body: Center(
        child: ModCard(
          header: Text('settings'.tr),
          content: Text('settings_content'.tr),
        ),
      ),
    );
  }
}
