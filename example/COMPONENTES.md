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
13. [Widgets Adicionais](#widgets-adicionais-referência-de-propriedades)
    - [ModIconButton](#modiconbutton)
    - [ModPopupButton](#modpopupbutton)
    - [ModDropdownSearch](#moddropdownsearch)
    - [ModProgress](#modprogress)
    - [ModWheelSlider](#modwheelslider)
    - [ModWheelDatePicker](#modwheeldatepicker)

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

### Propriedades do ModButton

| Propriedade | Tipo | Descrição |
|-------------|------|-----------|
| `title` | `String?` | Texto exibido no botão |
| `leftIcon` | `IconData?` | Ícone exibido à esquerda do texto |
| `rightIcon` | `IconData?` | Ícone exibido à direita do texto |
| `centerIcon` | `IconData?` | Ícone centralizado (layout vertical com texto) |
| `loadingIcon` | `IconData?` | Ícone exibido durante loading (padrão: Icons.refresh) |
| `borderRadius` | `double` | Raio das bordas do botão (padrão: 4.0) |
| `type` | `ModButtonType` | Estilo visual (primary, secondary, success, info, warning, danger, dark, defaultType, custom, none) |
| `borderType` | `ModBorderType` | Tipo de borda (none, solid) |
| `size` | `ModButtonSize` | Tamanho do botão (lg, md, sm, xs) |
| `onPressed` | `Future<void> Function()?` | Callback assíncrono ao pressionar |
| `loadingText` | `String?` | Texto exibido durante loading |
| `borderColor` | `ModButtonType` | Cor da borda usando tipos predefinidos |
| `textColor` | `Color?` | Cor customizada para o texto |
| `backgroundColor` | `Color?` | Cor de fundo (usado com type: custom) |
| `disabled` | `bool` | Desabilita interação (padrão: false) |
| `autosize` | `bool` | Ajusta largura ao conteúdo (padrão: true) |
| `textAlign` | `TextAlign` | Alinhamento do texto (padrão: center) |
| `iconCenterAlign` | `ModIconCenterAlign` | Posição do centerIcon (top, bottom) |
| `fontSize` | `double?` | Tamanho customizado da fonte |

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

### Propriedades do ModCard

| Propriedade | Tipo | Descrição |
|-------------|------|-----------|
| `header` | `Widget` | Widget exibido no cabeçalho do card (obrigatório) |
| `toolbar` | `List<Widget>?` | Lista de widgets exibidos na barra de ferramentas do header |
| `content` | `Widget` | Conteúdo principal do card (obrigatório) |
| `footer` | `Widget?` | Widget exibido no rodapé do card |
| `headerColor` | `Color` | Cor de fundo do header (padrão: transparent) |
| `contentColor` | `Color` | Cor de fundo do conteúdo (padrão: transparent) |
| `footerColor` | `Color` | Cor de fundo do footer (padrão: transparent) |
| `isAccordion` | `bool` | Habilita comportamento accordion (padrão: false) |
| `showFooterWhenCollapsed` | `bool` | Mostra footer quando accordion está recolhido (padrão: false) |
| `margin` | `EdgeInsets` | Margem externa do card (padrão: 8.0 em todos os lados) |
| `padding` | `EdgeInsets` | Padding interno das seções (padrão: 16.0 em todos os lados) |
| `borderRadius` | `double` | Raio das bordas do card (padrão: 8.0) |
| `initiallyExpanded` | `bool` | Estado inicial do accordion (padrão: false) |
| `disableModCard` | `bool` | Remove header e mostra apenas content/footer (padrão: false) |

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

### Propriedades do ModTextCopy

| Propriedade | Tipo | Descrição |
|-------------|------|-----------|
| `child` | `Widget` | Widget filho que será exibido e clicável (obrigatório) |
| `textToCopy` | `String` | Texto que será copiado para a área de transferência (obrigatório) |

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

### Propriedades do ModAvatar

| Propriedade | Tipo | Descrição |
|-------------|------|-----------|
| `text` | `String?` | Texto para gerar iniciais do avatar |
| `icon` | `IconData?` | Ícone a ser exibido no avatar |
| `imageUrl` | `String?` | URL da imagem do avatar (usa CachedNetworkImage) |
| `shape` | `ModAvatarShape` | Forma do avatar (square, circle, triangle) |
| `size` | `ModAvatarSize?` | Tamanho predefinido (lg: 56, md: 40, sm: 32, xs: 24) |
| `customSize` | `double?` | Tamanho customizado em pixels |
| `backgroundColor` | `Color` | Cor de fundo do avatar (padrão: Colors.blue) |
| `textColor` | `Color` | Cor do texto/ícone (padrão: Colors.white) |

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

### Propriedades do ModLoadingConfig

| Propriedade | Tipo | Descrição |
|-------------|------|-----------|
| `imagePath` | `String?` | Caminho para imagem customizada (suporta SVG e PNG/JPG) |
| `icon` | `IconData?` | Ícone a ser exibido (padrão: Icons.loop) |
| `animate` | `bool` | Habilita animação de rotação (padrão: true) |
| `size` | `double` | Tamanho do ícone/imagem (padrão: 32) |
| `position` | `ModLoadingPosition` | Posição na tela (center, left, right, topLeft, topCenter, topRight, bottomLeft, bottomCenter, bottomRight) |
| `backgroundColor` | `Color?` | Cor de fundo do container |
| `borderRadius` | `double` | Raio das bordas (padrão: 8) |
| `padding` | `EdgeInsets?` | Padding interno do container |
| `barrierDismissible` | `bool` | Permite fechar ao clicar fora (padrão: false) |
| `title` | `String?` | Texto exibido junto ao indicador |
| `orientation` | `ModLoadingOrientation` | Orientação do layout (vertical, horizontal) |
| `spacing` | `double` | Espaçamento entre ícone e título (padrão: 20) |

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

### Propriedades do ModTabs

| Propriedade | Tipo | Descrição |
|-------------|------|-----------|
| `tabs` | `List<ModTab>` | Lista de abas a serem exibidas (obrigatório) |
| `children` | `List<Widget>` | Lista de conteúdos correspondentes a cada aba (obrigatório) |
| `orientation` | `TabOrientation` | Orientação das abas (horizontalTop, horizontalBottom, verticalLeft, verticalRight) |
| `borderType` | `TabBorderType` | Tipo de borda (none, all, topBottom, leftRight) |
| `initialIndex` | `int` | Índice da aba inicial (padrão: 0) |
| `onTabChanged` | `Function(int)?` | Callback quando aba é alterada |
| `onTabClosed` | `Function(String)?` | Callback quando aba é fechada |
| `tabHeight` | `double?` | Altura customizada das abas |
| `tabWidth` | `double?` | Largura customizada das abas |
| `backgroundColor` | `Color?` | Cor de fundo do container de abas |
| `selectedColor` | `Color?` | Cor da aba selecionada |
| `unselectedColor` | `Color?` | Cor das abas não selecionadas |

### Propriedades do ModTab

| Propriedade | Tipo | Descrição |
|-------------|------|-----------|
| `id` | `String` | Identificador único da aba (obrigatório) |
| `text` | `String` | Texto exibido na aba (obrigatório) |
| `icon` | `IconData?` | Ícone exibido na aba |
| `closeable` | `bool` | Permite fechar a aba (padrão: false) |

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

### Propriedades do ModModal

| Propriedade | Tipo | Descrição |
|-------------|------|-----------|
| `header` | `Widget?` | Widget exibido no cabeçalho do modal |
| `body` | `Widget` | Conteúdo principal do modal (obrigatório) |
| `footer` | `Widget?` | Widget exibido no rodapé do modal |
| `height` | `ModModalHeight` | Altura do modal (auto, normal, half, full) |
| `maxHeight` | `double?` | Altura máxima em pixels |
| `maxWidth` | `double?` | Largura máxima em pixels |
| `minHeight` | `double?` | Altura mínima em pixels |
| `minWidth` | `double?` | Largura mínima em pixels |
| `backgroundColor` | `Color?` | Cor de fundo do modal |
| `borderRadius` | `double` | Raio das bordas (padrão: 8.0) |
| `barrierDismissible` | `bool` | Permite fechar ao clicar fora (padrão: true) |
| `showCloseButton` | `bool` | Exibe botão de fechar (padrão: true) |
| `padding` | `EdgeInsets?` | Padding interno do modal |

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

### Propriedades do ModTextBox

| Propriedade | Tipo | Descrição |
|-------------|------|-----------|
| `label` | `String?` | Rótulo do campo de texto |
| `hint` | `String?` | Texto de placeholder |
| `controller` | `TextEditingController?` | Controller para manipular o texto |
| `initialValue` | `String?` | Valor inicial do campo |
| `onChange` | `Function(String)?` | Callback quando texto é alterado |
| `onEditingComplete` | `Function()?` | Callback quando edição é finalizada |
| `isPassword` | `bool` | Oculta o texto como senha (padrão: false) |
| `keyboardType` | `TextInputType?` | Tipo de teclado virtual |
| `inputFormatters` | `List<TextInputFormatter>?` | Formatadores de entrada |
| `validator` | `String? Function(String?)?` | Função de validação |
| `size` | `ModTextBoxSize` | Tamanho do campo (lg, md, sm, xs) |
| `enabled` | `bool` | Habilita/desabilita o campo (padrão: true) |
| `readOnly` | `bool` | Modo somente leitura (padrão: false) |
| `maxLines` | `int?` | Número máximo de linhas |
| `minLines` | `int?` | Número mínimo de linhas |
| `floatingLabel` | `bool` | Label flutuante (padrão: false) |
| `prefixIcon` | `Widget?` | Ícone no início do campo |
| `suffixIcon` | `Widget?` | Ícone no final do campo |
| `borderRadius` | `double` | Raio das bordas (padrão: 8.0) |
| `hasBorder` | `bool` | Exibe borda (padrão: false) |
| `backgroundColor` | `Color?` | Cor de fundo |
| `textColor` | `Color?` | Cor do texto |

### Propriedades do ModDropDown

| Propriedade | Tipo | Descrição |
|-------------|------|-----------|
| `items` | `List<DropdownMenuItem<T>>` | Lista de itens do dropdown (obrigatório) |
| `value` | `T?` | Valor selecionado atualmente |
| `label` | `String?` | Rótulo do dropdown |
| `hint` | `String?` | Texto de placeholder |
| `onChanged` | `Function(T?)?` | Callback quando valor é alterado |
| `validator` | `String? Function(T?)?` | Função de validação |
| `size` | `ModDropdownSize` | Tamanho do dropdown (lg, md, sm, xs) |
| `enabled` | `bool` | Habilita/desabilita (padrão: true) |
| `floatingLabel` | `bool` | Label flutuante (padrão: false) |
| `prefixIcon` | `Widget?` | Ícone no início |
| `suffixIcon` | `Widget?` | Ícone customizado no final |
| `borderRadius` | `double` | Raio das bordas (padrão: 8.0) |
| `hasBorder` | `bool` | Exibe borda (padrão: false) |
| `backgroundColor` | `Color?` | Cor de fundo |
| `dropdownBackgroundColor` | `Color?` | Cor de fundo do menu dropdown |

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

### Propriedades do ModDialog

| Propriedade | Tipo | Descrição |
|-------------|------|-----------|
| `title` | `String?` | Título do diálogo |
| `content` | `Widget?` | Conteúdo principal do diálogo |
| `buttons` | `List<Widget>` | Lista de botões de ação (obrigatório) |
| `icon` | `IconData?` | Ícone exibido no cabeçalho |
| `iconColor` | `Color?` | Cor do ícone |
| `maxWidth` | `double?` | Largura máxima do diálogo |
| `minWidth` | `double?` | Largura mínima do diálogo |
| `maxHeight` | `double?` | Altura máxima do diálogo |
| `minHeight` | `double?` | Altura mínima do diálogo |
| `dismissible` | `bool` | Permite fechar ao clicar fora (padrão: true) |
| `backgroundColor` | `Color?` | Cor de fundo do diálogo |
| `borderRadius` | `double` | Raio das bordas (padrão: 8.0) |
| `padding` | `EdgeInsets?` | Padding interno |
| `titleStyle` | `TextStyle?` | Estilo do texto do título |

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

### Propriedades do ModDataTable

| Propriedade | Tipo | Descrição |
|-------------|------|-----------|
| `headers` | `List<ModDataHeader>` | Lista de cabeçalhos das colunas (obrigatório) |
| `data` | `List<Map<String, dynamic>>` | Dados da tabela (obrigatório) |
| `source` | `DataTableSource` | Fonte de dados para a tabela (obrigatório) |
| `currentPage` | `int` | Página atual (padrão: 0) |
| `rowsPerPage` | `int` | Linhas por página (padrão: 10) |
| `totalRecords` | `int` | Total de registros |
| `onPageChanged` | `Function(int)?` | Callback quando página muda |
| `onRowsPerPageChanged` | `Function(int)?` | Callback quando linhas por página muda |
| `onSort` | `Function(String, SortDirection)?` | Callback de ordenação |
| `fixedHeader` | `bool` | Mantém header fixo ao rolar (padrão: false) |
| `enableColumnResize` | `bool` | Permite redimensionar colunas (padrão: false) |
| `availableRowsPerPage` | `List<int>` | Opções de linhas por página |
| `rowsPerPageText` | `String?` | Texto customizado para "Linhas por página" |
| `paginationText` | `String?` | Texto customizado para paginação |
| `paginationBorderRadius` | `double?` | Raio das bordas da paginação |
| `headerColor` | `Color?` | Cor de fundo do header |
| `oddRowColor` | `Color?` | Cor das linhas ímpares |
| `evenRowColor` | `Color?` | Cor das linhas pares |
| `paginationBackgroundColor` | `Color?` | Cor de fundo da paginação |

### Propriedades do ModDataHeader

| Propriedade | Tipo | Descrição |
|-------------|------|-----------|
| `child` | `Widget` | Widget do cabeçalho (obrigatório) |
| `field` | `String?` | Nome do campo para ordenação |
| `sortable` | `bool` | Permite ordenação (padrão: false) |
| `widthType` | `WidthType` | Tipo de largura (fixed, flex, auto) |
| `width` | `double?` | Largura fixa em pixels |
| `minWidth` | `double?` | Largura mínima |
| `maxWidth` | `double?` | Largura máxima |

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

### Propriedades do ModTreeView

| Propriedade | Tipo | Descrição |
|-------------|------|-----------|
| `nodes` | `List<TreeNode>` | Lista de nós da árvore (obrigatório) |
| `theme` | `TreeViewTheme` | Configuração de tema (indentação, ícones, cores) |
| `enableDragDrop` | `bool` | Habilita arrastar e soltar (padrão: true) |
| `showIcons` | `bool` | Exibe ícones dos nós (padrão: true) |
| `showCheckboxes` | `bool` | Exibe checkboxes (padrão: false) |
| `newItemIcon` | `Icon?` | Ícone para itens novos |
| `updateIcon` | `Icon?` | Ícone para itens atualizados |
| `syncIcon` | `Icon?` | Ícone para itens em sincronização |
| `onNodeSelected` | `Function(TreeNode)?` | Callback ao selecionar nó |
| `onNodeExpanded` | `Function(TreeNode)?` | Callback ao expandir nó |
| `onNodeCollapsed` | `Function(TreeNode)?` | Callback ao recolher nó |
| `onNodeDropped` | `Function(TreeNode, TreeNode)?` | Callback ao soltar nó |
| `onNodeRightClick` | `Function(TreeNode)?` | Callback de clique direito |
| `onNodeCheckChanged` | `Function(TreeNode, bool)?` | Callback de checkbox |
| `sortComparator` | `int Function(TreeNode, TreeNode)?` | Comparador de ordenação |
| `getContextMenuItems` | `List<TreeViewMenuItem> Function(TreeNode)?` | Função para obter itens do menu de contexto |
| `onContextMenuItemSelected` | `Function(TreeNode, String)?` | Callback de seleção do menu de contexto |

### Propriedades do TreeNode

| Propriedade | Tipo | Descrição |
|-------------|------|-----------|
| `id` | `String` | Identificador único do nó (obrigatório) |
| `label` | `String` | Texto exibido no nó (obrigatório) |
| `iconData` | `IconData` | Ícone do nó (obrigatório) |
| `iconColor` | `Color?` | Cor do ícone |
| `isFolder` | `bool` | Indica se é uma pasta (padrão: false) |
| `isExpanded` | `bool` | Estado de expansão (padrão: false) |
| `isSelected` | `bool` | Estado de seleção (padrão: false) |
| `children` | `List<TreeNode>` | Lista de nós filhos (padrão: []) |
| `data` | `dynamic` | Dados adicionais do nó |
| `stateMode` | `NodeStateMode` | Estado do nó (synced, new_item, update, sync) |

### Propriedades do TreeViewTheme

| Propriedade | Tipo | Descrição |
|-------------|------|-----------|
| `indentation` | `double` | Indentação por nível (padrão: 20.0) |
| `iconSize` | `double` | Tamanho dos ícones (padrão: 16.0) |
| `selectionColor` | `Color` | Cor de seleção |
| `expanderType` | `ExpanderType` | Tipo de expansor (triangle, arrow, plusMinus) |
| `showLines` | `bool` | Exibe linhas de conexão (padrão: true) |
| `lineColor` | `Color?` | Cor das linhas |
| `textColor` | `Color?` | Cor do texto |
| `iconColor` | `Color?` | Cor dos ícones |

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

## Widgets Adicionais (Referência de Propriedades)

Os widgets a seguir estão disponíveis no pacote, mas ainda não possuem exemplos documentados. Esta seção contém a referência de suas propriedades.

### ModIconButton

Botão de ícone com suporte a loading assíncrono.

| Propriedade | Tipo | Descrição |
|-------------|------|-----------|
| `icon` | `IconData` | Ícone a ser exibido (obrigatório) |
| `onPressed` | `Future<void> Function()` | Callback assíncrono ao pressionar (obrigatório) |
| `loadingIcon` | `IconData` | Ícone durante loading (padrão: Icons.autorenew) |
| `iconSize` | `double?` | Tamanho do ícone |
| `visualDensity` | `VisualDensity?` | Densidade visual do botão |
| `padding` | `EdgeInsetsGeometry?` | Padding interno |
| `alignment` | `AlignmentGeometry?` | Alinhamento do ícone |
| `splashRadius` | `double?` | Raio do efeito splash |
| `color` | `Color?` | Cor do ícone |
| `focusColor` | `Color?` | Cor quando focado |
| `hoverColor` | `Color?` | Cor ao passar o mouse |
| `highlightColor` | `Color?` | Cor ao pressionar |
| `splashColor` | `Color?` | Cor do splash |
| `disabledColor` | `Color?` | Cor quando desabilitado |
| `mouseCursor` | `MouseCursor?` | Cursor do mouse |
| `focusNode` | `FocusNode?` | Nó de foco |
| `autofocus` | `bool` | Auto foco (padrão: false) |
| `tooltip` | `String?` | Texto do tooltip |
| `enableFeedback` | `bool?` | Habilita feedback tátil |
| `constraints` | `BoxConstraints?` | Restrições de tamanho |
| `style` | `ButtonStyle?` | Estilo do botão |
| `isSelected` | `bool?` | Estado selecionado |
| `selectedIcon` | `IconData?` | Ícone quando selecionado |

### ModPopupButton

Botão com menu popup e suporte a submenus.

| Propriedade | Tipo | Descrição |
|-------------|------|-----------|
| `title` | `String?` | Texto do botão |
| `leftIcon` | `IconData?` | Ícone à esquerda |
| `rightIcon` | `IconData?` | Ícone à direita |
| `popupIcon` | `IconData?` | Ícone do popup (padrão: Icons.arrow_drop_down) |
| `borderRadius` | `double` | Raio das bordas (padrão: 4.0) |
| `type` | `ModButtonType` | Estilo visual do botão |
| `borderType` | `ModBorderType` | Tipo de borda |
| `size` | `ModButtonSize` | Tamanho (lg, md, sm, xs) |
| `items` | `List<ModPopupMenuItem<T>>` | Itens do menu (obrigatório) |
| `onSelected` | `Function(T)?` | Callback ao selecionar item |
| `borderColor` | `ModButtonType` | Cor da borda |
| `textColor` | `Color?` | Cor do texto |
| `backgroundColor` | `Color?` | Cor de fundo |
| `disabled` | `bool` | Desabilitado (padrão: false) |
| `autosize` | `bool` | Auto dimensionar (padrão: true) |
| `textAlign` | `TextAlign` | Alinhamento do texto |
| `position` | `PopupMenuPosition` | Posição do menu (over, under) |
| `tooltip` | `String?` | Tooltip do botão |
| `popupBackgroundColor` | `Color?` | Cor de fundo do popup |
| `elevation` | `double?` | Elevação do popup |
| `shape` | `ShapeBorder?` | Forma do popup |
| `popupPadding` | `EdgeInsets?` | Padding do popup |
| `iconSize` | `double?` | Tamanho dos ícones |
| `menuFontSize` | `double?` | Tamanho da fonte do menu |
| `submenuFontSize` | `double?` | Tamanho da fonte do submenu |
| `submenuOffset` | `Offset?` | Offset do submenu |

### ModDropdownSearch

Dropdown com busca integrada e suporte a seleção múltipla.

| Propriedade | Tipo | Descrição |
|-------------|------|-----------|
| `items` | `List<ModDropdownSearchMenuItem<T>>` | Itens do dropdown (obrigatório) |
| `value` | `T?` | Valor selecionado |
| `size` | `ModDropdownSearchSize` | Tamanho (lg, md, sm, xs) |
| `labelPosition` | `ModDropdownSearchLabelPosition` | Posição do label (top, inside) |
| `label` | `String?` | Rótulo do campo |
| `hint` | `String?` | Texto de placeholder |
| `searchHint` | `String?` | Placeholder da busca |
| `borderRadius` | `double` | Raio das bordas (padrão: 8.0) |
| `multiSelect` | `bool` | Seleção múltipla (padrão: false) |
| `onChanged` | `Function(T?)?` | Callback de alteração |
| `validator` | `String? Function(T?)?` | Função de validação |
| `prefixIcon` | `Widget?` | Ícone no início |
| `suffixIcon` | `Widget?` | Ícone no final |
| `errorText` | `String?` | Texto de erro |
| `enabled` | `bool` | Habilitado (padrão: true) |
| `backgroundColor` | `Color?` | Cor de fundo |
| `textColor` | `Color?` | Cor do texto |
| `iconColor` | `Color?` | Cor dos ícones |
| `borderColor` | `Color?` | Cor da borda |
| `dropdownBackgroundColor` | `Color?` | Cor de fundo do dropdown |
| `searchBackgroundColor` | `Color?` | Cor de fundo da busca |
| `checkIcon` | `Widget?` | Ícone de check personalizado |
| `closeButtonText` | `String?` | Texto do botão fechar |
| `dropdownHeight` | `double?` | Altura do dropdown |
| `displayStringForOption` | `String Function(T)?` | Função para exibir opção |
| `hasBorder` | `bool` | Exibe borda (padrão: false) |
| `borderWidth` | `double` | Largura da borda (padrão: 1.0) |
| `fontSize` | `double?` | Tamanho da fonte |
| `iconSize` | `double?` | Tamanho dos ícones |
| `floatingLabel` | `bool` | Label flutuante (padrão: false) |
| `floatingLabelBackgroundColor` | `Color?` | Cor de fundo do label flutuante |
| `searchEnabled` | `bool` | Busca habilitada (padrão: true) |
| `selectedItemBuilder` | `Widget Function(T)?` | Builder do item selecionado |
| `backgroundHover` | `Color?` | Cor de hover dos itens |

### ModProgress

Widget de progresso com suporte a atualizações em tempo real via GetX.

| Propriedade | Tipo | Descrição |
|-------------|------|-----------|
| `controller` | `ModProgressController` | Controller GetX (obrigatório) |
| `config` | `ModProgressConfig` | Configuração de aparência |
| `onClose` | `VoidCallback?` | Callback ao fechar |

### ModProgressConfig

| Propriedade | Tipo | Descrição |
|-------------|------|-----------|
| `position` | `ModProgressPosition` | Posição na tela (topLeft, topCenter, topRight, bottomLeft, bottomCenter, bottomRight) |
| `type` | `ModProgressType` | Tipo de indicador (circular, linear) |
| `title` | `String?` | Título |
| `subtitle` | `String?` | Subtítulo/mensagem |
| `initialProgress` | `double?` | Progresso inicial (0.0 a 1.0) |
| `backgroundColor` | `Color?` | Cor de fundo |
| `borderColor` | `Color?` | Cor da borda |
| `borderWidth` | `double` | Largura da borda (padrão: 1.0) |
| `borderRadius` | `double` | Raio das bordas (padrão: 8.0) |
| `progressColor` | `Color?` | Cor do indicador |
| `progressBackgroundColor` | `Color?` | Cor de fundo do indicador |
| `titleColor` | `Color?` | Cor do título |
| `subtitleColor` | `Color?` | Cor do subtítulo |
| `titleFontSize` | `double` | Tamanho da fonte do título (padrão: 14.0) |
| `subtitleFontSize` | `double` | Tamanho da fonte do subtítulo (padrão: 12.0) |
| `width` | `double?` | Largura do container (padrão: 300.0) |
| `height` | `double?` | Altura do container |
| `circularSize` | `double` | Tamanho do indicador circular (padrão: 24.0) |
| `circularStrokeWidth` | `double` | Espessura do indicador circular (padrão: 3.0) |
| `linearHeight` | `double` | Altura do indicador linear (padrão: 4.0) |
| `padding` | `EdgeInsets` | Padding interno (padrão: 16.0) |
| `margin` | `EdgeInsets` | Margem externa (padrão: 16.0) |
| `showCloseButton` | `bool` | Exibe botão fechar (padrão: true) |
| `barrierDismissible` | `bool` | Permite fechar ao clicar fora (padrão: false) |
| `showBarrier` | `bool` | Exibe barreira de fundo (padrão: false) |
| `barrierColor` | `Color` | Cor da barreira (padrão: Colors.black26) |
| `boxShadow` | `List<BoxShadow>?` | Sombra do container |
| `icon` | `IconData?` | Ícone customizado |
| `iconColor` | `Color?` | Cor do ícone |
| `iconSize` | `double` | Tamanho do ícone (padrão: 20.0) |

### ModWheelSlider

Slider estilo roda com suporte a haptic feedback.

| Propriedade | Tipo | Descrição |
|-------------|------|-----------|
| `totalCount` | `int` | Total de valores (obrigatório) |
| `initValue` | `int` | Valor inicial (obrigatório) |
| `onValueChanged` | `Function(dynamic)` | Callback de alteração (obrigatório) |
| `horizontalListHeight` | `double?` | Altura da lista horizontal |
| `horizontalListWidth` | `double?` | Largura da lista horizontal |
| `verticalListHeight` | `double?` | Altura da lista vertical |
| `verticalListWidth` | `double?` | Largura da lista vertical |
| `itemSize` | `double` | Tamanho dos itens (padrão: 10) |
| `perspective` | `double?` | Perspectiva 3D |
| `isInfinite` | `bool` | Scroll infinito (padrão: false) |
| `horizontal` | `bool` | Orientação horizontal (padrão: true) |
| `squeeze` | `double?` | Compressão dos itens |
| `lineColor` | `Color` | Cor das linhas (padrão: Colors.black) |
| `pointerColor` | `Color` | Cor do ponteiro (padrão: Colors.black) |
| `pointerHeight` | `double` | Altura do ponteiro (padrão: 50) |
| `pointerWidth` | `double` | Largura do ponteiro (padrão: 3) |
| `background` | `Color` | Cor de fundo (padrão: Colors.white) |
| `enableHapticFeedback` | `bool` | Habilita feedback tátil (padrão: true) |
| `hapticFeedbackType` | `ModHapticFeedbackType` | Tipo de feedback (vibrate, lightImpact, mediumImpact, heavyImpact, selectionClick, none) |
| `showPointer` | `bool` | Exibe ponteiro (padrão: true) |
| `customPointer` | `Widget?` | Ponteiro customizado |
| `selectedNumberStyle` | `TextStyle?` | Estilo do número selecionado |
| `unSelectedNumberStyle` | `TextStyle?` | Estilo dos números não selecionados |
| `selectedNumberWidth` | `double?` | Largura do número selecionado |
| `children` | `List<Widget>?` | Widgets customizados |
| `scrollPhysics` | `ScrollPhysics?` | Física de scroll |
| `allowPointerTappable` | `bool` | Ponteiro clicável (padrão: true) |
| `interval` | `int` | Intervalo entre valores (padrão: 1) |
| `enableAnimation` | `bool` | Habilita animação (padrão: true) |
| `animationDuration` | `Duration?` | Duração da animação |
| `animationType` | `Curve?` | Curva de animação |
| `controller` | `FixedExtentScrollController?` | Controller de scroll |
| `sliderController` | `ModWheelSliderController?` | Controller GetX |
| `currentIndex` | `int?` | Índice atual |

### ModWheelDatePicker

Seletor de data estilo roda com suporte a diferentes formatos.

| Propriedade | Tipo | Descrição |
|-------------|------|-----------|
| `type` | `ModWheelDatePickerType` | Tipo de seleção (fullDate, dayMonthYear, monthYear, yearOnly) |
| `initialDate` | `DateTime?` | Data inicial |
| `controller` | `ModWheelDatePickerController?` | Controller GetX |
| `onDateChanged` | `Function(DateTime)?` | Callback de alteração |
| `minYear` | `int` | Ano mínimo (padrão: 1900) |
| `maxYear` | `int` | Ano máximo (padrão: 2100) |
| `height` | `double` | Altura do widget (padrão: 200) |
| `width` | `double?` | Largura do widget |
| `selectedStyle` | `TextStyle?` | Estilo do item selecionado |
| `unselectedStyle` | `TextStyle?` | Estilo dos itens não selecionados |
| `showDividers` | `bool` | Exibe divisores (padrão: true) |
| `dividerColor` | `Color?` | Cor dos divisores |
| `backgroundColor` | `Color?` | Cor de fundo |
| `borderRadius` | `double` | Raio das bordas (padrão: 8.0) |
| `enableHapticFeedback` | `bool` | Habilita feedback tátil (padrão: true) |
| `hapticFeedbackType` | `ModHapticFeedbackType` | Tipo de feedback |
| `useShortMonthNames` | `bool` | Usa nomes curtos dos meses (padrão: false) |
| `customMonthNames` | `List<String>?` | Nomes personalizados dos meses |
| `itemSize` | `double` | Tamanho dos itens (padrão: 36) |
| `enableAnimation` | `bool` | Habilita animação (padrão: true) |
| `animationDuration` | `Duration?` | Duração da animação |
| `dayMonthYearOrder` | `List<String>?` | Ordem dos campos (ex: ['day', 'month', 'year']) |

---

Esta documentação cobre todos os principais componentes do ModLayout com exemplos práticos baseados nos arquivos de exemplo encontrados no projeto. Cada componente pode ser customizado ainda mais usando suas propriedades específicas para atender às necessidades da sua aplicação.
