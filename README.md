# ModLayoutOne

A comprehensive Flutter package for building responsive layouts with built-in theming, internationalization, and reusable components.

## Features

- Responsive sidebar navigation
- Light/Dark theme support with customization
- Multi-language support (i18n)
- Grid system for responsive layouts
- Customizable cards
- User profile management
- Modular footer and header components
- Responsive grid system with breakpoints

## Installation

```yaml
dependencies:
  mod_layout_one: ^1.0.0
```

## Basic Usage

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();

  await ModLayout.init(
    config: ModLayoutConfig(
      appTitle: 'My App',
      lightTheme: MyAppTheme.light,  // Custom light theme
      darkTheme: MyAppTheme.dark,    // Custom dark theme
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
      ],
      customTranslations: AppTranslations().keys,
    ),
    prefs: prefs,
  );

  runApp(const MyApp());
}
```

## Advanced Features

### Custom Theme Integration

```dart
class MyAppTheme {
  static final light = ThemeData(
    brightness: Brightness.light,
    // Your custom light theme configuration
  );

  static final dark = ThemeData(
    brightness: Brightness.dark,
    // Your custom dark theme configuration
  );
}
```

### User Profile Integration

```dart
ModBaseLayout(
  title: 'My App',
  appBarActions: [
    ProfileWidget(
      showFullProfile: true,
    )
  ],
  body: YourContent(),
);
```

### Responsive Grid System

```dart
ModContainer(
  child: ModRow(
    columns: [
      ModColumn(
        columnSizes: {
          ScreenSize.xs: ColumnSize.col12,
          ScreenSize.md: ColumnSize.col4,
        },
        child: YourColumnContent(),
      ),
      // Add more columns as needed
    ],
  ),
);
```

### Custom Translations

```dart
class AppTranslations extends BaseTranslations {
  @override
  Map<String, Map<String, String>> get keys {
    final baseKeys = super.keys;

    final customKeys = {
      'en_US': {
        'custom_key': 'Custom Value',
      },
      'pt_BR': {
        'custom_key': 'Valor Personalizado',
      },
      // Add more languages
    };

    // Merge translations
    for (final locale in baseKeys.keys) {
      baseKeys[locale]!.addAll(customKeys[locale] ?? {});
    }

    return baseKeys;
  }
}
```

## Components

### ModCard
```dart
ModCard(
  header: Text('Card Title'),
  content: YourContent(),
  footer: YourFooter(),
  isAccordion: true,
);
```

### ModBaseLayout
```dart
ModBaseLayout(
  title: 'Page Title',
  logo: YourLogo(),               // Optional
  menuItems: yourMenuItems,
  body: YourPageContent(),
  footer: YourFooterWidget(),     // Optional
  sidebarBackgroundColor: color,  // Optional
);
```

## Grid System Breakpoints

- xs: < 576px
- sm: ≥ 576px
- md: ≥ 768px
- lg: ≥ 992px
- xl: ≥ 1200px

## Controllers

- ThemeController: Manages theme switching
- LanguageController: Handles language changes
- LayoutController: Controls layout states (sidebar, responsive behavior)

## Complete Example

For a complete example of how to use ModLayoutOne, check out our [example project](https://github.com/yourusername/mod_layout_one/tree/main/example).

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

```
MIT License
```
