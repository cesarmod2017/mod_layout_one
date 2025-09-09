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
        'no_access_title': 'Access Restricted',
        'no_access_message': 'You do not have permission to access any resources. Please contact your administrator or try logging in again.',
        'logout_button': 'Login Again',
        'Configuration Error': 'Configuration Error',
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
        'no_access_title': 'Acesso Restrito',
        'no_access_message': 'Você não tem permissão para acessar nenhum recurso. Entre em contato com o administrador ou tente fazer login novamente.',
        'logout_button': 'Entrar Novamente',
        'Configuration Error': 'Erro de Configuração',
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
        'no_access_title': 'Acceso Restringido',
        'no_access_message': 'No tienes permisos para acceder a ningún recurso. Contacta con el administrador o intenta iniciar sesión nuevamente.',
        'logout_button': 'Iniciar Sesión',
        'Configuration Error': 'Error de Configuración',
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
