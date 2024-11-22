import 'package:mod_layout_one/mod_layout_one.dart';

class AppTranslations extends BaseTranslations {
  AppTranslations({super.customTranslations});

  @override
  Map<String, Map<String, String>> get keys {
    final baseKeys = super.keys;

    // Add your custom translations
    final customKeys = {
      'en_US': {
        'settings_content': 'Settings content here',
        'welcome': 'Welcome'
      },
      'pt_BR': {
        'settings_content': 'Conteúdo das configurações aqui',
        'welcome': 'Bem-vindo'
      },
      'es_ES': {
        'settings_content': 'Contenido de las configuraciones aquí',
        'welcome': 'Bienvenido'
      }
    };

    // Merge base translations with custom translations
    for (final locale in baseKeys.keys) {
      baseKeys[locale]!.addAll(customKeys[locale] ?? {});
    }

    return baseKeys;
  }
}
