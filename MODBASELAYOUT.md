# ModBaseLayout - Guia Completo de Uso

## 📋 Índice

1. [Visão Geral](#visão-geral)
2. [Instalação](#instalação)
3. [Exemplo Básico](#exemplo-básico)
4. [Parâmetros do ModBaseLayout](#parâmetros-do-modbaselayout)
   - [Parâmetros Obrigatórios](#parâmetros-obrigatórios)
   - [Parâmetros de Conteúdo](#parâmetros-de-conteúdo)
   - [Parâmetros de Menu e Navegação](#parâmetros-de-menu-e-navegação)
   - [Parâmetros de Customização Visual](#parâmetros-de-customização-visual)
   - [Parâmetros de Cores do Header](#parâmetros-de-cores-do-header)
   - [Parâmetros de Segurança e Permissões](#parâmetros-de-segurança-e-permissões)
5. [Exemplos Práticos](#exemplos-práticos)
6. [Migração e Compatibilidade](#migração-e-compatibilidade)

---

## Visão Geral

O `ModBaseLayout` é um widget completo de layout responsivo que oferece:

- ✅ Menu lateral colapsável (desktop) e drawer (mobile)
- ✅ Sistema de módulos e grupos de menu hierárquicos
- ✅ Validação de permissões baseada em claims
- ✅ Suporte a temas claro/escuro dinâmicos
- ✅ Internacionalização (i18n) integrada
- ✅ Header customizável com logo, ações e perfil de usuário
- ✅ Footer opcional
- ✅ Layout 100% responsivo

---

## Instalação

```yaml
dependencies:
  mod_layout_one: ^1.1.2
```

```dart
import 'package:mod_layout_one/mod_layout_one.dart';
```

---

## Exemplo Básico

```dart
ModBaseLayout(
  title: 'Minha Aplicação',
  body: HomePage(),
  menuGroups: [
    MenuGroup(
      title: Text('Menu Principal'),
      items: [
        MenuItem(
          title: 'Dashboard',
          icon: Icons.dashboard,
          route: '/dashboard',
        ),
        MenuItem(
          title: 'Configurações',
          icon: Icons.settings,
          route: '/settings',
        ),
      ],
    ),
  ],
  userProfile: UserProfile(
    userName: 'João Silva',
    userEmail: 'joao@example.com',
    onLogout: () => Get.offNamed('/login'),
  ),
)
```

---

## Parâmetros do ModBaseLayout

### Parâmetros Obrigatórios

#### `title` (String)
**Descrição:** Título da aplicação exibido no header quando não há logo.

**Exemplo:**
```dart
ModBaseLayout(
  title: 'Sistema de Gestão',
  // ...
)
```

**Quando usar:** Sempre. É o texto que aparece no AppBar quando você não fornece um logo customizado.

---

#### `body` (Widget?)
**Descrição:** Conteúdo principal da aplicação que será exibido na área central.

**Exemplo:**
```dart
ModBaseLayout(
  title: 'App',
  body: Center(
    child: Text('Bem-vindo!'),
  ),
  // ...
)
```

**Quando usar:** Sempre que você quiser exibir conteúdo na tela. Pode ser qualquer widget Flutter.

---

#### `menuGroups` ou `moduleMenuGroups`
**Descrição:** Você DEVE fornecer um destes dois parâmetros para definir o menu de navegação.

**Importante:** Pelo menos um deve ser fornecido, caso contrário ocorrerá um erro de assertion.

---

### Parâmetros de Conteúdo

#### `logo` (Widget?)
**Descrição:** Widget de logo customizado que substitui o título no header.

**Exemplo:**
```dart
ModBaseLayout(
  title: 'App',
  logo: Image.asset(
    'assets/logo.png',
    height: 40,
  ),
  body: HomePage(),
  menuGroups: myMenuGroups,
)
```

**Quando usar:** Quando você quer exibir uma logo da empresa ao invés de texto no header.

**Dica:** Use imagens otimizadas (PNG ou SVG) com altura entre 30-50 pixels.

---

#### `footer` (Widget?)
**Descrição:** Widget customizado exibido no rodapé da aplicação.

**Exemplo:**
```dart
ModBaseLayout(
  title: 'App',
  body: HomePage(),
  menuGroups: myMenuGroups,
  footer: Container(
    padding: EdgeInsets.all(16),
    child: Text(
      '© 2025 Minha Empresa - Todos os direitos reservados',
      textAlign: TextAlign.center,
    ),
  ),
  footerHeight: 60.0,
)
```

**Quando usar:** Para informações de copyright, versão, links úteis, etc.

---

#### `footerHeight` (double)
**Descrição:** Altura do footer em pixels.

**Valor padrão:** `50.0`

**Exemplo:**
```dart
ModBaseLayout(
  title: 'App',
  body: HomePage(),
  menuGroups: myMenuGroups,
  footer: MyFooterWidget(),
  footerHeight: 80.0, // Footer maior
)
```

---

#### `footerBorder` (Border?)
**Descrição:** Borda customizada para o footer.

**Exemplo:**
```dart
ModBaseLayout(
  title: 'App',
  body: HomePage(),
  menuGroups: myMenuGroups,
  footer: MyFooterWidget(),
  footerBorder: Border(
    top: BorderSide(color: Colors.grey, width: 1),
  ),
)
```

---

### Parâmetros de Menu e Navegação

#### `menuGroups` (List\<MenuGroup\>?)
**Descrição:** Lista de grupos de menu para navegação simples (sem sistema de módulos).

**Estrutura:**
```dart
MenuGroup(
  title: Widget,           // Título do grupo
  items: List<MenuItem>,   // Itens do menu
  claimName: String?,      // Claim para validação (opcional)
  fontSize: double?,       // Tamanho da fonte (opcional)
  fontWeight: FontWeight?, // Peso da fonte (opcional)
  iconSize: double?,       // Tamanho do ícone (opcional)
)
```

**Exemplo:**
```dart
ModBaseLayout(
  title: 'App',
  body: HomePage(),
  menuGroups: [
    MenuGroup(
      title: Text('Cadastros'),
      items: [
        MenuItem(
          title: 'Clientes',
          icon: Icons.people,
          route: '/clientes',
        ),
        MenuItem(
          title: 'Produtos',
          icon: Icons.inventory,
          route: '/produtos',
        ),
      ],
    ),
    MenuGroup(
      title: Text('Relatórios'),
      items: [
        MenuItem(
          title: 'Vendas',
          icon: Icons.bar_chart,
          route: '/relatorios/vendas',
        ),
      ],
    ),
  ],
)
```

**Quando usar:** Para aplicações simples sem necessidade de módulos separados.

---

#### `moduleMenuGroups` (List\<ModuleMenu\>?)
**Descrição:** Sistema de módulos com múltiplos grupos de menu. Permite organizar menus por módulos diferentes.

**Estrutura:**
```dart
ModuleMenu(
  name: String,                  // Nome do módulo
  icon: IconData,                // Ícone do módulo
  description: String,           // Descrição do módulo
  menuGroups: List<MenuGroup>,   // Grupos de menu deste módulo
  onSelect: Function?,           // Callback ao selecionar módulo
  fontSize: double?,             // Tamanho da fonte
  fontWeight: FontWeight?,       // Peso da fonte
  iconSize: double?,             // Tamanho do ícone
)
```

**Exemplo:**
```dart
ModBaseLayout(
  title: 'ERP Sistema',
  body: HomePage(),
  moduleMenuGroups: [
    ModuleMenu(
      name: 'Financeiro',
      icon: Icons.attach_money,
      description: 'Módulo financeiro',
      menuGroups: [
        MenuGroup(
          title: Text('Contas'),
          items: [
            MenuItem(title: 'Contas a Pagar', icon: Icons.payment, route: '/financeiro/pagar'),
            MenuItem(title: 'Contas a Receber', icon: Icons.receipt, route: '/financeiro/receber'),
          ],
        ),
      ],
    ),
    ModuleMenu(
      name: 'Estoque',
      icon: Icons.inventory_2,
      description: 'Gestão de estoque',
      menuGroups: [
        MenuGroup(
          title: Text('Produtos'),
          items: [
            MenuItem(title: 'Cadastro', icon: Icons.add_box, route: '/estoque/cadastro'),
            MenuItem(title: 'Movimentação', icon: Icons.swap_horiz, route: '/estoque/movimentacao'),
          ],
        ),
      ],
    ),
  ],
)
```

**Quando usar:** Para sistemas grandes com múltiplos módulos distintos (ERP, CRM, etc.).

---

#### `userProfile` (UserProfile?)
**Descrição:** Widget de perfil do usuário exibido no header.

**Estrutura:**
```dart
UserProfile(
  userName: String,          // Nome do usuário
  userEmail: String?,        // Email (opcional)
  avatarUrl: String?,        // URL do avatar (opcional)
  onProfileTap: Function?,   // Ação ao clicar no perfil
  onLogout: Function?,       // Ação ao fazer logout
  showFullProfile: bool,     // Mostrar informações completas
  textColor: Color?,         // Cor do texto (opcional)
  iconColor: Color?,         // Cor dos ícones (opcional)
)
```

**Exemplo:**
```dart
ModBaseLayout(
  title: 'App',
  body: HomePage(),
  menuGroups: myMenuGroups,
  userProfile: UserProfile(
    userName: 'João Silva',
    userEmail: 'joao@empresa.com',
    avatarUrl: 'https://exemplo.com/avatar.jpg',
    showFullProfile: true,
    onProfileTap: () {
      Get.toNamed('/perfil');
    },
    onLogout: () {
      // Limpar dados e redirecionar
      Get.offAllNamed('/login');
    },
  ),
)
```

**Quando usar:** Sempre que você tiver um usuário autenticado e quiser exibir suas informações.

---

#### `appBarActions` (List\<Widget\>?)
**Descrição:** Lista de ações customizadas adicionais para o AppBar (além das ações padrão).

**Exemplo:**
```dart
ModBaseLayout(
  title: 'App',
  body: HomePage(),
  menuGroups: myMenuGroups,
  appBarActions: [
    IconButton(
      icon: Icon(Icons.notifications),
      onPressed: () {
        // Mostrar notificações
      },
    ),
    IconButton(
      icon: Icon(Icons.search),
      onPressed: () {
        // Abrir busca
      },
    ),
  ],
)
```

**Quando usar:** Para adicionar botões extras no header (notificações, busca, ajuda, etc.).

---

#### `showDefaultActions` (bool)
**Descrição:** Se `true`, mostra os botões padrão de tema e idioma no header.

**Valor padrão:** `true`

**Exemplo:**
```dart
// Ocultar botões de tema e idioma
ModBaseLayout(
  title: 'App',
  body: HomePage(),
  menuGroups: myMenuGroups,
  showDefaultActions: false,
)
```

**Quando usar:**
- `true` (padrão) - Manter os botões de troca de tema e idioma
- `false` - Quando você quer controlar esses recursos de outra forma

---

### Parâmetros de Customização Visual

#### `sidebarHeader` (Widget?)
**Descrição:** Widget customizado para o cabeçalho do menu lateral (desktop).

**Exemplo:**
```dart
ModBaseLayout(
  title: 'App',
  body: HomePage(),
  menuGroups: myMenuGroups,
  sidebarHeader: Container(
    padding: EdgeInsets.all(20),
    child: Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundImage: AssetImage('assets/logo.png'),
        ),
        SizedBox(height: 10),
        Text('Minha Empresa', style: TextStyle(fontWeight: FontWeight.bold)),
      ],
    ),
  ),
)
```

**Quando usar:** Para adicionar logo, informações da empresa ou outros elementos no topo do menu lateral.

---

#### `sidebarFooter` (Widget?)
**Descrição:** Widget customizado para o rodapé do menu lateral (desktop).

**Exemplo:**
```dart
ModBaseLayout(
  title: 'App',
  body: HomePage(),
  menuGroups: myMenuGroups,
  sidebarFooter: Container(
    padding: EdgeInsets.all(16),
    child: Text(
      'v1.0.0',
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 12, color: Colors.grey),
    ),
  ),
)
```

**Quando usar:** Para exibir versão do app, links úteis ou informações adicionais na parte inferior do menu.

---

#### `drawerHeader` (Widget?)
**Descrição:** Widget customizado para o cabeçalho do drawer (mobile/tablet).

**Exemplo:**
```dart
ModBaseLayout(
  title: 'App',
  body: HomePage(),
  menuGroups: myMenuGroups,
  drawerHeader: DrawerHeader(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [Colors.blue, Colors.blueAccent],
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 30,
          backgroundImage: NetworkImage('https://exemplo.com/avatar.jpg'),
        ),
        SizedBox(height: 10),
        Text('João Silva', style: TextStyle(color: Colors.white, fontSize: 18)),
        Text('joao@example.com', style: TextStyle(color: Colors.white70, fontSize: 14)),
      ],
    ),
  ),
)
```

**Quando usar:** Para personalizar o cabeçalho do menu mobile com informações do usuário ou da empresa.

---

#### `sidebarBackgroundColor` (Color?)
**Descrição:** Cor de fundo do menu lateral.

**Exemplo:**
```dart
ModBaseLayout(
  title: 'App',
  body: HomePage(),
  menuGroups: myMenuGroups,
  sidebarBackgroundColor: Color(0xFF2C3E50),
)
```

---

#### `sidebarSelectedColor` (Color?)
**Descrição:** Cor do item de menu selecionado.

**Exemplo:**
```dart
ModBaseLayout(
  title: 'App',
  body: HomePage(),
  menuGroups: myMenuGroups,
  sidebarSelectedColor: Colors.blueAccent,
)
```

---

#### `sidebarUnselectedColor` (Color?)
**Descrição:** Cor dos itens de menu não selecionados.

**Exemplo:**
```dart
ModBaseLayout(
  title: 'App',
  body: HomePage(),
  menuGroups: myMenuGroups,
  sidebarUnselectedColor: Colors.grey[400],
)
```

---

#### `drawerBackgroundColor` (Color?)
**Descrição:** Cor de fundo do drawer (menu mobile).

**Exemplo:**
```dart
ModBaseLayout(
  title: 'App',
  body: HomePage(),
  menuGroups: myMenuGroups,
  drawerBackgroundColor: Colors.white,
)
```

---

#### `lightBackgroundColor` (Color?)
**Descrição:** Cor de fundo do header no tema claro.

**Exemplo:**
```dart
ModBaseLayout(
  title: 'App',
  body: HomePage(),
  menuGroups: myMenuGroups,
  lightBackgroundColor: Color(0xFF411E5A), // Roxo
)
```

---

#### `darkBackgroundColor` (Color?)
**Descrição:** Cor de fundo do header no tema escuro.

**Exemplo:**
```dart
ModBaseLayout(
  title: 'App',
  body: HomePage(),
  menuGroups: myMenuGroups,
  darkBackgroundColor: Color(0xFFFFB200), // Amarelo
)
```

---

#### `lightForegroundColor` (Color?)
**Descrição:** Cor de primeiro plano (texto/ícones) do header no tema claro.

**Exemplo:**
```dart
ModBaseLayout(
  title: 'App',
  body: HomePage(),
  menuGroups: myMenuGroups,
  lightBackgroundColor: Colors.blue,
  lightForegroundColor: Colors.white,
)
```

---

#### `darkForegroundColor` (Color?)
**Descrição:** Cor de primeiro plano (texto/ícones) do header no tema escuro.

**Exemplo:**
```dart
ModBaseLayout(
  title: 'App',
  body: HomePage(),
  menuGroups: myMenuGroups,
  darkBackgroundColor: Colors.black,
  darkForegroundColor: Colors.white,
)
```

---

#### `showAppBar` (bool)
**Descrição:** Se `true`, exibe o AppBar. Se `false`, oculta completamente.

**Valor padrão:** `true`

**Exemplo:**
```dart
// App sem header
ModBaseLayout(
  title: 'App',
  body: HomePage(),
  menuGroups: myMenuGroups,
  showAppBar: false,
)
```

**Quando usar:** `false` para telas fullscreen ou experiências imersivas.

---

### Parâmetros de Cores do Header

> **Novidade na versão 1.1.2:** Controle granular das cores de cada elemento do header!

Todos os parâmetros abaixo são opcionais e, quando não informados, usam automaticamente `Get.theme.colorScheme.onPrimary`.

#### `headerMenuIconColor` (Color?)
**Descrição:** Cor do ícone do menu (hambúrguer) no header.

**Exemplo:**
```dart
ModBaseLayout(
  title: 'App',
  body: HomePage(),
  menuGroups: myMenuGroups,
  headerMenuIconColor: Colors.amber,
)
```

---

#### `headerTitleColor` (Color?)
**Descrição:** Cor do texto do título no header.

**Exemplo:**
```dart
ModBaseLayout(
  title: 'Minha Aplicação',
  body: HomePage(),
  menuGroups: myMenuGroups,
  headerTitleColor: Colors.white,
)
```

---

#### `headerThemeIconColor` (Color?)
**Descrição:** Cor do ícone de troca de tema (light/dark).

**Exemplo:**
```dart
ModBaseLayout(
  title: 'App',
  body: HomePage(),
  menuGroups: myMenuGroups,
  headerThemeIconColor: Colors.yellowAccent,
)
```

---

#### `headerProfileColor` (Color?)
**Descrição:** Cor dos elementos do perfil do usuário (texto e ícone).

**Exemplo:**
```dart
ModBaseLayout(
  title: 'App',
  body: HomePage(),
  menuGroups: myMenuGroups,
  userProfile: UserProfile(
    userName: 'João',
    userEmail: 'joao@example.com',
  ),
  headerProfileColor: Colors.white,
)
```

---

#### `headerLanguageIconColor` (Color?)
**Descrição:** Cor do ícone do seletor de idioma.

**Exemplo:**
```dart
ModBaseLayout(
  title: 'App',
  body: HomePage(),
  menuGroups: myMenuGroups,
  headerLanguageIconColor: Colors.white,
)
```

---

#### Exemplo Completo - Customização de Cores do Header

```dart
ModBaseLayout(
  title: 'Sistema Empresarial',
  body: HomePage(),
  menuGroups: myMenuGroups,
  userProfile: UserProfile(
    userName: 'João Silva',
    userEmail: 'joao@empresa.com',
  ),

  // Definir cores de fundo do header
  lightBackgroundColor: Color(0xFF411E5A), // Roxo
  darkBackgroundColor: Color(0xFFFFB200),  // Amarelo

  // Customizar cada elemento do header individualmente
  headerMenuIconColor: Colors.white,
  headerTitleColor: Colors.white,
  headerThemeIconColor: Colors.amber,
  headerProfileColor: Colors.white,
  headerLanguageIconColor: Colors.white,
)
```

---

### Parâmetros de Segurança e Permissões

#### `claims` (List\<String\>?)
**Descrição:** Lista de permissões (claims) do usuário atual. Usado para validar quais menus o usuário pode acessar.

**Formato das claims:**
- Por nome: `'menu:dashboard'`
- Por tipo:valor: `'module:financeiro'`

**Exemplo:**
```dart
ModBaseLayout(
  title: 'App',
  body: HomePage(),
  claims: [
    'menu:dashboard',
    'menu:clientes',
    'menu:produtos',
    'module:financeiro',
    'admin',
  ],
  menuGroups: [
    MenuGroup(
      title: Text('Menu'),
      items: [
        MenuItem(
          title: 'Dashboard',
          icon: Icons.dashboard,
          route: '/dashboard',
          claimName: 'menu:dashboard', // Só visível se tiver esta claim
        ),
        MenuItem(
          title: 'Configurações',
          icon: Icons.settings,
          route: '/settings',
          claimName: 'admin', // Só visível para admins
        ),
      ],
    ),
  ],
)
```

**Quando usar:** Em aplicações com controle de acesso baseado em permissões.

---

#### `disableClaimsValidation` (bool)
**Descrição:** Se `true`, desabilita completamente a validação de claims (todos os menus ficam visíveis).

**Valor padrão:** `false`

**Exemplo:**
```dart
// Modo desenvolvimento - mostrar todos os menus
ModBaseLayout(
  title: 'App [DEV]',
  body: HomePage(),
  menuGroups: myMenuGroups,
  disableClaimsValidation: true,
)
```

**Quando usar:**
- Durante desenvolvimento/debug
- Em ambientes de teste
- **NUNCA em produção com dados reais**

---

#### `loginRoute` (String?)
**Descrição:** Rota para redirecionamento quando o usuário não tem acesso a nenhum módulo.

**Exemplo:**
```dart
ModBaseLayout(
  title: 'App',
  body: HomePage(),
  claims: [], // Sem permissões
  menuGroups: myMenuGroups,
  loginRoute: '/login',
)
```

**Quando usar:** Para redirecionar usuários sem permissões para a tela de login.

---

#### `onNoAccessRedirect` (VoidCallback?)
**Descrição:** Callback executado quando o usuário sem acesso clica no botão de logout/sair.

**Exemplo:**
```dart
ModBaseLayout(
  title: 'App',
  body: HomePage(),
  claims: [],
  menuGroups: myMenuGroups,
  onNoAccessRedirect: () {
    // Limpar dados do usuário
    authService.logout();
    // Redirecionar
    Get.offAllNamed('/login');
  },
)
```

**Quando usar:** Para executar lógica customizada de logout (limpar cache, tokens, etc.).

---

## Exemplos Práticos

### Exemplo 1: Aplicação Simples com Menu Básico

```dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mod_layout_one/mod_layout_one.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ModBaseLayout(
      title: 'Meu App',
      body: Center(child: Text('Bem-vindo!')),
      menuGroups: [
        MenuGroup(
          title: Text('Menu'),
          items: [
            MenuItem(
              title: 'Home',
              icon: Icons.home,
              route: '/home',
            ),
            MenuItem(
              title: 'Sobre',
              icon: Icons.info,
              route: '/sobre',
            ),
          ],
        ),
      ],
    );
  }
}
```

---

### Exemplo 2: Sistema com Módulos e Autenticação

```dart
class DashboardPage extends StatelessWidget {
  final AuthService authService = Get.find();

  @override
  Widget build(BuildContext context) {
    return ModBaseLayout(
      title: 'ERP Empresarial',
      logo: Image.asset('assets/logo.png', height: 40),
      body: DashboardContent(),

      // Permissões do usuário
      claims: authService.userClaims,

      // Sistema de módulos
      moduleMenuGroups: [
        ModuleMenu(
          name: 'Financeiro',
          icon: Icons.attach_money,
          description: 'Gestão financeira',
          menuGroups: [
            MenuGroup(
              title: Text('Contas'),
              claimName: 'module:financeiro',
              items: [
                MenuItem(
                  title: 'Contas a Pagar',
                  icon: Icons.payment,
                  route: '/financeiro/pagar',
                  claimName: 'menu:contas_pagar',
                ),
                MenuItem(
                  title: 'Contas a Receber',
                  icon: Icons.receipt,
                  route: '/financeiro/receber',
                  claimName: 'menu:contas_receber',
                ),
              ],
            ),
          ],
        ),
        ModuleMenu(
          name: 'RH',
          icon: Icons.people,
          description: 'Recursos Humanos',
          menuGroups: [
            MenuGroup(
              title: Text('Colaboradores'),
              claimName: 'module:rh',
              items: [
                MenuItem(
                  title: 'Funcionários',
                  icon: Icons.badge,
                  route: '/rh/funcionarios',
                  claimName: 'menu:funcionarios',
                ),
                MenuItem(
                  title: 'Folha de Pagamento',
                  icon: Icons.money,
                  route: '/rh/folha',
                  claimName: 'menu:folha',
                ),
              ],
            ),
          ],
        ),
      ],

      // Perfil do usuário
      userProfile: UserProfile(
        userName: authService.userName,
        userEmail: authService.userEmail,
        avatarUrl: authService.avatarUrl,
        onProfileTap: () => Get.toNamed('/perfil'),
        onLogout: () {
          authService.logout();
          Get.offAllNamed('/login');
        },
      ),

      // Ações extras
      appBarActions: [
        IconButton(
          icon: Icon(Icons.notifications),
          onPressed: () => Get.toNamed('/notificacoes'),
        ),
      ],

      // Segurança
      loginRoute: '/login',
      onNoAccessRedirect: () {
        authService.logout();
        Get.offAllNamed('/login');
      },

      // Footer
      footer: Text(
        '© 2025 Minha Empresa - v1.0.0',
        textAlign: TextAlign.center,
      ),
    );
  }
}
```

---

### Exemplo 3: Customização Completa de Cores

```dart
class ThemedApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ModBaseLayout(
      title: 'App Customizado',
      body: HomePage(),
      menuGroups: myMenuGroups,

      // Cores do header
      lightBackgroundColor: Color(0xFF411E5A), // Roxo
      lightForegroundColor: Colors.white,
      darkBackgroundColor: Color(0xFFFFB200),  // Amarelo
      darkForegroundColor: Color(0xFF0C0C0C),

      // Cores individuais dos elementos do header
      headerMenuIconColor: Colors.white,
      headerTitleColor: Colors.white,
      headerThemeIconColor: Colors.amber,
      headerProfileColor: Colors.white,
      headerLanguageIconColor: Colors.white,

      // Cores do menu lateral
      sidebarBackgroundColor: Color(0xFF2C3E50),
      sidebarSelectedColor: Color(0xFFFFB200),
      sidebarUnselectedColor: Colors.grey[400],

      userProfile: UserProfile(
        userName: 'João Silva',
        userEmail: 'joao@example.com',
      ),
    );
  }
}
```

---

### Exemplo 4: Menu com Submenus Aninhados

```dart
ModBaseLayout(
  title: 'Sistema Completo',
  body: HomePage(),
  menuGroups: [
    MenuGroup(
      title: Text('Cadastros'),
      items: [
        MenuItem(
          title: 'Clientes',
          icon: Icons.people,
          subItems: [
            MenuItem(
              title: 'Pessoas Físicas',
              icon: Icons.person,
              route: '/clientes/pf',
            ),
            MenuItem(
              title: 'Pessoas Jurídicas',
              icon: Icons.business,
              route: '/clientes/pj',
            ),
            MenuItem(
              title: 'Importar Clientes',
              icon: Icons.upload,
              route: '/clientes/importar',
            ),
          ],
        ),
        MenuItem(
          title: 'Produtos',
          icon: Icons.inventory,
          subItems: [
            MenuItem(
              title: 'Lista de Produtos',
              icon: Icons.list,
              route: '/produtos/lista',
            ),
            MenuItem(
              title: 'Categorias',
              icon: Icons.category,
              route: '/produtos/categorias',
            ),
          ],
        ),
      ],
    ),
  ],
)
```

---

## Migração e Compatibilidade

### Migração da v1.1.1 para v1.1.2

A versão 1.1.2 é **100% retrocompatível**. Nenhuma alteração é necessária no seu código existente.

#### Novos recursos opcionais:

1. **Customização de cores do header:**
```dart
// ANTES (v1.1.1)
ModBaseLayout(
  title: 'App',
  lightBackgroundColor: Colors.blue,
  lightForegroundColor: Colors.white,
  // ...
)

// DEPOIS (v1.1.2) - Com controle granular
ModBaseLayout(
  title: 'App',
  lightBackgroundColor: Colors.blue,
  lightForegroundColor: Colors.white,

  // NOVOS parâmetros opcionais
  headerMenuIconColor: Colors.white,
  headerTitleColor: Colors.white,
  headerThemeIconColor: Colors.amber,
  headerProfileColor: Colors.white,
  headerLanguageIconColor: Colors.white,
  // ...
)
```

2. **Comportamento padrão inteligente:**
   - Se você **não** especificar os novos parâmetros de cor, o ModBaseLayout automaticamente usa `Get.theme.colorScheme.onPrimary`
   - Todos os elementos do header agora respeitam o tema ativo (light/dark)
   - Troca de tema atualiza as cores automaticamente

---

## Dicas e Boas Práticas

### ✅ Fazer

1. **Use claims para segurança:** Sempre implemente validação de permissões em produção
2. **Organize por módulos:** Para sistemas grandes, use `moduleMenuGroups` ao invés de `menuGroups`
3. **Teste responsividade:** Verifique desktop, tablet e mobile
4. **Personalize o perfil:** Use `UserProfile` com informações reais do usuário
5. **Adicione footer:** Útil para versão, copyright e links úteis

### ❌ Evitar

1. **Não desabilite claims em produção:** `disableClaimsValidation: true` é só para dev/debug
2. **Não use menus muito profundos:** Máximo 2-3 níveis de submenu
3. **Não ignore mobile:** Sempre teste o drawer em telas pequenas
4. **Não misture:** Use OU `menuGroups` OU `moduleMenuGroups`, não ambos
5. **Não hardcode cores:** Use as propriedades do tema sempre que possível

---

## Suporte e Contribuições

- 📦 **NPM/Pub:** [mod_layout_one](https://pub.dev/packages/mod_layout_one)
- 🐛 **Issues:** [GitHub Issues](https://github.com/cesarmod2017/mod_layout_one/issues)
- 📖 **Documentação:** [README.md](https://github.com/cesarmod2017/mod_layout_one/blob/main/README.md)
- 📝 **Changelog:** [CHANGELOG.md](https://github.com/cesarmod2017/mod_layout_one/blob/main/CHANGELOG.md)

---

**Versão do documento:** 1.1.2
**Última atualização:** 2025-01-06
