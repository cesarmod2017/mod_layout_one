import 'package:mod_layout_one/layout/models/chatbot_config.dart';
import 'package:mod_layout_one/layout/models/menu_group.dart';
import 'package:mod_layout_one/layout/models/module_model.dart';
import 'package:mod_layout_one/layout/widgets/user_profile.dart';
import 'package:flutter/material.dart';

/// Controller para gerenciamento dinâmico do estado do [ModBaseLayout].
///
/// Similar ao funcionamento de um [TextEditingController] para [TextField],
/// este controller permite a manipulação programática e reativa dos dados
/// do layout, possibilitando atualizações em tempo real sem necessidade
/// de navegação.
///
/// ## Exemplo básico:
/// ```dart
/// // Criação do controller
/// final layoutController = ModBaseLayoutController(
///   claims: ['admin', 'user:read'],
///   menuGroups: myMenuGroups,
///   userProfile: UserProfile(userName: 'João'),
/// );
///
/// // Uso no ModBaseLayout
/// ModBaseLayout(
///   title: 'Minha App',
///   body: HomePage(),
///   controller: layoutController,
/// )
///
/// // Atualização dinâmica dos dados
/// layoutController.updateClaims(['admin', 'user:read', 'user:write']);
/// layoutController.updateUserProfile(UserProfile(userName: 'Maria'));
/// ```
///
/// ## Integração com GetController:
/// ```dart
/// class MyController extends GetxController {
///   late final ModBaseLayoutController layoutController;
///
///   @override
///   void onInit() {
///     super.onInit();
///     layoutController = ModBaseLayoutController(
///       claims: [],
///       menuGroups: [],
///     );
///   }
///
///   void onUserLogin(User user) {
///     layoutController.updateClaims(user.permissions);
///     layoutController.updateUserProfile(
///       UserProfile(userName: user.name, userEmail: user.email),
///     );
///     layoutController.updateMenuGroups(buildMenuForUser(user));
///   }
///
///   @override
///   void onClose() {
///     layoutController.dispose();
///     super.onClose();
///   }
/// }
/// ```
class ModBaseLayoutController extends ChangeNotifier {
  /// Lista de claims para validação de permissões
  List<String>? _claims;

  /// Grupos de menu para navegação (usado quando não há módulos)
  List<MenuGroup>? _menuGroups;

  /// Sistema de módulos com múltiplos grupos de menu
  List<ModuleMenu>? _moduleMenuGroups;

  /// Widget de perfil do usuário exibido no header
  UserProfile? _userProfile;

  /// Ações customizadas adicionais para o AppBar
  List<Widget>? _appBarActions;

  /// Widget customizado para o rodapé do menu lateral (desktop)
  Widget? _sidebarFooter;

  /// Widget customizado para o cabeçalho do menu lateral (desktop)
  Widget? _sidebarHeader;

  /// Widget customizado para o footer da aplicação
  Widget? _footer;

  /// Widget customizado para o cabeçalho do drawer (mobile)
  Widget? _drawerHeader;

  /// Configuração do chatbot flutuante
  ChatbotConfig? _chatbotConfig;

  /// Widget de logo customizado para o header
  Widget? _logo;

  /// Título da aplicação exibido no header
  String? _title;

  /// Cria um novo [ModBaseLayoutController] com valores iniciais opcionais.
  ///
  /// Todos os parâmetros são opcionais e podem ser atualizados posteriormente
  /// usando os métodos de update correspondentes.
  ModBaseLayoutController({
    List<String>? claims,
    List<MenuGroup>? menuGroups,
    List<ModuleMenu>? moduleMenuGroups,
    UserProfile? userProfile,
    List<Widget>? appBarActions,
    Widget? sidebarFooter,
    Widget? sidebarHeader,
    Widget? footer,
    Widget? drawerHeader,
    ChatbotConfig? chatbotConfig,
    Widget? logo,
    String? title,
  })  : _claims = claims,
        _menuGroups = menuGroups,
        _moduleMenuGroups = moduleMenuGroups,
        _userProfile = userProfile,
        _appBarActions = appBarActions,
        _sidebarFooter = sidebarFooter,
        _sidebarHeader = sidebarHeader,
        _footer = footer,
        _drawerHeader = drawerHeader,
        _chatbotConfig = chatbotConfig,
        _logo = logo,
        _title = title;

  // Getters

  /// Retorna a lista atual de claims
  List<String>? get claims => _claims;

  /// Retorna os grupos de menu atuais
  List<MenuGroup>? get menuGroups => _menuGroups;

  /// Retorna os módulos de menu atuais
  List<ModuleMenu>? get moduleMenuGroups => _moduleMenuGroups;

  /// Retorna o perfil do usuário atual
  UserProfile? get userProfile => _userProfile;

  /// Retorna as ações do AppBar atuais
  List<Widget>? get appBarActions => _appBarActions;

