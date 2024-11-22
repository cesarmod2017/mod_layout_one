import 'package:example/assets/app_images.dart';
import 'package:example/controllers/app_controller.dart';
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
          title: 'home'.tr,
          icon: Icons.home,
          route: '/home',
        ),
        MenuItem(
          title: 'settings'.tr,
          icon: Icons.settings,
          route: '/settings',
        ),
        MenuItem(
          title: 'settings2'.tr,
          icon: Icons.settings,
          route: '/settings2',
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
          locale: Get.deviceLocale,
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
              name: '/settings',
              page: () => const SettingsPage(),
              transition: Transition.noTransition,
              preventDuplicates: true,
            ),
            GetPage(
              name: '/settings2',
              page: () => const SettingsPage(),
              transition: Transition.noTransition,
              preventDuplicates: true,
            ),
          ],
          initialRoute: '/home',
        ));
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ModBaseLayout(
      title: 'home'.tr,
      appBarActions: const [
        ProfileWidget(
          showFullProfile: true,
        )
      ],
      menuItems: [
        MenuItem(
          title: 'home'.tr,
          icon: Icons.home,
          route: '/home',
        ),
        MenuItem(
          title: 'settings'.tr,
          icon: Icons.settings,
          route: '/settings',
        ),
        MenuItem(
          title: 'settings2'.tr,
          icon: Icons.settings,
          route: '/settings2',
        ),
      ],
      body: Center(
        child: ModCard(
          header: Text('welcome'.tr),
          content: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('This is an example of Mod Layout One package'),
              const SizedBox(height: 20),
              ModContainer(
                child: ModRow(
                  columns: [
                    ModColumn(
                      columnSizes: const {
                        ScreenSize.xs: ColumnSize.col12,
                        ScreenSize.md: ColumnSize.col4,
                      },
                      child: Container(
                        color: Colors.blue.withOpacity(0.2),
                        padding: const EdgeInsets.all(16),
                        child: const Text('Column 1'),
                      ),
                    ),
                    ModColumn(
                      columnSizes: const {
                        ScreenSize.xs: ColumnSize.col12,
                        ScreenSize.md: ColumnSize.col4,
                      },
                      child: Container(
                        color: Colors.green.withOpacity(0.2),
                        padding: const EdgeInsets.all(16),
                        child: const Text('Column 2'),
                      ),
                    ),
                    ModColumn(
                      columnSizes: const {
                        ScreenSize.xs: ColumnSize.col12,
                        ScreenSize.md: ColumnSize.col4,
                      },
                      child: Container(
                        color: Colors.red.withOpacity(0.2),
                        padding: const EdgeInsets.all(16),
                        child: const Text('Column 2'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      footer: Row(
        children: [Text('footer'.tr), Text('footer'.tr)],
      ),
    );
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ModBaseLayout(
      title: 'settings'.tr,
      logo: Image.asset(AppImages.logoMod, height: 30),
      appBarActions: const [
        ProfileWidget(
          showFullProfile: true,
        ),
      ],
      menuItems: [
        MenuItem(
          title: 'home'.tr,
          icon: Icons.home,
          route: '/home',
        ),
        MenuItem(
          title: 'settings'.tr,
          icon: Icons.settings,
          route: '/settings',
        ),
        MenuItem(
          title: 'settings2'.tr,
          icon: Icons.settings,
          route: '/settings2',
        ),
      ],
      body: Center(
        child: ModCard(
          header: Text('settings'.tr),
          content: Text('settings_content'.tr),
        ),
      ),
    );
  }
}
