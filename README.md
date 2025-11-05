# ModLayoutOne

Um pacote Flutter completo para construir layouts responsivos com suporte integrado a temas, internacionalização (i18n) e componentes reutilizáveis. O pacote utiliza GetX para gerenciamento de estado e fornece uma arquitetura modular para criar aplicações Flutter de nível empresarial.

## Índice

- [Instalação](#instalação)
- [Configuração Inicial](#configuração-inicial)
- [Componentes](#componentes)
  - [Layout Base](#layout-base)
  - [Botões](#botões)
  - [Caixas de Texto](#caixas-de-texto)
  - [Dropdown](#dropdown)
  - [Dropdown com Pesquisa](#dropdown-com-pesquisa)
  - [Tabela de Dados](#tabela-de-dados)
  - [Cards](#cards)
  - [Modal](#modal)
  - [Toast](#toast)
  - [Tabs](#tabs)
  - [Grid System](#grid-system)
  - [Charts](#charts)
  - [TreeView](#treeview)
  - [Avatars](#avatars)
  - [Loading](#loading)
  - [Labels](#labels)
  - [Dialogs](#dialogs)
  - [Text Utilities](#text-utilities)
- [Controllers](#controllers)
- [Temas](#temas)
- [Internacionalização](#internacionalização)

## Instalação

Adicione ao seu `pubspec.yaml`:

```yaml
dependencies:
  mod_layout_one: ^1.0.0
```

## Configuração Inicial

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();

  await ModLayout.init(
    config: ModLayoutConfig(
      appTitle: 'Meu App',
      lightTheme: MyAppTheme.light,  // Tema claro personalizado
      darkTheme: MyAppTheme.dark,    // Tema escuro personalizado
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
        // MenuItem com arguments para passar dados na navegação
        MenuItem(
          title: 'details'.tr,
          icon: Icons.info,
          route: '/details',
          arguments: {'id': 123, 'mode': 'edit'}, // Dados passados para a rota
        ),
      ],
      customTranslations: AppTranslations().keys,
    ),
    prefs: prefs,
  );

  runApp(const MyApp());
}
```

## Componentes

### Layout Base

O `ModBaseLayout` é o componente principal que integra sidebar, header e footer com suporte responsivo.

#### Passando Argumentos na Navegação

Os itens de menu suportam o parâmetro `arguments` que permite passar dados ao navegar para uma rota usando GetX:

```dart
// Definindo MenuItem com arguments
MenuItem(
  title: 'Editar Produto',
  icon: Icons.edit,
  route: '/product/edit',
  arguments: {
    'productId': 42,
    'mode': 'edit',
    'returnRoute': '/products',
  },
),

// Na página de destino, recupere os argumentos:
class ProductEditPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Recuperar arguments usando GetX
    final arguments = Get.arguments as Map<String, dynamic>?;
    final productId = arguments?['productId'];
    final mode = arguments?['mode'];

    return CustomLayout(
      title: 'Editar Produto #$productId',
      body: ProductEditForm(
        productId: productId,
        mode: mode,
      ),
    );
  }
}
```

Você pode passar qualquer tipo de dado nos arguments: Map, List, objetos customizados, etc.

```dart
ModBaseLayout(
  title: 'Título da Página',
  logo: Image.asset('assets/logo.png'), // Opcional
  menuItems: [
    MenuItem(
      title: 'Dashboard',
      icon: Icons.dashboard,
      route: '/dashboard',
    ),
    MenuGroup(
      title: 'Configurações',
      icon: Icons.settings,
      children: [
        MenuItem(
          title: 'Perfil',
          icon: Icons.person,
          route: '/profile',
        ),
        MenuItem(
          title: 'Segurança',
          icon: Icons.security,
          route: '/security',
        ),
      ],
    ),
  ],
  body: Container(
    child: Text('Conteúdo da página'),
  ),
  footer: Text('© 2024 Meu App'), // Opcional
  sidebarBackgroundColor: Colors.blue, // Opcional
  appBarActions: [
    ThemeToggle(), // Botão para alternar tema claro/escuro
    LanguageSelector(), // Seletor de idioma
    UserProfile(), // Widget de perfil do usuário
  ],
)
```

### Botões

O `ModButton` oferece botões customizáveis com diferentes estilos, tamanhos e estados de loading.

```dart
// Botão básico
ModButton(
  title: 'Clique aqui',
  onPressed: () async {
    // Ação do botão
    await Future.delayed(Duration(seconds: 2));
  },
)

// Botão com tipo e tamanho
ModButton(
  title: 'Salvar',
  type: ModButtonType.success,
  size: ModButtonSize.lg,
  onPressed: () async {
    // Ação de salvar
  },
)

// Botão com ícones
ModButton(
  title: 'Download',
  leftIcon: Icons.download,
  type: ModButtonType.primary,
  onPressed: () async {
    // Ação de download
  },
)

// Botão com loading customizado
ModButton(
  title: 'Processar',
  loadingText: 'Processando...',
  loadingIcon: Icons.hourglass_empty,
  type: ModButtonType.warning,
  onPressed: () async {
    await processData();
  },
)

// Botão outline (sem preenchimento)
ModButton(
  title: 'Cancelar',
  type: ModButtonType.none,
  borderColor: ModButtonType.danger,
  borderType: ModBorderType.solid,
  onPressed: () async {
    Navigator.pop(context);
  },
)

// Botão desabilitado
ModButton(
  title: 'Indisponível',
  disabled: true,
  onPressed: null,
)

// Botão com cores customizadas
ModButton(
  title: 'Custom',
  type: ModButtonType.custom,
  backgroundColor: Colors.purple,
  textColor: Colors.white,
  onPressed: () async {
    // Ação
  },
)
```

### Caixas de Texto

O `ModTextBox` fornece campos de entrada de texto com validação e customização.

```dart
// Campo de texto básico
ModTextBox(
  label: 'Nome',
  hint: 'Digite seu nome',
  onChange: (value) {
    print('Nome: $value');
  },
)

// Campo com validação
ModTextBox(
  label: 'Email',
  hint: 'exemplo@email.com',
  keyboardType: TextInputType.emailAddress,
  validator: (value) {
    if (value == null || !value.contains('@')) {
      return 'Email inválido';
    }
    return null;
  },
  onChange: (value) {
    // Processar email
  },
)

// Campo de senha
ModTextBox(
  label: 'Senha',
  isPassword: true,
  size: ModTextBoxSize.md,
  onChange: (value) {
    // Processar senha
  },
)

// Campo com ícones
ModTextBox(
  label: 'Pesquisar',
  prefixIcon: Icon(Icons.search),
  suffixButton: IconButton(
    icon: Icon(Icons.clear),
    onPressed: () {
      // Limpar campo
    },
  ),
  onChange: (value) {
    // Executar pesquisa
  },
)

// Campo multilinha
ModTextBox(
  label: 'Descrição',
  hint: 'Digite uma descrição detalhada',
  multiline: true,
  minLines: 3,
  maxLines: 10,
  onChange: (value) {
    // Processar descrição
  },
)

// Campo somente leitura
ModTextBox(
  label: 'ID',
  value: '12345',
  readOnly: true,
)

// Campo com formatação
ModTextBox(
  label: 'Telefone',
  hint: '(00) 00000-0000',
  inputFormatters: [
    FilteringTextInputFormatter.digitsOnly,
    TelefoneInputFormatter(), // Seu formatter customizado
  ],
  onChange: (value) {
    // Processar telefone
  },
)

// Campo com label flutuante
ModTextBox(
  label: 'Endereço',
  floatingLabel: true,
  labelPosition: ModTextBoxLabelPosition.top,
  onChange: (value) {
    // Processar endereço
  },
)
```

### Dropdown

O `Dropdown` básico para seleção de opções.

```dart
// Dropdown simples
Dropdown<String>(
  value: selectedValue,
  items: [
    DropdownMenuItem(value: 'op1', child: Text('Opção 1')),
    DropdownMenuItem(value: 'op2', child: Text('Opção 2')),
    DropdownMenuItem(value: 'op3', child: Text('Opção 3')),
  ],
  onChanged: (value) {
    setState(() {
      selectedValue = value;
    });
  },
)
```

### Dropdown com Pesquisa

O `ModDropdownSearch` oferece um dropdown avançado com pesquisa e múltipla seleção.

```dart
// Dropdown com pesquisa básico
ModDropdownSearch<String>(
  label: 'País',
  hint: 'Selecione um país',
  searchHint: 'Pesquisar país...',
  items: [
    ModDropdownSearchMenuItem(
      value: 'BR',
      child: Text('Brasil'),
      icon: Icons.flag,
    ),
    ModDropdownSearchMenuItem(
      value: 'US',
      child: Text('Estados Unidos'),
      icon: Icons.flag,
    ),
    ModDropdownSearchMenuItem(
      value: 'JP',
      child: Text('Japão'),
      icon: Icons.flag,
    ),
  ],
  onChanged: (value) {
    print('País selecionado: $value');
  },
)

// Dropdown com múltipla seleção
ModDropdownSearch<String>(
  label: 'Habilidades',
  multiSelect: true,
  searchEnabled: true,
  items: [
    ModDropdownSearchMenuItem(
      value: 'flutter',
      child: Text('Flutter'),
    ),
    ModDropdownSearchMenuItem(
      value: 'dart',
      child: Text('Dart'),
    ),
    ModDropdownSearchMenuItem(
      value: 'firebase',
      child: Text('Firebase'),
    ),
  ],
  onChanged: (value) {
    print('Habilidades selecionadas: $value');
  },
)

// Dropdown customizado
ModDropdownSearch<User>(
  label: 'Usuário',
  size: ModDropdownSearchSize.lg,
  dropdownHeight: 300,
  displayStringForOption: (user) => user?.name ?? '',
  items: users.map((user) => 
    ModDropdownSearchMenuItem(
      value: user,
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(user.avatar),
        ),
        title: Text(user.name),
        subtitle: Text(user.email),
      ),
    ),
  ).toList(),
  onChanged: (user) {
    print('Usuário selecionado: ${user?.name}');
  },
)
```

### Tabela de Dados

O `ModDataTable` oferece tabelas com ordenação, paginação e personalização.

```dart
// Tabela básica
ModDataTable<Map<String, dynamic>>(
  headers: [
    ModDataHeader(
      child: Text('ID'),
      field: 'id',
      width: 100,
      sortable: true,
    ),
    ModDataHeader(
      child: Text('Nome'),
      field: 'name',
      width: 200,
      sortable: true,
    ),
    ModDataHeader(
      child: Text('Email'),
      field: 'email',
      width: 250,
    ),
    ModDataHeader(
      child: Text('Ações'),
      field: 'actions',
      width: 150,
    ),
  ],
  data: userData,
  source: UserDataSource(userData),
  rowsPerPage: 10,
  totalRecords: userData.length,
  currentPage: 1,
  onPageChanged: (page) {
    // Carregar nova página
  },
  onSort: (field, direction) {
    // Ordenar dados
  },
)

// Tabela com cores alternadas e bordas
ModDataTable<Product>(
  headers: headers,
  data: products,
  source: ProductDataSource(products),
  borderStyle: BorderStyle.topLeftRightBottom,
  oddRowColor: Colors.grey[100],
  evenRowColor: Colors.white,
  headerColor: Colors.blue[50],
  rowsPerPage: 20,
  totalRecords: products.length,
  currentPage: currentPage,
  availableRowsPerPage: [10, 20, 50, 100],
  onPageChanged: (page) {
    setState(() {
      currentPage = page;
    });
  },
  onRowsPerPageChanged: (rowsPerPage) {
    setState(() {
      this.rowsPerPage = rowsPerPage;
    });
  },
)

// Tabela com redimensionamento de colunas
ModDataTable<dynamic>(
  headers: headers,
  data: data,
  source: dataSource,
  enableColumnResize: true,
  fixedHeader: true,
  showHorizontalScrollbar: true,
  onColumnWidthChanged: (field, newWidth) {
    // Salvar nova largura da coluna
  },
  rowsPerPage: 15,
  totalRecords: totalRecords,
  currentPage: currentPage,
  onPageChanged: (page) {
    loadPage(page);
  },
)
```

### Cards

O `ModCard` oferece cards com header, body e footer customizáveis.

```dart
// Card básico
ModCard(
  header: Text('Título do Card'),
  content: Container(
    padding: EdgeInsets.all(16),
    child: Text('Conteúdo do card'),
  ),
  footer: Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      TextButton(
        onPressed: () {},
        child: Text('Cancelar'),
      ),
      ElevatedButton(
        onPressed: () {},
        child: Text('Confirmar'),
      ),
    ],
  ),
)

// Card accordion (expansível)
ModCard(
  header: Row(
    children: [
      Icon(Icons.info),
      SizedBox(width: 8),
      Text('Informações'),
    ],
  ),
  content: Column(
    children: [
      ListTile(title: Text('Item 1')),
      ListTile(title: Text('Item 2')),
      ListTile(title: Text('Item 3')),
    ],
  ),
  isAccordion: true,
  initiallyExpanded: false,
)

// Card customizado
ModCard(
  header: Container(
    color: Colors.blue,
    padding: EdgeInsets.all(16),
    child: Text(
      'Card Customizado',
      style: TextStyle(color: Colors.white),
    ),
  ),
  content: Container(
    height: 200,
    child: Center(
      child: Text('Conteúdo personalizado'),
    ),
  ),
  backgroundColor: Colors.blue[50],
  borderRadius: BorderRadius.circular(16),
  elevation: 8,
)
```

### Modal

O `ModModal` cria diálogos modais responsivos e customizáveis.

```dart
// Modal básico
showDialog(
  context: context,
  builder: (context) => ModModal(
    header: Text('Título do Modal'),
    body: Container(
      padding: EdgeInsets.all(16),
      child: Text('Conteúdo do modal'),
    ),
    footer: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Fechar'),
        ),
        ElevatedButton(
          onPressed: () {
            // Ação
            Navigator.pop(context);
          },
          child: Text('Confirmar'),
        ),
      ],
    ),
  ),
);

// Modal com tamanhos e posições
showDialog(
  context: context,
  builder: (context) => ModModal(
    header: Row(
      children: [
        Icon(Icons.warning, color: Colors.orange),
        SizedBox(width: 8),
        Text('Atenção'),
      ],
    ),
    body: Container(
      padding: EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.warning_amber, size: 64, color: Colors.orange),
          SizedBox(height: 16),
          Text('Tem certeza que deseja continuar?'),
        ],
      ),
    ),
    footer: Container(
      padding: EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ModButton(
            title: 'Cancelar',
            type: ModButtonType.secondary,
            onPressed: () async => Navigator.pop(context),
          ),
          ModButton(
            title: 'Confirmar',
            type: ModButtonType.danger,
            onPressed: () async {
              // Ação perigosa
              Navigator.pop(context);
            },
          ),
        ],
      ),
    ),
    size: ModModalSize.sm,
    position: ModModalPosition.center,
    height: ModModalHeight.auto,
  ),
);

// Modal fullscreen
showDialog(
  context: context,
  builder: (context) => ModModal(
    header: AppBar(
      title: Text('Editor Fullscreen'),
      automaticallyImplyLeading: false,
      actions: [
        IconButton(
          icon: Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    ),
    body: Container(
      child: TextField(
        maxLines: null,
        decoration: InputDecoration(
          hintText: 'Digite seu texto aqui...',
          border: InputBorder.none,
        ),
      ),
    ),
    footer: Container(
      padding: EdgeInsets.all(16),
      child: ModButton(
        title: 'Salvar',
        type: ModButtonType.success,
        onPressed: () async {
          // Salvar conteúdo
          Navigator.pop(context);
        },
      ),
    ),
    fullScreen: true,
  ),
);
```

### Toast

O `ModToast` exibe notificações temporárias não intrusivas.

```dart
// Toast de sucesso
ToastManager.show(
  context: context,
  toast: ModToast(
    type: ToastType.success,
    title: 'Sucesso!',
    message: 'Operação realizada com sucesso.',
    icon: Icons.check_circle,
    position: ToastPosition.topRight,
    duration: Duration(seconds: 3),
  ),
);

// Toast de erro
ToastManager.show(
  context: context,
  toast: ModToast(
    type: ToastType.error,
    title: 'Erro',
    message: 'Ocorreu um erro ao processar a solicitação.',
    icon: Icons.error,
    position: ToastPosition.topCenter,
    showCloseButton: true,
  ),
);

// Toast de aviso
ToastManager.show(
  context: context,
  toast: ModToast(
    type: ToastType.warning,
    title: 'Atenção',
    message: 'Esta ação não pode ser desfeita.',
    position: ToastPosition.bottomRight,
  ),
);

// Toast informativo
ToastManager.show(
  context: context,
  toast: ModToast(
    type: ToastType.info,
    message: 'Nova mensagem recebida',
    position: ToastPosition.bottomCenter,
    duration: Duration(seconds: 5),
  ),
);

// Toast customizado
ToastManager.show(
  context: context,
  toast: ModToast(
    type: ToastType.custom,
    title: 'Download',
    message: 'Arquivo baixado com sucesso',
    icon: Icons.download_done,
    backgroundColor: Colors.purple,
    textColor: Colors.white,
    iconColor: Colors.white,
    position: ToastPosition.topLeft,
    borderRadius: 16,
    maxWidth: 400,
    shadow: BoxShadow(
      color: Colors.purple.withOpacity(0.3),
      blurRadius: 10,
      offset: Offset(0, 5),
    ),
  ),
);
```

### Tabs

O componente `Tabs` permite criar navegação em abas.

```dart
// Tabs básicas
DefaultTabController(
  length: 3,
  child: Column(
    children: [
      TabBar(
        tabs: [
          Tab(text: 'Aba 1', icon: Icon(Icons.home)),
          Tab(text: 'Aba 2', icon: Icon(Icons.star)),
          Tab(text: 'Aba 3', icon: Icon(Icons.settings)),
        ],
      ),
      Expanded(
        child: TabBarView(
          children: [
            Center(child: Text('Conteúdo da Aba 1')),
            Center(child: Text('Conteúdo da Aba 2')),
            Center(child: Text('Conteúdo da Aba 3')),
          ],
        ),
      ),
    ],
  ),
)
```

### Grid System

Sistema de grid responsivo inspirado no Bootstrap.

```dart
// Grid responsivo básico
ModContainer(
  child: ModRow(
    columns: [
      ModColumn(
        columnSizes: {
          ScreenSize.xs: ColumnSize.col12, // 100% em telas pequenas
          ScreenSize.sm: ColumnSize.col6,  // 50% em telas pequenas
          ScreenSize.md: ColumnSize.col4,  // 33% em telas médias
          ScreenSize.lg: ColumnSize.col3,  // 25% em telas grandes
        },
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Text('Coluna 1'),
          ),
        ),
      ),
      ModColumn(
        columnSizes: {
          ScreenSize.xs: ColumnSize.col12,
          ScreenSize.sm: ColumnSize.col6,
          ScreenSize.md: ColumnSize.col4,
          ScreenSize.lg: ColumnSize.col3,
        },
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Text('Coluna 2'),
          ),
        ),
      ),
      ModColumn(
        columnSizes: {
          ScreenSize.xs: ColumnSize.col12,
          ScreenSize.sm: ColumnSize.col12,
          ScreenSize.md: ColumnSize.col4,
          ScreenSize.lg: ColumnSize.col6,
        },
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Text('Coluna 3'),
          ),
        ),
      ),
    ],
  ),
)

// Grid com offset e ordem
ModContainer(
  fluid: true, // Container fluido (largura total)
  child: ModRow(
    columns: [
      ModColumn(
        columnSizes: {
          ScreenSize.xs: ColumnSize.col12,
          ScreenSize.md: ColumnSize.col6,
        },
        offset: {
          ScreenSize.md: 3, // Offset de 3 colunas em telas médias
        },
        order: {
          ScreenSize.xs: 2, // Ordem 2 em telas pequenas
          ScreenSize.md: 1, // Ordem 1 em telas médias
        },
        child: Container(
          height: 100,
          color: Colors.blue,
          child: Center(child: Text('Coluna com Offset')),
        ),
      ),
    ],
  ),
)
```

### Charts

Componente para gráficos de barras com interatividade.

```dart
// Gráfico de barras básico
ModBarChart(
  data: [
    ChartData(label: 'Jan', value: 100),
    ChartData(label: 'Fev', value: 150),
    ChartData(label: 'Mar', value: 120),
    ChartData(label: 'Abr', value: 200),
    ChartData(label: 'Mai', value: 180),
  ],
  height: 300,
  barColor: Colors.blue,
)

// Gráfico com ações customizadas
ModBarChart(
  data: chartData,
  height: 400,
  barColor: Colors.green,
  backgroundColor: Colors.grey[100],
  showGrid: true,
  showLabels: true,
  animationDuration: Duration(milliseconds: 800),
  onBarTap: (data) {
    print('Barra clicada: ${data.label} - ${data.value}');
  },
  actionButtons: [
    ChartActionButton(
      icon: Icons.download,
      onPressed: () {
        // Exportar gráfico
      },
    ),
    ChartActionButton(
      icon: Icons.refresh,
      onPressed: () {
        // Atualizar dados
      },
    ),
  ],
)
```

### TreeView

Componente para exibir dados hierárquicos em árvore.

```dart
// TreeView básico
ModTreeView(
  nodes: [
    TreeNode(
      title: 'Documentos',
      icon: Icons.folder,
      children: [
        TreeNode(
          title: 'Trabalho',
          icon: Icons.folder,
          children: [
            TreeNode(
              title: 'Projeto.pdf',
              icon: Icons.picture_as_pdf,
            ),
            TreeNode(
              title: 'Relatório.docx',
              icon: Icons.description,
            ),
          ],
        ),
        TreeNode(
          title: 'Pessoal',
          icon: Icons.folder,
          children: [
            TreeNode(
              title: 'Fotos',
              icon: Icons.photo_library,
            ),
          ],
        ),
      ],
    ),
    TreeNode(
      title: 'Downloads',
      icon: Icons.download,
      children: [],
    ),
  ],
  onNodeTap: (node) {
    print('Nó selecionado: ${node.title}');
  },
  onNodeExpanded: (node, isExpanded) {
    print('Nó ${node.title} ${isExpanded ? "expandido" : "colapsado"}');
  },
)
```

### Avatars

Componente para exibir avatares de usuários.

```dart
// Avatar básico
Avatar(
  imageUrl: 'https://example.com/user.jpg',
  size: 60,
)

// Avatar com iniciais
Avatar(
  name: 'João Silva',
  size: 40,
  backgroundColor: Colors.blue,
  textColor: Colors.white,
)

// Avatar com status online
Avatar(
  imageUrl: userImageUrl,
  size: 50,
  showStatusIndicator: true,
  isOnline: true,
  statusIndicatorColor: Colors.green,
)

// Avatar com borda
Avatar(
  imageUrl: userImageUrl,
  size: 80,
  borderWidth: 3,
  borderColor: Colors.blue,
)
```

### Loading

Indicadores de carregamento customizáveis.

```dart
// Loading básico
Loading()

// Loading com mensagem
Loading(
  message: 'Carregando dados...',
)

// Loading customizado
Loading(
  size: 100,
  color: Colors.blue,
  strokeWidth: 4,
  message: 'Por favor, aguarde',
  messageStyle: TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
  ),
)

// Loading overlay
LoadingOverlay(
  isLoading: isProcessing,
  child: YourContent(),
  opacity: 0.8,
  progressIndicator: CircularProgressIndicator(
    valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
  ),
)
```

### Labels

Labels e badges para destacar informações.

```dart
// Label básico
Label(
  text: 'Novo',
  backgroundColor: Colors.green,
  textColor: Colors.white,
)

// Label com ícone
Label(
  text: 'Premium',
  icon: Icons.star,
  backgroundColor: Colors.amber,
  textColor: Colors.black,
)

// Badge numérico
Badge(
  value: 5,
  backgroundColor: Colors.red,
  textColor: Colors.white,
  child: Icon(Icons.notifications),
)

// Label outline
Label(
  text: 'Em Progresso',
  backgroundColor: Colors.transparent,
  borderColor: Colors.orange,
  borderWidth: 2,
  textColor: Colors.orange,
)
```

### Dialogs

Diálogos de confirmação e alerta.

```dart
// Dialog de confirmação
showDialog(
  context: context,
  builder: (context) => ConfirmDialog(
    title: 'Confirmar Exclusão',
    message: 'Tem certeza que deseja excluir este item?',
    confirmText: 'Excluir',
    cancelText: 'Cancelar',
    onConfirm: () {
      // Executar exclusão
    },
  ),
);

// Dialog de alerta
showDialog(
  context: context,
  builder: (context) => AlertDialog(
    title: Text('Aviso'),
    content: Text('Esta ação requer permissões administrativas.'),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: Text('OK'),
      ),
    ],
  ),
);

// Dialog de input
showDialog(
  context: context,
  builder: (context) => InputDialog(
    title: 'Renomear Arquivo',
    label: 'Novo nome:',
    initialValue: 'documento.pdf',
    onConfirm: (value) {
      // Renomear arquivo
    },
  ),
);
```

### Text Utilities

Utilitários para trabalhar com texto.

```dart
// Texto com cópia
TextCopy(
  text: 'Texto que pode ser copiado',
  showCopyButton: true,
  onCopy: () {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Copiado!')),
    );
  },
)