  /// Retorna o footer do sidebar atual
  Widget? get sidebarFooter => _sidebarFooter;

  /// Retorna o header do sidebar atual
  Widget? get sidebarHeader => _sidebarHeader;

  /// Retorna o footer atual
  Widget? get footer => _footer;

  /// Retorna o header do drawer atual
  Widget? get drawerHeader => _drawerHeader;

  /// Retorna a configuração do chatbot atual
  ChatbotConfig? get chatbotConfig => _chatbotConfig;

  /// Retorna o logo atual
  Widget? get logo => _logo;

  /// Retorna o título atual
  String? get title => _title;

  // Update methods

  /// Atualiza a lista de claims e notifica os listeners.
  ///
  /// Use este método quando as permissões do usuário mudarem,
  /// por exemplo, após login ou alteração de papel.
  ///
  /// ```dart
  /// controller.updateClaims(['admin', 'user:read', 'user:write']);
  /// ```
  void updateClaims(List<String>? claims) {
    _claims = claims;
    notifyListeners();
  }

  /// Atualiza os grupos de menu e notifica os listeners.
  ///
  /// Use este método quando a estrutura de navegação precisar mudar
  /// dinamicamente, por exemplo, baseado no papel do usuário.
  ///
  /// ```dart
  /// controller.updateMenuGroups([
  ///   MenuGroup(title: Text('Admin'), items: adminMenuItems),
  /// ]);
  /// ```
  void updateMenuGroups(List<MenuGroup>? menuGroups) {
    _menuGroups = menuGroups;
    notifyListeners();
  }

  /// Atualiza os módulos de menu e notifica os listeners.
  ///
  /// Use este método quando os módulos disponíveis para o usuário
  /// precisarem mudar dinamicamente.
  ///
  /// ```dart
  /// controller.updateModuleMenuGroups([
  ///   ModuleMenu(name: 'Dashboard', icon: Icons.dashboard, menuGroups: [...]),
  ///   ModuleMenu(name: 'Admin', icon: Icons.admin, menuGroups: [...]),
  /// ]);
  /// ```
  void updateModuleMenuGroups(List<ModuleMenu>? moduleMenuGroups) {
    _moduleMenuGroups = moduleMenuGroups;
    notifyListeners();
  }

  /// Atualiza o perfil do usuário e notifica os listeners.
  ///
  /// Use este método quando os dados do usuário mudarem,
  /// como após login, atualização de perfil, ou troca de avatar.
  ///
  /// ```dart
  /// controller.updateUserProfile(
  ///   UserProfile(
  ///     userName: 'Maria Silva',
  ///     userEmail: 'maria@example.com',
  ///     avatarUrl: 'https://example.com/avatar.jpg',
  ///   ),
  /// );
  /// ```
  void updateUserProfile(UserProfile? userProfile) {
    _userProfile = userProfile;
    notifyListeners();
  }

  /// Atualiza as ações do AppBar e notifica os listeners.
  ///
  /// Use este método para adicionar ou remover botões de ação
  /// no header dinamicamente.
  ///
  /// ```dart
  /// controller.updateAppBarActions([
  ///   IconButton(icon: Icon(Icons.notifications), onPressed: () {}),
  ///   IconButton(icon: Icon(Icons.search), onPressed: () {}),
  /// ]);
  /// ```
  void updateAppBarActions(List<Widget>? appBarActions) {
    _appBarActions = appBarActions;
    notifyListeners();
  }

  /// Atualiza o footer do sidebar e notifica os listeners.
  ///
  /// Use este método para alterar o conteúdo do rodapé do menu lateral.
  ///
  /// ```dart
  /// controller.updateSidebarFooter(
  ///   Text('Versão 1.0.0', style: TextStyle(fontSize: 12)),
  /// );
  /// ```
  void updateSidebarFooter(Widget? sidebarFooter) {
    _sidebarFooter = sidebarFooter;
    notifyListeners();
  }

  /// Atualiza o header do sidebar e notifica os listeners.
  ///
  /// Use este método para alterar o conteúdo do cabeçalho do menu lateral.
  ///
  /// ```dart
  /// controller.updateSidebarHeader(
  ///   Image.asset('assets/logo.png', height: 40),
  /// );
  /// ```
  void updateSidebarHeader(Widget? sidebarHeader) {
    _sidebarHeader = sidebarHeader;
    notifyListeners();
  }

  /// Atualiza o footer da aplicação e notifica os listeners.
  ///
  /// Use este método para alterar o conteúdo do rodapé da aplicação.
  ///
  /// ```dart
  /// controller.updateFooter(
  ///   Text('© 2024 Minha Empresa - Todos os direitos reservados'),
  /// );
  /// ```
  void updateFooter(Widget? footer) {
    _footer = footer;
    notifyListeners();
  }

