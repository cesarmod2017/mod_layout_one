# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

ModLayoutOne is a comprehensive Flutter package for building responsive layouts with built-in theming, internationalization (i18n), and reusable UI components. The package uses GetX for state management and provides a modular architecture for creating enterprise-level Flutter applications.

## Commands

### Development Commands

```bash
# Install dependencies for main package
flutter pub get

# Install dependencies for example app
cd example && flutter pub get && cd ..

# Run static analysis
flutter analyze

# Run tests
flutter test

# Run the example app
cd example && flutter run

# Clean and rebuild
flutter clean && flutter pub get
```

### Package Publishing

```bash
# Dry run to check package validity
flutter pub publish --dry-run

# Publish to pub.dev
flutter pub publish
```

## Architecture

### Core Structure

The package follows a modular architecture with clear separation of concerns:

- **Controllers** (`lib/controllers/`): GetX controllers for theme, language, and layout state management
  - `ThemeController`: Manages light/dark theme switching with SharedPreferences persistence
  - `LanguageController`: Handles i18n and locale changes
  - `LayoutController`: Controls sidebar state and navigation

- **Layout Components** (`lib/layout/`):
  - `ModBaseLayout`: Main scaffold component that integrates sidebar, header, footer
  - Sidebar navigation with multi-level menu support and collapsible groups
  - Responsive design with automatic mobile/desktop layout switching

- **Widget Library** (`lib/widgets/`): Extensive collection of pre-built UI components:
  - Data presentation: DataTable with sorting/pagination, TreeView, Cards
  - Form inputs: TextBox, Dropdown, DropdownSearch with async loading
  - Navigation: Tabs, Modal dialogs
  - Grid system: Bootstrap-inspired responsive grid with breakpoints (xs, sm, md, lg, xl)

- **Theming** (`lib/themes/`): Material Design 3 theming with customizable light/dark themes

- **Translations** (`lib/translations/`): Built-in support for en_US, pt_BR, es_ES with extensible architecture

### Key Design Patterns

1. **Initialization Pattern**: Package requires initialization with `ModLayout.init()` to set up controllers and preferences
2. **Dependency Injection**: Uses GetX for dependency injection and state management
3. **Responsive Design**: Grid system uses column size maps for different screen breakpoints
4. **Theme Persistence**: Theme and language preferences are automatically saved to SharedPreferences

## Testing Approach

Tests are located in `test/mod_layout_one_test.dart` and cover:
- Controller state management and persistence
- Widget rendering and behavior
- Grid system responsiveness
- Integration between components

Run specific test groups:
```bash
flutter test --name "ThemeController"
flutter test --name "Widget Tests"
```

## Development Guidelines

1. **State Management**: Use GetX controllers for all stateful logic
2. **Responsive Design**: Always consider mobile and desktop layouts when adding new components
3. **Internationalization**: Add new strings to all translation files when introducing user-facing text
4. **Theme Support**: Ensure all widgets respect the current theme (light/dark mode)
5. **Widget Exports**: Add new widgets to `mod_layout_one.dart` exports for public API

## Known Issues

- Flutter analyze shows deprecation warnings for `withOpacity` - should be replaced with `withValues()`
- Some print statements in production code should be removed or replaced with proper logging
- Test failures related to SharedPreferences persistence need investigation