// Divisor de texto
TextDivider(
  text: 'OU',
  lineColor: Colors.grey,
  textStyle: TextStyle(
    color: Colors.grey[600],
    fontWeight: FontWeight.bold,
  ),
)

// Texto com highlight
HighlightText(
  text: 'Este é um texto com palavra destacada',
  highlight: 'destacada',
  highlightColor: Colors.yellow,
)

// Texto truncado com tooltip
TruncatedText(
  text: 'Este é um texto muito longo que será truncado',
  maxLength: 20,
  showTooltip: true,
)
```

## Controllers

### ThemeController

Gerencia temas claro/escuro com persistência.

```dart
// Obter o controller
final themeController = Get.find<ThemeController>();

// Alternar tema
themeController.toggleTheme();

// Definir tema específico
themeController.setTheme(ThemeMode.dark);

// Verificar tema atual
bool isDarkMode = themeController.isDarkMode;

// Ouvir mudanças de tema
ever(themeController.theme, (theme) {
  print('Tema alterado para: $theme');
});
```

### LanguageController

Gerencia idiomas e internacionalização.

```dart
// Obter o controller
final languageController = Get.find<LanguageController>();

// Alterar idioma
languageController.changeLanguage('pt_BR');

// Obter idioma atual
String currentLanguage = languageController.currentLanguage;

