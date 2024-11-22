import 'package:get/get.dart';

class BaseTranslations extends Translations {
  final Map<String, Map<String, String>>? customTranslations;

  BaseTranslations({this.customTranslations});

  @override
  Map<String, Map<String, String>> get keys {
    // Base translations
    final baseTranslations = {
      'en_US': {
        'home': 'Home',
        'settings': 'Settings',
        'profile': 'Profile',
        'logout': 'Logout',
        'theme': 'Theme',
        'language': 'Language',
        'dark_mode': 'Dark Mode',
        'light_mode': 'Light Mode',
      },
      'pt_BR': {
        'home': 'Início',
        'settings': 'Configurações',
        'profile': 'Perfil',
        'logout': 'Sair',
        'theme': 'Tema',
        'language': 'Idioma',
        'dark_mode': 'Modo Escuro',
        'light_mode': 'Modo Claro',
      },
      'es_ES': {
        'home': 'Inicio',
        'settings': 'Ajustes',
        'profile': 'Perfil',
        'logout': 'Salir',
        'theme': 'Tema',
        'language': 'Idioma',
        'dark_mode': 'Modo Oscuro',
        'light_mode': 'Modo Claro',
      },
    };

    // Merge with custom translations if provided
    if (customTranslations != null) {
      for (final locale in customTranslations!.keys) {
        if (baseTranslations.containsKey(locale)) {
          baseTranslations[locale]!.addAll(customTranslations![locale]!);
        } else {
          baseTranslations[locale] = customTranslations![locale]!;
        }
      }
    }

    return baseTranslations;
  }
}
