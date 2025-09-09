import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mod_layout_one/mod_layout_one.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize SharedPreferences
  final prefs = await SharedPreferences.getInstance();

  // Initialize ModLayout
  await ModLayout.init(
    config: ModLayoutConfig(
      appTitle: 'Drawer Test App',
      menuItems: [], // Required parameter
    ),
    prefs: prefs,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Drawer Test for Tablet',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      // translations: BaseTranslations(),
      locale: Get.deviceLocale,
      fallbackLocale: const Locale('en', 'US'),
      home: const TestDrawerScreen(),
    );
  }
}

class TestDrawerScreen extends StatefulWidget {
  const TestDrawerScreen({super.key});

  @override
  State<TestDrawerScreen> createState() => _TestDrawerScreenState();
}

class _TestDrawerScreenState extends State<TestDrawerScreen> {
  late List<MenuGroup> menuGroups;

  @override
  void initState() {
    super.initState();
    _setupMenuGroups();
  }

  void _setupMenuGroups() {
    menuGroups = [
      MenuGroup(
        title: const Text('MAIN MENU'),
        items: [
          MenuItem(
            title: 'Dashboard',
            icon: Icons.dashboard,
            route: '/dashboard',
          ),
          MenuItem(
            title: 'Analytics',
            icon: Icons.analytics,
            route: '/analytics',
          ),
          MenuItem(
            title: 'Reports',
            icon: Icons.assessment,
            subItems: [
              MenuItem(
                title: 'Sales Report',
                icon: Icons.attach_money,
                route: '/reports/sales',
              ),
              MenuItem(
                title: 'User Report',
                icon: Icons.people,
                route: '/reports/users',
              ),
            ],
          ),
        ],
      ),
      MenuGroup(
        title: const Text('SETTINGS'),
        items: [
          MenuItem(
            title: 'Profile',
            icon: Icons.person,
            route: '/profile',
          ),
          MenuItem(
            title: 'Preferences',
            icon: Icons.settings,
            route: '/preferences',
          ),
        ],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    // Force drawer testing on all screen sizes
    return ModBaseLayout(
      title: 'Drawer Test',
      menuGroups: menuGroups,
      sidebarBackgroundColor: Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF1E1E1E)
          : const Color(0xFFF5F5F5),
      sidebarSelectedColor: Theme.of(context).colorScheme.primary,
      sidebarUnselectedColor: Theme.of(context).brightness == Brightness.dark
          ? Colors.grey[400]
          : Colors.grey[700],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Tablet Drawer Test',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              'Screen Width: ${MediaQuery.of(context).size.width.toStringAsFixed(0)}',
              style: const TextStyle(fontSize: 18),
            ),
            Text(
              'Is Mobile: ${Get.width < 768}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Log current theme and colors
                debugPrint('Current Theme: ${Theme.of(context).brightness}');
                debugPrint(
                    'Primary Color: ${Theme.of(context).colorScheme.primary}');
                debugPrint(
                    'Scaffold Background: ${Theme.of(context).scaffoldBackgroundColor}');
                debugPrint(
                    'Drawer Background: ${Theme.of(context).drawerTheme.backgroundColor}');
              },
              child: const Text('Debug Theme Info'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Get.find<ThemeController>().toggleTheme();
              },
              child: const Text('Toggle Theme'),
            ),
          ],
        ),
      ),
    );
  }
}
