# Documentação dos Componentes ModLayout

Esta documentação apresenta exemplos práticos de uso de todos os componentes disponíveis no ModLayout, baseados nos exemplos encontrados na pasta `example/lib/pages`.

## Índice

1. [ModButton](#modbutton)
2. [ModCard](#modcard)
3. [ModTextCopy](#modtextcopy)
4. [ModAvatar](#modavatar)
5. [ModLoading](#modloading)
6. [ModTabs](#modtabs)
7. [ModModal](#modmodal)
8. [ModTextBox e ModDropDown](#modtextbox-e-moddropdown)
9. [ModDialog](#moddialog)
10. [ModDataTable](#moddatatable)
11. [TreeView](#treeview)
12. [CustomLayout](#customlayout)

---

## ModButton

O `ModButton` é um componente versátil para criação de botões com diferentes estilos e funcionalidades.

### Exemplos Básicos

```dart
// Botão simples
ModButton(
  title: 'Simple Button',
  type: ModButtonType.primary,
  onPressed: () async {},
)

// Botão com ícones
ModButton(
  title: 'Click Me',
  type: ModButtonType.success,
  leftIcon: Icons.add,
  rightIcon: Icons.arrow_forward,
  onPressed: () async {},
)

// Botão com loading
ModButton(
  title: 'Submit',
  type: ModButtonType.info,
  leftIcon: Icons.save,
  onPressed: () async {
    await Future.delayed(const Duration(seconds: 2));
  },
  loadingText: 'Saving...',
)
```

### Tipos de Botão

```dart
// Diferentes tipos de botão
ModButton(title: 'Primary', type: ModButtonType.primary, onPressed: () {}),
ModButton(title: 'Secondary', type: ModButtonType.secondary, onPressed: () {}),
ModButton(title: 'Success', type: ModButtonType.success, onPressed: () {}),
ModButton(title: 'Warning', type: ModButtonType.warning, onPressed: () {}),
ModButton(title: 'Danger', type: ModButtonType.danger, onPressed: () {}),
ModButton(title: 'Dark', type: ModButtonType.dark, onPressed: () {}),
```

### Bordas e Estilos

```dart
// Botão com borda personalizada
ModButton(
  title: 'Primary Border',
  type: ModButtonType.none,
  borderType: ModBorderType.solid,
  borderColor: ModButtonType.primary,
  textColor: Colors.blue,
  onPressed: () async {},
)

// Diferentes raios de borda
ModButton(
  title: 'Pill Button',
  type: ModButtonType.primary,
  borderRadius: 50,
  onPressed: () async {},
)
```

---

## ModCard

O `ModCard` é usado para organizar conteúdo em seções visuais bem definidas.

### Exemplos Básicos

```dart
// Card simples
ModCard(
  header: Text("Basic Card Example"),
  content: Center(
    child: Text("This is a simple card with just header and content"),
  ),
)

// Card com footer
ModCard(
  header: Text("Card with Footer"),
  content: Center(
    child: Text("This card demonstrates the usage with a footer section"),
  ),
  footer: Text("Additional information in footer"),
)
```

### Card Accordion

```dart
// Card que pode ser recolhido/expandido
ModCard(
  header: Text("Accordion Card"),
  content: Center(
    child: Text("This card can be collapsed and expanded. Click the header to toggle."),
  ),
  footer: Text("Footer is hidden when collapsed"),
  borderRadius: 16,
  isAccordion: true,
  initiallyExpanded: true,
)

// Accordion com footer sempre visível
ModCard(
  header: Text("Accordion with Visible Footer"),
  content: Center(
    child: Text("This card shows the footer even when content is collapsed"),
  ),
  footer: Text("This footer stays visible when collapsed"),
  borderRadius: 16,
  isAccordion: true,
  showFooterWhenCollapsed: true,
)
```

---

## ModTextCopy

O `ModTextCopy` permite que o usuário copie texto com um simples clique.

### Exemplos de Uso

```dart
// Texto simples copiável
ModTextCopy(
  textToCopy: "Hello World!",
  child: Text(
    "Hello World!",
    style: TextStyle(fontSize: 16),
  ),
)

// Texto longo copiável
ModTextCopy(
  textToCopy: "This is a longer text that can be copied with a single click",
  child: Text(
    "This is a longer text that can be copied with a single click",
    style: TextStyle(
      fontSize: 16,
      color: Colors.blue,
    ),
  ),
)

// Container estilizado copiável
ModTextCopy(
  textToCopy: "example@email.com",
  child: Container(
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(
      color: Colors.grey.withOpacity(0.2),
      borderRadius: BorderRadius.circular(4),
    ),
    child: Text(
      "example@email.com",
      style: TextStyle(
        fontSize: 16,
        fontFamily: "monospace",
      ),
    ),
  ),
)
```

---

## ModAvatar

O `ModAvatar` é usado para exibir avatares de usuários com diferentes formatos e tamanhos.

### Exemplos com Imagens

```dart
// Avatares com diferentes formas
ModAvatar(
  imageUrl: 'https://i.pravatar.cc/150?img=1',
  size: ModAvatarSize.lg,
),
ModAvatar(
  imageUrl: 'https://i.pravatar.cc/150?img=2',
  size: ModAvatarSize.lg,
  shape: ModAvatarShape.square,
),
ModAvatar(
  imageUrl: 'https://i.pravatar.cc/150?img=3',
  size: ModAvatarSize.lg,
  shape: ModAvatarShape.triangle,
),
```

### Avatares com Texto e Ícones

```dart
// Avatar com texto
ModAvatar(
  text: "John Doe",
  size: ModAvatarSize.md,
)

// Avatar com ícone
ModAvatar(
  icon: Icons.person,
  size: ModAvatarSize.md,
  backgroundColor: Colors.green,
)

// Avatar com forma personalizada
ModAvatar(
  text: "Jane Smith",
  size: ModAvatarSize.md,
  shape: ModAvatarShape.square,
  backgroundColor: Colors.orange,
)
```

### Diferentes Tamanhos

```dart
// Tamanhos predefinidos
ModAvatar(text: "XS", size: ModAvatarSize.xs),
ModAvatar(text: "SM", size: ModAvatarSize.sm),
ModAvatar(text: "MD", size: ModAvatarSize.md),
ModAvatar(text: "LG", size: ModAvatarSize.lg),

// Tamanho customizado
ModAvatar(
  text: "Custom Size",
  customSize: 100,
)
```

---

## ModLoading

O `ModLoading` é usado para exibir indicadores de carregamento.

### Loading Básico

```dart
// Mostrar loading básico
ModButton(
  title: "Show Basic Loading",
  type: ModButtonType.none,
  borderType: ModBorderType.solid,
  borderColor: ModButtonType.primary,
  onPressed: () async {
    ModLoading.instance.show(
      config: ModLoadingConfig(
        title: "Carregando...",
        orientation: ModLoadingOrientation.horizontal,
      ),
    );
    await Future.delayed(const Duration(seconds: 2));
    ModLoading.instance.close();
  },
)
```

### Loading Customizado

```dart
// Loading com configurações customizadas
final config = ModLoadingConfig(
  icon: Icons.hourglass_empty,
  size: 32,
  position: ModLoadingPosition.center,
  borderRadius: 16,
  padding: const EdgeInsets.all(24),
  barrierDismissible: false,
  title: "Loading",
  orientation: ModLoadingOrientation.horizontal,
);

ModLoading.instance.show(config: config);
```

---

## ModTabs

O `ModTabs` permite criar interfaces com abas de navegação.

### Tabs Básicas

```dart
ModTabs(
  borderType: TabBorderType.all,
  orientation: TabOrientation.horizontalTop,
  tabs: const [
    ModTab(id: 'tab1', text: 'Tab 1'),
    ModTab(id: 'tab2', text: 'Tab 2'),
    ModTab(id: 'tab3', text: 'Tab 3'),
  ],
  children: [
    Container(
      padding: const EdgeInsets.all(16),
      child: const Text('Content 1'),
    ),
    Container(
      padding: const EdgeInsets.all(16),
      child: const Text('Content 2'),
    ),
    Container(
      padding: const EdgeInsets.all(16),
      child: const Text('Content 3'),
    ),
  ],
)
```

### Diferentes Orientações

```dart
// Tabs na parte inferior
ModTabs(
  orientation: TabOrientation.horizontalBottom,
  tabs: const [
    ModTab(id: 'tab1', text: 'Tab 1'),
    ModTab(id: 'tab2', text: 'Tab 2'),
  ],
  children: [
    Container(child: Text('Content 1')),
    Container(child: Text('Content 2')),
  ],
)

// Tabs verticais à esquerda
ModTabs(
  orientation: TabOrientation.verticalLeft,
  tabs: const [
    ModTab(id: 'tab1', text: 'Tab 1'),
    ModTab(id: 'tab2', text: 'Tab 2'),
  ],
  children: [
    Container(child: Text('Content 1')),
    Container(child: Text('Content 2')),
  ],
)
```

### Tabs com Fechamento

```dart
// Tabs que podem ser fechadas
List<ModTab> tabs = [
  const ModTab(id: 'main', text: 'main.dart', closeable: true),
  const ModTab(id: 'styles', text: 'styles.css', closeable: true),
  const ModTab(id: 'index', text: 'index.html', closeable: true),
];
```

---

## ModModal

O `ModModal` é usado para exibir conteúdo em janelas modais.

### Modal Básico

```dart
ModButton(
  title: "Open Basic Modal",
  onPressed: () async {
    await ModModal.show(
      context: context,
      header: const Text('Basic Modal'),
      height: ModModalHeight.normal,
      maxHeight: 300,
      maxWidth: 400,
      body: Container(
        height: 200,
        child: Text('Modal content here'),
      ),
      footer: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ModButton(
            title: 'Close',
            type: ModButtonType.none,
            borderType: ModBorderType.solid,
            borderColor: ModButtonType.primary,
            onPressed: () async => Navigator.pop(context),
          ),
        ],
      ),
    );
  },
)
```

### Modal com Formulário

```dart
// Modal contendo formulário complexo
await ModModal.show(
  context: context,
  header: const Text('User Form'),
  body: ModContainer(
    child: ModRow(
      columns: [
        ModColumn(
          columnSizes: const {
            ScreenSize.xs: ColumnSize.col12,
            ScreenSize.md: ColumnSize.col6,
          },
          child: ModTextBox(
            label: 'User ID',
            hint: 'Enter user ID',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'User ID required';
              }
              return null;
            },
          ),
        ),
        ModColumn(
          columnSizes: const {
            ScreenSize.xs: ColumnSize.col12,
            ScreenSize.md: ColumnSize.col6,
          },
          child: ModTextBox(
            label: 'Role ID',
            hint: 'Enter role ID',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Role ID required';
              }
              return null;
            },
          ),
        ),
      ],
    ),
  ),
);
```

---

## ModTextBox e ModDropDown

### ModTextBox Básico

```dart
// Campo de texto simples
ModTextBox(
  label: "Name",
  hint: "Enter your name",
  controller: TextEditingController(),
  onChange: (text) {
    print("Name: $text");
  },
)

// Campo de senha
ModTextBox(
  label: "Password",
  hint: "Enter your password",
  isPassword: true,
  controller: TextEditingController(),
  onChange: (text) {
    print("Password: $text");
  },
)
```

### TextBox com Validação

```dart
ModTextBox(
  label: "Email",
  hint: "Enter your email",
  keyboardType: TextInputType.emailAddress,
  inputFormatters: [
    FilteringTextInputFormatter.deny(RegExp(r'[^a-zA-Z0-9@.]'))
  ],
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'Email required';
    }
    return null;
  },
)
```

### Diferentes Tamanhos

```dart
// Tamanhos diferentes
ModTextBox(
  label: "Large TextBox",
  size: ModTextBoxSize.lg,
  controller: TextEditingController(),
)

ModTextBox(
  label: "Medium TextBox",
  size: ModTextBoxSize.md,
  controller: TextEditingController(),
)

ModTextBox(
  label: "Small TextBox",
  size: ModTextBoxSize.sm,
  floatingLabel: true,
  controller: TextEditingController(),
)
```

### ModDropDown

```dart
String? selectedCountry = 'USA';
List<String> countries = ['USA', 'Canada', 'Mexico', 'Brazil'];

ModDropDown<String>(
  label: 'Select Country',
  hint: 'Choose a country',
  value: selectedCountry,
  items: countries
      .map((country) => DropdownMenuItem(
            value: country,
            child: Text(country),
          ))
      .toList(),
  onChanged: (value) {
    setState(() {
      selectedCountry = value;
    });
  },
)
```

---

## ModDialog

O `ModDialog` é usado para exibir diálogos de confirmação e avisos.

### Dialog Básico

```dart
showDialog(
  context: context,
  builder: (context) => ModDialog(
    title: 'Confirmation',
    maxWidth: 400,
    minWidth: 150,
    content: const Text('Are you sure you want to proceed?'),
    buttons: [
      ModButton(
        title: 'Cancel',
        onPressed: () async => Get.back(),
      ),
      ModButton(
        title: 'Confirm',
        type: ModButtonType.primary,
        onPressed: () async => Get.back(),
      ),
    ],
  ),
);
```

### Dialog com Ícones

```dart
// Dialog de aviso
showDialog(
  context: context,
  builder: (context) => ModDialog(
    title: 'Warning',
    icon: Icons.warning_amber_rounded,
    content: const Text('This is a warning message with an icon'),
    buttons: [
      ModButton(
        title: 'OK',
        type: ModButtonType.warning,
        onPressed: () async => Get.back(),
      ),
    ],
  ),
);

// Dialog de sucesso
showDialog(
  context: context,
  builder: (context) => ModDialog(
    title: 'Success',
    icon: Icons.check_circle_outline,
    content: const Text('Operation completed successfully'),
    buttons: [
      ModButton(
        title: 'Close',
        type: ModButtonType.success,
        onPressed: () async => Get.back(),
      ),
    ],
  ),
);
```

### Dialog com Diferentes Configurações

```dart
// Dialog dismissível
ModDialog(
  title: 'Warning',
  dismissible: true,
  content: const Text('This dialog can be dismissed by clicking outside'),
  buttons: [
    ModButton(
      title: 'OK',
      type: ModButtonType.warning,
      onPressed: () async => Get.back(),
    ),
  ],
)

// Dialog não-dismissível
ModDialog(
  title: 'Important Notice',
  dismissible: false,
  content: const Text('This dialog can only be closed using the button'),
  buttons: [
    ModButton(
      title: 'I Understand',
      type: ModButtonType.warning,
      onPressed: () async => Get.back(),
    ),
  ],
)
```

---

## ModDataTable

O `ModDataTable` é usado para exibir dados tabulares com recursos avançados.

### Tabela Básica

```dart
ModDataTable(
  fixedHeader: true,
  enableColumnResize: true,
  headers: [
    ModDataHeader(
      child: Text('Name'),
      widthType: WidthType.fixed,
      width: 150,
      sortable: true,
      field: 'name',
    ),
    ModDataHeader(
      child: Text('Age'),
      widthType: WidthType.fixed,
      width: 100,
      sortable: true,
      field: 'age',
    ),
    ModDataHeader(
      child: Text('City'),
      widthType: WidthType.fixed,
      width: 150,
      sortable: true,
      field: 'city',
    ),
  ],
  data: tableData,
  source: CustomDataSource(tableData),
  currentPage: 0,
  rowsPerPage: 20,
  totalRecords: tableData.length,
  onPageChanged: (page) {
    print('Page changed: $page');
  },
  onSort: (field, direction) {
    print('Sorting by $field in $direction direction');
  },
)
```

### Tabela com Paginação Customizada

```dart
ModDataTable(
  paginationBorderRadius: 50,
  rowsPerPageText: 'Linhas por página',
  paginationText: 'de',
  availableRowsPerPage: const [5, 10, 15, 20, 50, 100, 200],
  oddRowColor: Theme.of(context).colorScheme.surfaceContainerHighest,
  evenRowColor: Theme.of(context).colorScheme.surfaceContainer,
  paginationBackgroundColor: Theme.of(context).colorScheme.surface,
  headerColor: Theme.of(context).colorScheme.surface,
  onRowsPerPageChanged: (rowsPerPage) {
    print('Rows per page changed: $rowsPerPage');
  },
  // ... outros parâmetros
)
```

---

## TreeView

O `TreeView` é usado para exibir estruturas hierárquicas de dados, como sistemas de arquivos ou menus com submenus.

### TreeView Básico

```dart
// Definindo os nós da árvore
List<TreeNode> nodes = [
  TreeNode(
    id: 'root',
    label: 'Projeto',
    iconData: Icons.folder,
    iconColor: Colors.amber,
    isFolder: true,
    isExpanded: true,
    children: [
      TreeNode(
        id: 'src',
        label: 'src',
        iconData: Icons.folder,
        iconColor: Colors.amber,
        isFolder: true,
        children: [
          TreeNode(
            id: 'main.dart',
            label: 'main.dart',
            iconData: Icons.code,
            iconColor: Colors.blue,
            isFolder: false,
          ),
          TreeNode(
            id: 'utils.dart',
            label: 'utils.dart',
            iconData: Icons.code,
            iconColor: Colors.blue,
            isFolder: false,
          ),
        ],
      ),
      TreeNode(
        id: 'pubspec.yaml',
        label: 'pubspec.yaml',
        iconData: Icons.settings,
        iconColor: Colors.purple,
        isFolder: false,
      ),
    ],
  ),
];

// Usando o TreeView
TreeView(
  nodes: nodes,
  onNodeTap: (node) {
    print('Node tapped: ${node.label}');
  },
  onNodeExpand: (node) {
    print('Node expanded: ${node.label}');
  },
  onNodeCollapse: (node) {
    print('Node collapsed: ${node.label}');
  },
)
```

### TreeView com Menu de Contexto

```dart
TreeView(
  nodes: nodes,
  onNodeTap: (node) {
    print('Node selected: ${node.label}');
  },
  onContextMenu: (node, details) {
    // Mostrar menu de contexto
    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        details.globalPosition.dx,
        details.globalPosition.dy,
        details.globalPosition.dx + 1,
        details.globalPosition.dy + 1,
      ),
      items: [
        PopupMenuItem(
          value: 'rename',
          child: Text('Renomear'),
        ),
        PopupMenuItem(
          value: 'delete',
          child: Text('Excluir'),
        ),
        if (node.isFolder)
          PopupMenuItem(
            value: 'new_file',
            child: Text('Novo Arquivo'),
          ),
      ],
    ).then((value) {
      if (value != null) {
        _handleContextMenuAction(value, node);
      }
    });
  },
)
```

### Carregamento de Estrutura de Diretório

```dart
// Função para criar nós a partir de um diretório
Future<TreeNode> _createNodeFromDirectory(FileSystemEntity entity) async {
  final stat = await entity.stat();
  final name = entity.path.split(Platform.pathSeparator).last;
  final isDirectory = entity is Directory;

  if (!isDirectory) {
    // Arquivo
    return TreeNode(
      id: entity.path,
      label: name,
      iconData: _getFileIcon(name),
      iconColor: _getFileIconColor(name),
      isFolder: false,
    );
  }

  // Diretório
  final dir = Directory(entity.path);
  final List<FileSystemEntity> entities = [];

  try {
    await for (final child in dir.list(followLinks: false)) {
      entities.add(child);
    }

    // Ordena: primeiro diretórios, depois arquivos
    entities.sort((a, b) {
      final aIsDir = a is Directory;
      final bIsDir = b is Directory;

      if (aIsDir == bIsDir) {
        return a.path
            .split(Platform.pathSeparator)
            .last
            .compareTo(b.path.split(Platform.pathSeparator).last);
      }

      return aIsDir ? -1 : 1;
    });

    // Processa os itens ordenados
    final List<TreeNode> children = [];
    for (final child in entities) {
      final childNode = await _createNodeFromDirectory(child);
      children.add(childNode);
    }

    return TreeNode(
      id: entity.path,
      label: name,
      iconData: Icons.folder,
      iconColor: Colors.amber,
      isFolder: true,
      isExpanded: false,
      children: children,
    );
  } catch (e) {
    return TreeNode(
      id: entity.path,
      label: name,
      iconData: Icons.folder,
      iconColor: Colors.amber,
      isFolder: true,
      isExpanded: false,
      children: [],
    );
  }
}

// Função para obter ícone do arquivo
IconData _getFileIcon(String fileName) {
  final extension = fileName.split('.').last.toLowerCase();
  switch (extension) {
    case 'dart':
      return Icons.code;
    case 'yaml':
    case 'yml':
      return Icons.settings;
    case 'md':
      return Icons.description;
    case 'json':
      return Icons.data_object;
    case 'png':
    case 'jpg':
    case 'jpeg':
    case 'gif':
      return Icons.image;
    default:
      return Icons.insert_drive_file;
  }
}

// Função para obter cor do ícone
Color? _getFileIconColor(String fileName) {
  final extension = fileName.split('.').last.toLowerCase();
  switch (extension) {
    case 'dart':
      return Colors.blue;
    case 'yaml':
    case 'yml':
      return Colors.purple;
    case 'md':
      return Colors.green;
    case 'json':
      return Colors.orange;
    case 'png':
    case 'jpg':
    case 'jpeg':
    case 'gif':
      return Colors.pink;
    default:
      return Colors.grey;
  }
}
```

### TreeView com Filtro e Busca

```dart
class TreeViewWithSearch extends StatefulWidget {
  @override
  _TreeViewWithSearchState createState() => _TreeViewWithSearchState();
}

class _TreeViewWithSearchState extends State<TreeViewWithSearch> {
  List<TreeNode> allNodes = [];
  List<TreeNode> filteredNodes = [];
  String searchText = '';

  @override
  void initState() {
    super.initState();
    _loadNodes();
  }

  void _filterNodes(String searchTerm) {
    setState(() {
      searchText = searchTerm;
      if (searchTerm.isEmpty) {
        filteredNodes = allNodes;
      } else {
        filteredNodes = _searchInNodes(allNodes, searchTerm.toLowerCase());
      }
    });
  }

  List<TreeNode> _searchInNodes(List<TreeNode> nodes, String searchTerm) {
    List<TreeNode> result = [];

    for (var node in nodes) {
      if (node.label.toLowerCase().contains(searchTerm)) {
        result.add(node);
      } else if (node.children.isNotEmpty) {
        var matchingChildren = _searchInNodes(node.children, searchTerm);
        if (matchingChildren.isNotEmpty) {
          result.add(TreeNode(
            id: node.id,
            label: node.label,
            iconData: node.iconData,
            iconColor: node.iconColor,
            isFolder: node.isFolder,
            isExpanded: true, // Expandir para mostrar resultados
            children: matchingChildren,
          ));
        }
      }
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(8.0),
          child: ModTextBox(
            label: 'Buscar',
            hint: 'Digite para filtrar...',
            onChanged: _filterNodes,
          ),
        ),
        Expanded(
          child: TreeView(
            nodes: filteredNodes,
            onNodeTap: (node) {
              print('Node selected: ${node.label}');
            },
          ),
        ),
      ],
    );
  }
}
```

---

## CustomLayout

O `CustomLayout` é usado como estrutura base para as páginas da aplicação.

### Uso Básico

```dart
CustomLayout(
  title: 'Page Title',
  body: SingleChildScrollView(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      children: [
        // Conteúdo da página
        ModCard(
          header: Text("Example Card"),
          content: Text("Example content"),
        ),
      ],
    ),
  ),
)
```

---

## Configuração do ModLayout

### Inicialização

```dart
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
        title: 'buttons'.tr,
        icon: Icons.dangerous,
        route: '/buttons',
      ),
      // ... outros itens de menu
    ],
    customTranslations: AppTranslations().keys,
  ),
  prefs: prefs,
);
```

### Configuração de Rotas

```dart
GetMaterialApp(
  getPages: [
    GetPage(
      name: '/home',
      page: () => const HomePage(),
      transition: Transition.noTransition,
      preventDuplicates: true,
    ),
    GetPage(
      name: '/buttons',
      page: () => const ButtonsPage(),
      transition: Transition.noTransition,
      preventDuplicates: true,
    ),
    // ... outras rotas
  ],
)
```

---

## Estrutura de Dados para DataTable

```dart
class DataSource extends DataTableSource {
  final List<Map<String, dynamic>> data;

  DataSource(this.data);

  @override
  DataRow? getRow(int index) {
    if (index >= data.length) return null;

    final item = data[index];
    return DataRow(
      cells: [
        DataCell(Text(item['name'] ?? '')),
        DataCell(Text(item['age']?.toString() ?? '')),
        DataCell(Text(item['city'] ?? '')),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;

  @override
  int get selectedRowCount => 0;
}
```

---

Esta documentação cobre todos os principais componentes do ModLayout com exemplos práticos baseados nos arquivos de exemplo encontrados no projeto. Cada componente pode ser customizado ainda mais usando suas propriedades específicas para atender às necessidades da sua aplicação.