  /// Atualiza o header do drawer mobile e notifica os listeners.
  ///
  /// Use este método para alterar o conteúdo do cabeçalho do drawer
  /// na versão mobile.
  ///
  /// ```dart
  /// controller.updateDrawerHeader(
  ///   DrawerHeader(child: Text('Menu')),
  /// );
  /// ```
  void updateDrawerHeader(Widget? drawerHeader) {
    _drawerHeader = drawerHeader;
    notifyListeners();
  }

  /// Atualiza a configuração do chatbot e notifica os listeners.
  ///
  /// Use este método para alterar as configurações do chatbot
  /// flutuante ou para habilitá-lo/desabilitá-lo.
  ///
  /// ```dart
  /// controller.updateChatbotConfig(
  ///   ChatbotConfig(
  ///     chatWidget: MyChatWidget(),
  ///     position: ChatbotPosition.bottomRight,
  ///   ),
  /// );
  /// ```
  void updateChatbotConfig(ChatbotConfig? chatbotConfig) {
    _chatbotConfig = chatbotConfig;
    notifyListeners();
  }

  /// Atualiza o logo e notifica os listeners.
  ///
  /// Use este método para trocar o logo dinamicamente.
  ///
  /// ```dart
  /// controller.updateLogo(
  ///   Image.asset('assets/new_logo.png', height: 40),
  /// );
  /// ```
  void updateLogo(Widget? logo) {
    _logo = logo;
    notifyListeners();
  }

  /// Atualiza o título e notifica os listeners.
  ///
  /// Use este método para trocar o título dinamicamente.
  ///
  /// ```dart
  /// controller.updateTitle('Novo Título');
  /// ```
  void updateTitle(String? title) {
    _title = title;
    notifyListeners();
  }

  /// Atualiza múltiplas propriedades de uma vez e notifica os listeners.
  ///
  /// Use este método quando precisar atualizar várias propriedades
  /// simultaneamente, evitando múltiplas notificações.
  ///
  /// ```dart
  /// controller.updateAll(
  ///   claims: newClaims,
  ///   menuGroups: newMenuGroups,
  ///   userProfile: newUserProfile,
  /// );
  /// ```
  void updateAll({
    List<String>? claims,
    List<MenuGroup>? menuGroups,
    List<ModuleMenu>? moduleMenuGroups,
    UserProfile? userProfile,
    List<Widget>? appBarActions,
    Widget? sidebarFooter,
    Widget? sidebarHeader,
    Widget? footer,
    Widget? drawerHeader,
    ChatbotConfig? chatbotConfig,
    Widget? logo,
    String? title,
  }) {
    bool hasChanges = false;

    if (claims != null) {
      _claims = claims;
      hasChanges = true;
    }
    if (menuGroups != null) {
      _menuGroups = menuGroups;
      hasChanges = true;
    }
    if (moduleMenuGroups != null) {
      _moduleMenuGroups = moduleMenuGroups;
      hasChanges = true;
    }
    if (userProfile != null) {
      _userProfile = userProfile;
      hasChanges = true;
    }
    if (appBarActions != null) {
      _appBarActions = appBarActions;
      hasChanges = true;
    }
    if (sidebarFooter != null) {
      _sidebarFooter = sidebarFooter;
      hasChanges = true;
    }
    if (sidebarHeader != null) {
      _sidebarHeader = sidebarHeader;
      hasChanges = true;
    }
    if (footer != null) {
      _footer = footer;
      hasChanges = true;
    }
    if (drawerHeader != null) {
      _drawerHeader = drawerHeader;
      hasChanges = true;
    }
    if (chatbotConfig != null) {
      _chatbotConfig = chatbotConfig;
      hasChanges = true;
    }
    if (logo != null) {
      _logo = logo;
      hasChanges = true;
    }
    if (title != null) {
      _title = title;
      hasChanges = true;
    }

    if (hasChanges) {
      notifyListeners();
    }
  }

  /// Força uma atualização do layout, notificando todos os listeners.
  ///
  /// Use este método quando precisar forçar um rebuild do layout
  /// sem necessariamente alterar os dados.
  ///
  /// ```dart
  /// // Após alguma operação que requer atualização visual
  /// controller.refresh();
  /// ```
  void refresh() {
    notifyListeners();
  }

  /// Limpa todos os dados do controller e notifica os listeners.
  ///
  /// Use este método para resetar o estado do layout, por exemplo,
  /// durante logout do usuário.
  ///
  /// ```dart
  /// void onLogout() {
  ///   controller.clear();
  ///   // Navegar para tela de login
  /// }
  /// ```
  void clear() {
    _claims = null;
    _menuGroups = null;
    _moduleMenuGroups = null;
    _userProfile = null;
    _appBarActions = null;
    _sidebarFooter = null;
    _sidebarHeader = null;
    _footer = null;
    _drawerHeader = null;
    _chatbotConfig = null;
    _logo = null;
    _title = null;
    notifyListeners();
  }
}
