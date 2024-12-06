import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mod_layout_one/mod_layout_one.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late SharedPreferences prefs;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
  });

  group('ThemeController Tests', () {
    test('should toggle theme mode', () {
      final controller = ThemeController(prefs);

      expect(controller.isDarkMode.value, false);

      controller.toggleTheme();
      expect(controller.isDarkMode.value, true);

      controller.toggleTheme();
      expect(controller.isDarkMode.value, false);
    });

    test('should persist theme mode', () async {
      final controller = ThemeController(prefs);

      controller.toggleTheme();
      expect(prefs.getBool('theme_mode'), true);

      controller.toggleTheme();
      expect(prefs.getBool('theme_mode'), false);
    });
  });

  group('LanguageController Tests', () {
    test('should change language', () {
      final controller = LanguageController(prefs);

      expect(controller.currentLocale.value, 'en_US');

      controller.changeLanguage('pt_BR');
      expect(controller.currentLocale.value, 'pt_BR');

      controller.changeLanguage('es_ES');
      expect(controller.currentLocale.value, 'es_ES');
    });

    test('should persist language selection', () {
      final controller = LanguageController(prefs);

      controller.changeLanguage('pt_BR');
      expect(prefs.getString('language_code'), 'pt_BR');
    });
  });

  group('LayoutController Tests', () {
    test('should toggle menu', () {
      final controller = LayoutController();

      expect(controller.isMenuExpanded.value, false);

      controller.toggleMenu();
      expect(controller.isMenuExpanded.value, true);

      controller.toggleMenu();
      expect(controller.isMenuExpanded.value, false);
    });

    test('should update selected route', () {
      final controller = LayoutController();

      controller.setSelectedRoute('/home');
      expect(controller.selectedRoute.value, '/home');

      controller.setSelectedRoute('/settings');
      expect(controller.selectedRoute.value, '/settings');
    });
  });

  group('Widget Tests', () {
    testWidgets('ModCard should render correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ModCard(
              header: Text('Test Header'),
              content: Text('Test Content'),
              footer: Text('Test Footer'),
            ),
          ),
        ),
      );

      expect(find.text('Test Header'), findsOneWidget);
      expect(find.text('Test Content'), findsOneWidget);
      expect(find.text('Test Footer'), findsOneWidget);
    });

    testWidgets('ModGrid should render correct number of items',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ModGrid(
              itemCount: 4,
              itemBuilder: (context, index) => Text('Item $index'),
            ),
          ),
        ),
      );

      expect(find.byType(Text), findsNWidgets(4));
      expect(find.text('Item 0'), findsOneWidget);
      expect(find.text('Item 3'), findsOneWidget);
    });

    testWidgets('ModBaseLayout should render all components',
        (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      await ModLayout.init(
        config: ModLayoutConfig(
          appTitle: 'Test App',
          menuItems: [
            const MenuItem(
              title: 'Home',
              icon: Icons.home,
              route: '/home',
            ),
          ],
        ),
        prefs: prefs,
      );

      await tester.pumpWidget(
        const GetMaterialApp(
          home: ModBaseLayout(
            title: 'Test',
            menuGroups: [
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
                ],
              ),
            ],
            body: Center(
              child: Text('Test Body'),
            ),
          ),
        ),
      );

      expect(find.text('Test'), findsOneWidget);
      expect(find.text('Test Body'), findsOneWidget);
      expect(find.byIcon(Icons.home), findsOneWidget);
    });
  });

  group('Grid System Tests', () {
    testWidgets('ModContainer should render with correct width',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ModContainer(
              child: Text('Test Container'),
            ),
          ),
        ),
      );

      expect(find.text('Test Container'), findsOneWidget);
    });

    testWidgets('ModRow with ModColumns should render correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ModRow(
              columns: [
                ModColumn(
                  columnSizes: {
                    ScreenSize.xs: ColumnSize.col6,
                    ScreenSize.md: ColumnSize.col4,
                  },
                  child: Text('Column 1'),
                ),
                ModColumn(
                  columnSizes: {
                    ScreenSize.xs: ColumnSize.col6,
                    ScreenSize.md: ColumnSize.col4,
                  },
                  child: Text('Column 2'),
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Column 1'), findsOneWidget);
      expect(find.text('Column 2'), findsOneWidget);
    });
  });

  group('Integration Tests', () {
    testWidgets('Theme toggle should work with layout',
        (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      await ModLayout.init(
        config: ModLayoutConfig(
          appTitle: 'Test App',
          menuItems: [
            const MenuItem(
              title: 'Home',
              icon: Icons.home,
              route: '/home',
            ),
          ],
        ),
        prefs: prefs,
      );

      await tester.pumpWidget(
        const GetMaterialApp(
          home: ModBaseLayout(
            title: 'Test',
            menuGroups: [],
            body: Center(
              child: Text('Test Body'),
            ),
          ),
        ),
      );

      // Find and tap theme toggle button
      final themeToggle = find.byType(ThemeToggle);
      await tester.tap(themeToggle);
      await tester.pumpAndSettle();

      // Verify theme controller state
      final ThemeController themeController = Get.find();
      expect(themeController.isDarkMode.value, true);
    });
  });
}