// Idiomas disponíveis
List<String> languages = languageController.availableLanguages;

// Traduzir texto
String translated = 'home'.tr;
```

### LayoutController

Controla o estado do layout (sidebar, responsividade).

```dart
// Obter o controller
final layoutController = Get.find<LayoutController>();

// Alternar sidebar
layoutController.toggleSidebar();

// Verificar se é mobile
bool isMobile = layoutController.isMobile;

// Definir item de menu selecionado
layoutController.setSelectedMenuItem('/dashboard');

// Ouvir mudanças no layout
ever(layoutController.sidebarOpen, (isOpen) {
  print('Sidebar ${isOpen ? "aberta" : "fechada"}');
});
```

## Temas

### Configuração de Tema Customizado

```dart
class MyAppTheme {
  static final light = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: Colors.grey[50],
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 1,
    ),
    cardTheme: CardTheme(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  );

  static final dark = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: Colors.grey[900],
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.grey[850],
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    cardTheme: CardTheme(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  );
}
```

## Internacionalização

### Adicionar Traduções Customizadas

```dart
class AppTranslations extends BaseTranslations {
  @override
  Map<String, Map<String, String>> get keys {
    final baseKeys = super.keys;
    
    final customKeys = {
      'en_US': {
        'welcome_message': 'Welcome to our app!',
        'logout_confirm': 'Are you sure you want to logout?',
      },
      'pt_BR': {
        'welcome_message': 'Bem-vindo ao nosso app!',
        'logout_confirm': 'Tem certeza que deseja sair?',
      },
      'es_ES': {
        'welcome_message': '¡Bienvenido a nuestra aplicación!',
        'logout_confirm': '¿Estás seguro de que quieres cerrar sesión?',
      },
    };
    
    // Mesclar traduções
    for (final locale in baseKeys.keys) {
      baseKeys[locale]!.addAll(customKeys[locale] ?? {});
    }
    
    return baseKeys;
  }
}
```

### Usar Traduções

```dart
// No código
Text('welcome_message'.tr)

// Com parâmetros
Text('hello_user'.trParams({'name': userName}))

// Plural
Text('items_count'.trPlural('items_count', itemCount))
```

## Breakpoints do Sistema de Grid

- **xs**: < 576px (Mobile portrait)
- **sm**: ≥ 576px (Mobile landscape)
- **md**: ≥ 768px (Tablet)
- **lg**: ≥ 992px (Desktop)
- **xl**: ≥ 1200px (Large desktop)

## Exemplo Completo

Para um exemplo completo de implementação, consulte o [projeto de exemplo](example/) que demonstra o uso de todos os componentes em uma aplicação real.

## Requisitos

- Flutter 3.0.0 ou superior
- Dart 2.17.0 ou superior

## Dependências

- get: ^4.6.5 (Gerenciamento de estado)
- shared_preferences: ^2.0.0 (Persistência)
- fl_chart: ^0.40.0 (Gráficos)

## Contribuindo

Contribuições são bem-vindas! Por favor, sinta-se à vontade para enviar um Pull Request.

## Licença

```
MIT License
```

## Suporte

Para reportar bugs ou solicitar features, abra uma issue no [GitHub](https://github.com/yourusername/mod_layout_one/issues).