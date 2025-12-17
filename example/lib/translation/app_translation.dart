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
        'welcome': 'Welcome',
        'language_english': 'English',
        'language_portuguese': 'Portuguese',
        'language_spanish': 'Spanish',
        'charts': 'Charts',
        'toast': 'Toast',
        'dropdowns': 'Dropdowns',
        'progress': 'Progress',
        'wheelSlider': 'Wheel Slider',
        // Table column fields
        'name': 'Name',
        'age': 'Age',
        'city': 'City',
        'id': 'ID',
        'department': 'Department',
        'position': 'Position',
        'salary': 'Salary',
        'startDate': 'Start Date',
        'location': 'Location',
        'email': 'Email',
        'phone': 'Phone',
        'status': 'Status',
        'projects': 'Projects',
        'performance': 'Performance',
        'training': 'Training',
        'certifications': 'Certifications',
        'notes': 'Notes',
        'col1': 'Column 1',
        'col2': 'Column 2',
        'col3': 'Column 3',
        'col4': 'Column 4',
        'col5': 'Column 5',
        'col6': 'Column 6',
        'col7': 'Column 7',
        'col8': 'Column 8',
        'product': 'Product',
        'price': 'Price',
        'stock': 'Stock',
      },
      'pt_BR': {
        'settings_content': 'Conteúdo das configurações aqui',
        'welcome': 'Bem-vindo',
        'language_english': 'Inglês',
        'language_portuguese': 'Português',
        'language_spanish': 'Espanhol',
        'charts': 'Gráficos',
        'toast': 'Toast',
        'dropdowns': 'Dropdowns',
        'progress': 'Progresso',
        'wheelSlider': 'Wheel Slider',
        // Table column fields
        'name': 'Nome',
        'age': 'Idade',
        'city': 'Cidade',
        'id': 'ID',
        'department': 'Departamento',
        'position': 'Cargo',
        'salary': 'Salário',
        'startDate': 'Data de Início',
        'location': 'Localização',
        'email': 'E-mail',
        'phone': 'Telefone',
        'status': 'Status',
        'projects': 'Projetos',
        'performance': 'Desempenho',
        'training': 'Treinamento',
        'certifications': 'Certificações',
        'notes': 'Observações',
        'col1': 'Coluna 1',
        'col2': 'Coluna 2',
        'col3': 'Coluna 3',
        'col4': 'Coluna 4',
        'col5': 'Coluna 5',
        'col6': 'Coluna 6',
        'col7': 'Coluna 7',
        'col8': 'Coluna 8',
        'product': 'Produto',
        'price': 'Preço',
        'stock': 'Estoque',
      },
      'es_ES': {
        'settings_content': 'Contenido de las configuraciones aquí',
        'welcome': 'Bienvenido',
        'language_english': 'Inglés',
        'language_portuguese': 'Portugués',
        'language_spanish': 'Español',
        'charts': 'Gráficos',
        'toast': 'Toast',
        'dropdowns': 'Dropdowns',
        'progress': 'Progreso',
        'wheelSlider': 'Wheel Slider',
        // Table column fields
        'name': 'Nombre',
        'age': 'Edad',
        'city': 'Ciudad',
        'id': 'ID',
        'department': 'Departamento',
        'position': 'Cargo',
        'salary': 'Salario',
        'startDate': 'Fecha de Inicio',
        'location': 'Ubicación',
        'email': 'Correo Electrónico',
        'phone': 'Teléfono',
        'status': 'Estado',
        'projects': 'Proyectos',
        'performance': 'Rendimiento',
        'training': 'Capacitación',
        'certifications': 'Certificaciones',
        'notes': 'Notas',
        'col1': 'Columna 1',
        'col2': 'Columna 2',
        'col3': 'Columna 3',
        'col4': 'Columna 4',
        'col5': 'Columna 5',
        'col6': 'Columna 6',
        'col7': 'Columna 7',
        'col8': 'Columna 8',
        'product': 'Producto',
        'price': 'Precio',
        'stock': 'Inventario',
      }
    };

    // Merge base translations with custom translations
    for (final locale in baseKeys.keys) {
      baseKeys[locale]!.addAll(customKeys[locale] ?? {});
    }

    return baseKeys;
  }
}
