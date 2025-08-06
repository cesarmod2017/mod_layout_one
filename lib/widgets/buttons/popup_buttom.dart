import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'buttons.dart';

/// Modelo para representar um item do menu popup
class ModPopupMenuItem<T> {
  final T value;
  final String? text;
  final IconData? icon;
  final Color? textColor;
  final Color? iconColor;
  final bool enabled;
  final Widget? child;
  final List<ModPopupMenuItem<T>>? submenu;

  const ModPopupMenuItem({
    required this.value,
    this.text,
    this.icon,
    this.textColor,
    this.iconColor,
    this.enabled = true,
    this.child,
    this.submenu,
  });
}

class ModPopupButton<T> extends StatefulWidget {
  final String? title;
  final IconData? leftIcon;
  final IconData? rightIcon;
  final IconData? popupIcon;
  final double borderRadius;
  final ModButtonType type;
  final ModBorderType borderType;
  final ModButtonSize size;
  final List<ModPopupMenuItem<T>> items;
  final void Function(T value)? onSelected;
  final ModButtonType borderColor;
  final Color? textColor;
  final Color? backgroundColor;
  final bool disabled;
  final bool autosize;
  final TextAlign textAlign;
  final PopupMenuPosition position;
  final String? tooltip;
  final Color? popupBackgroundColor;
  final double? elevation;
  final ShapeBorder? shape;
  final EdgeInsets? popupPadding;
  final double? iconSize;

  // Customizações de fontes e espaçamentos (todas opcionais)
  final double? menuFontSize; // Tamanho da fonte dos itens do menu principal
  final double? submenuFontSize; // Tamanho da fonte dos itens do submenu
  final EdgeInsets? menuItemPadding; // Padding dos itens do menu principal
  final EdgeInsets? submenuItemPadding; // Padding dos itens do submenu
  final double? iconTextSpacing; // Espaçamento entre ícone e texto
  final double? submenuOffset; // Distância entre menu e submenu (desktop)

  const ModPopupButton({
    super.key,
    this.title,
    this.leftIcon,
    this.rightIcon,
    this.popupIcon,
    this.borderRadius = 4.0,
    this.type = ModButtonType.defaultType,
    this.borderType = ModBorderType.solid,
    this.size = ModButtonSize.md,
    required this.items,
    this.onSelected,
    this.borderColor = ModButtonType.defaultType,
    this.textColor,
    this.backgroundColor,
    this.disabled = false,
    this.autosize = true,
    this.textAlign = TextAlign.center,
    this.position = PopupMenuPosition.over,
    this.tooltip,
    this.popupBackgroundColor,
    this.elevation,
    this.shape,
    this.popupPadding,
    this.iconSize,
    this.menuFontSize,
    this.submenuFontSize,
    this.menuItemPadding,
    this.submenuItemPadding,
    this.iconTextSpacing,
    this.submenuOffset,
  });

  @override
  State<ModPopupButton<T>> createState() => _ModPopupButtonState<T>();
}

class _ModPopupButtonState<T> extends State<ModPopupButton<T>> {
  List<ModPopupMenuItem<T>>? _currentSubmenu;
  ModPopupMenuItem<T>? _currentParent;

  // Para comportamento desktop/web com hover
  OverlayEntry? _submenuOverlay;
  Timer? _submenuTimer;

  // Detectar se é desktop/web vs mobile/tablet
  bool get _isDesktop {
    if (kIsWeb) return true;
    try {
      return Platform.isWindows || Platform.isLinux || Platform.isMacOS;
    } catch (e) {
      return false;
    }
  }

  @override
  void dispose() {
    _submenuTimer?.cancel();
    _removeSubmenuOverlay();
    super.dispose();
  }

  void _removeSubmenuOverlay() {
    _submenuOverlay?.remove();
    _submenuOverlay = null;
  }

  void _showSubmenuOverlay(
      ModPopupMenuItem<T> parentItem, RenderBox itemBox, Offset itemPosition) {
    if (parentItem.submenu == null || !parentItem.enabled) return;

    _removeSubmenuOverlay();

    final submenuItems = parentItem.submenu!;
    final overlay = Overlay.of(context);
    final screenSize = MediaQuery.of(context).size;

    // Usar offset customizado ou padrão
    final offset = widget.submenuOffset ?? 4.0;

    // Calcular posição do submenu baseado na posição do item, não do botão
    double submenuLeft = itemPosition.dx + itemBox.size.width + offset;

    // Se não cabe à direita, posicionar à esquerda
    const submenuWidth = 200.0;
    if (submenuLeft + submenuWidth > screenSize.width) {
      submenuLeft = itemPosition.dx - submenuWidth - offset;
    }

    _submenuOverlay = OverlayEntry(
      builder: (context) => Positioned(
        left: submenuLeft,
        top: itemPosition.dy,
        child: Material(
          elevation: widget.elevation ?? 8.0,
          color: widget.popupBackgroundColor ?? Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(4),
          child: MouseRegion(
            onEnter: (_) => _cancelSubmenuTimer(),
            onExit: (_) => _scheduleSubmenuClose(),
            child: IntrinsicWidth(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: submenuItems
                    .map((item) => _buildDesktopSubmenuItem(item))
                    .toList(),
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(_submenuOverlay!);
  }

  Widget _buildDesktopSubmenuItem(ModPopupMenuItem<T> item) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: item.enabled
            ? () {
                _removeSubmenuOverlay();
                Navigator.of(context).pop(); // Fechar menu principal
                if (widget.onSelected != null) {
                  widget.onSelected!(item.value);
                }
              }
            : null,
        child: Container(
          padding: widget.submenuItemPadding ??
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (item.icon != null) ...[
                Icon(
                  item.icon,
                  size: _getIconSize() - 4,
                  color: item.iconColor ?? (item.enabled ? null : Colors.grey),
                ),
                SizedBox(width: widget.iconTextSpacing ?? 8),
              ],
              if (item.text != null)
                Text(
                  item.text!,
                  style: TextStyle(
                    color:
                        item.textColor ?? (item.enabled ? null : Colors.grey),
                    fontSize: widget.submenuFontSize ?? _getFontSize(),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _scheduleSubmenuClose() {
    _submenuTimer?.cancel();
    _submenuTimer = Timer(const Duration(milliseconds: 300), () {
      _removeSubmenuOverlay();
    });
  }

  void _cancelSubmenuTimer() {
    _submenuTimer?.cancel();
  }

  double _getHeight() {
    switch (widget.size) {
      case ModButtonSize.lg:
        return 48;
      case ModButtonSize.md:
        return 40;
      case ModButtonSize.sm:
        return 32;
      case ModButtonSize.xs:
        return 24;
    }
  }

  EdgeInsets _getPadding() {
    switch (widget.size) {
      case ModButtonSize.lg:
        return const EdgeInsets.symmetric(horizontal: 24, vertical: 12);
      case ModButtonSize.md:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 8);
      case ModButtonSize.sm:
        return const EdgeInsets.symmetric(horizontal: 12, vertical: 6);
      case ModButtonSize.xs:
        return const EdgeInsets.symmetric(horizontal: 8, vertical: 4);
    }
  }

  double _getIconSize() {
    if (widget.iconSize != null) return widget.iconSize!;

    switch (widget.size) {
      case ModButtonSize.lg:
        return 24;
      case ModButtonSize.md:
        return 20;
      case ModButtonSize.sm:
        return 18;
      case ModButtonSize.xs:
        return 16;
    }
  }

  double _getFontSize() {
    switch (widget.size) {
      case ModButtonSize.lg:
        return 18;
      case ModButtonSize.md:
        return 16;
      case ModButtonSize.sm:
        return 14;
      case ModButtonSize.xs:
        return 12;
    }
  }

  Color _getTypeColor() {
    if (widget.disabled) {
      return Colors.grey.shade300;
    }
    switch (widget.type) {
      case ModButtonType.none:
        return Colors.transparent;
      case ModButtonType.primary:
        return Colors.blue;
      case ModButtonType.secondary:
        return Colors.grey;
      case ModButtonType.success:
        return Colors.green;
      case ModButtonType.info:
        return Colors.lightBlue;
      case ModButtonType.warning:
        return Colors.orange;
      case ModButtonType.danger:
        return Colors.red;
      case ModButtonType.dark:
        return Colors.black87;
      case ModButtonType.defaultType:
        return Colors.grey.shade300;
      case ModButtonType.custom:
        return widget.backgroundColor ?? Colors.grey.shade300;
    }
  }

  Color _getBorderColor() {
    if (widget.disabled) {
      return Colors.grey.shade300;
    }
    switch (widget.borderColor) {
      case ModButtonType.none:
        return Colors.transparent;
      case ModButtonType.primary:
        return Colors.blue;
      case ModButtonType.secondary:
        return Colors.grey;
      case ModButtonType.success:
        return Colors.green;
      case ModButtonType.info:
        return Colors.lightBlue;
      case ModButtonType.warning:
        return Colors.orange;
      case ModButtonType.danger:
        return Colors.red;
      case ModButtonType.dark:
        return Colors.black87;
      case ModButtonType.defaultType:
        return Colors.grey.shade300;
      case ModButtonType.custom:
        return widget.backgroundColor ?? Colors.grey.shade300;
    }
  }

  Border _getBorder() {
    BorderStyle borderStyle;
    switch (widget.borderType) {
      case ModBorderType.none:
        borderStyle = BorderStyle.none;
        break;
      case ModBorderType.solid:
        borderStyle = BorderStyle.solid;
        break;
    }

    return Border.all(
      color: widget.type == ModButtonType.none
          ? _getBorderColor()
          : _getTypeColor(),
      style: borderStyle,
      width: widget.borderType == ModBorderType.none ? 0 : 1,
    );
  }

  Color _getTextColor() {
    if (widget.disabled) {
      return Colors.grey;
    }
    if (widget.textColor != null) {
      return widget.textColor!;
    }
    if (widget.type == ModButtonType.none) {
      return _getBorderColor();
    }
    return Colors.white;
  }

  List<PopupMenuEntry<T>> _buildMenuItems() {
    if (_isDesktop) {
      return _buildDesktopMenuItems();
    } else {
      return _buildMobileMenuItems();
    }
  }

  List<PopupMenuEntry<T>> _buildDesktopMenuItems() {
    // Para desktop: sempre mostrar itens principais, usar hover para submenus
    return widget.items.map((item) {
      if (item.child != null) {
        return PopupMenuItem<T>(
          value: item.submenu != null ? null : item.value,
          enabled: item.enabled,
          child: item.submenu != null && item.enabled
              ? _buildDesktopMenuItemWithHover(item, item.child!)
              : item.child!,
        );
      }

      final content = Container(
        padding: widget.menuItemPadding,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (item.icon != null) ...[
              Icon(
                item.icon,
                size: _getIconSize() - 4,
                color: item.iconColor ?? (item.enabled ? null : Colors.grey),
              ),
              SizedBox(width: widget.iconTextSpacing ?? 8),
            ],
            if (item.text != null)
              Expanded(
                child: Text(
                  item.text!,
                  style: TextStyle(
                    color:
                        item.textColor ?? (item.enabled ? null : Colors.grey),
                    fontSize: widget.menuFontSize ?? _getFontSize(),
                  ),
                ),
              ),
            if (item.submenu != null) ...[
              SizedBox(width: widget.iconTextSpacing ?? 8),
              Icon(
                Icons.arrow_right,
                size: _getIconSize() - 4,
                color: item.enabled ? Colors.grey.shade600 : Colors.grey,
              ),
            ],
          ],
        ),
      );

      return PopupMenuItem<T>(
        value: item.submenu != null ? null : item.value,
        enabled: item.enabled,
        child: item.submenu != null && item.enabled
            ? _buildDesktopMenuItemWithHover(item, content)
            : content,
      );
    }).toList();
  }

  Widget _buildDesktopMenuItemWithHover(
      ModPopupMenuItem<T> item, Widget child) {
    return Builder(
      builder: (itemContext) => MouseRegion(
        onEnter: (_) {
          _cancelSubmenuTimer();
          final RenderBox? box = itemContext.findRenderObject() as RenderBox?;
          if (box != null) {
            final position = box.localToGlobal(Offset.zero);
            _showSubmenuOverlay(item, box, position);
          }
        },
        onExit: (_) => _scheduleSubmenuClose(),
        child: child,
      ),
    );
  }

  List<PopupMenuEntry<T>> _buildMobileMenuItems() {
    // Para mobile: navegação interna com botão voltar
    final items = _currentSubmenu ?? widget.items;
    final menuItems = <PopupMenuEntry<T>>[];

    // Adicionar botão "Voltar" se estamos em um submenu
    if (_currentSubmenu != null) {
      menuItems.add(
        PopupMenuItem<T>(
          value: null,
          onTap: () => _goBack(),
          child: Row(
            children: [
              Icon(
                Icons.arrow_back,
                size: _getIconSize() - 4,
                color: Colors.grey.shade600,
              ),
              const SizedBox(width: 8),
              Text(
                'Voltar',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: _getFontSize(),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );

      if (_currentParent?.text != null) {
        menuItems.add(
          PopupMenuItem<T>(
            value: null,
            enabled: false,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text(
                _currentParent!.text!,
                style: TextStyle(
                  fontSize: _getFontSize() - 1,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade700,
                ),
              ),
            ),
          ),
        );
      }

      menuItems.add(const PopupMenuDivider());
    }

    // Adicionar items do menu atual
    menuItems.addAll(items.map((item) {
      if (item.child != null) {
        return PopupMenuItem<T>(
          value: item.submenu != null ? null : item.value,
          enabled: item.enabled,
          onTap: item.submenu != null && item.enabled
              ? () => _navigateToSubmenu(item)
              : null,
          child: item.child!,
        );
      }

      return PopupMenuItem<T>(
        value: item.submenu != null ? null : item.value,
        enabled: item.enabled,
        onTap: item.submenu != null && item.enabled
            ? () => _navigateToSubmenu(item)
            : null,
        child: Container(
          padding: widget.menuItemPadding,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (item.icon != null) ...[
                Icon(
                  item.icon,
                  size: _getIconSize() - 4,
                  color: item.iconColor ?? (item.enabled ? null : Colors.grey),
                ),
                SizedBox(width: widget.iconTextSpacing ?? 8),
              ],
              if (item.text != null)
                Expanded(
                  child: Text(
                    item.text!,
                    style: TextStyle(
                      color:
                          item.textColor ?? (item.enabled ? null : Colors.grey),
                      fontSize: widget.menuFontSize ?? _getFontSize(),
                    ),
                  ),
                ),
              if (item.submenu != null) ...[
                SizedBox(width: widget.iconTextSpacing ?? 8),
                Icon(
                  Icons.arrow_right,
                  size: _getIconSize() - 4,
                  color: item.enabled ? Colors.grey.shade600 : Colors.grey,
                ),
              ],
            ],
          ),
        ),
      );
    }).toList());

    return menuItems;
  }

  void _navigateToSubmenu(ModPopupMenuItem<T> parentItem) {
    if (parentItem.submenu == null || !parentItem.enabled) return;

    setState(() {
      _currentSubmenu = parentItem.submenu;
      _currentParent = parentItem;
    });
  }

  void _goBack() {
    setState(() {
      _currentSubmenu = null;
      _currentParent = null;
    });
  }

  Widget _buildButtonContent() {
    final height = _getHeight();

    return Container(
      constraints: BoxConstraints(
        minHeight: height,
      ),
      padding: _getPadding(),
      width: widget.autosize ? null : double.infinity,
      decoration: BoxDecoration(
        color: _getTypeColor(),
        borderRadius: BorderRadius.circular(widget.borderRadius),
        border: _getBorder(),
      ),
      child: Row(
        mainAxisSize: widget.autosize ? MainAxisSize.min : MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (widget.leftIcon != null)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Icon(
                widget.leftIcon,
                color: _getTextColor(),
                size: _getIconSize(),
              ),
            ),
          if (widget.title != null)
            Flexible(
              child: Text(
                widget.title!,
                style: TextStyle(
                  color: _getTextColor(),
                  fontSize: _getFontSize(),
                ),
                textAlign: widget.textAlign,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),
          if (widget.rightIcon != null)
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Icon(
                widget.rightIcon,
                color: _getTextColor(),
                size: _getIconSize(),
              ),
            ),
          if (widget.popupIcon != null)
            Padding(
              padding: widget.title != null ||
                      widget.leftIcon != null ||
                      widget.rightIcon != null
                  ? const EdgeInsets.only(left: 8)
                  : EdgeInsets.zero,
              child: Icon(
                widget.popupIcon,
                color: _getTextColor(),
                size: _getIconSize(),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.disabled) {
      return _buildButtonContent();
    }

    return PopupMenuButton<T>(
      enabled: !widget.disabled,
      onSelected: widget.onSelected,
      onCanceled: () {
        // Limpar overlays do desktop
        _removeSubmenuOverlay();
        _submenuTimer?.cancel();

        // Reset to main menu when popup is canceled/closed (para mobile)
        if (_currentSubmenu != null) {
          setState(() {
            _currentSubmenu = null;
            _currentParent = null;
          });
        }
      },
      position: widget.position,
      tooltip: widget.tooltip,
      color: widget.popupBackgroundColor,
      elevation: widget.elevation,
      shape: widget.shape,
      padding: widget.popupPadding ?? EdgeInsets.zero,
      itemBuilder: (context) => _buildMenuItems(),
      child: _buildButtonContent(),
    );
  }
}

// Exemplo de uso:
/*
ModPopupButton<String>(
  title: 'Ações',
  leftIcon: Icons.menu,
  popupIcon: Icons.arrow_drop_down,
  type: ModButtonType.primary,
  size: ModButtonSize.md,
  borderRadius: 8.0,
  position: PopupMenuPosition.over,
  items: [
    ModPopupMenuItem<String>(
      value: 'edit',
      text: 'Editar',
      icon: Icons.edit,
    ),
    ModPopupMenuItem<String>(
      value: 'delete',
      text: 'Excluir',
      icon: Icons.delete,
      textColor: Colors.red,
      iconColor: Colors.red,
    ),
    ModPopupMenuItem<String>(
      value: 'share',
      text: 'Compartilhar',
      icon: Icons.share,
    ),
    ModPopupMenuItem<String>(
      value: 'disabled',
      text: 'Item Desabilitado',
      icon: Icons.block,
      enabled: false,
    ),
  ],
  onSelected: (value) {
    switch (value) {
      case 'edit':
        print('Editar selecionado');
        break;
      case 'delete':
        print('Excluir selecionado');
        break;
      case 'share':
        print('Compartilhar selecionado');
        break;
    }
  },
)

// Exemplo com visual customizado:
ModPopupButton<int>(
  popupIcon: Icons.more_vert,
  type: ModButtonType.custom,
  backgroundColor: Colors.green,
  textColor: Colors.white,
  size: ModButtonSize.sm,
  borderRadius: 20.0,
  items: [
    ModPopupMenuItem<int>(
      value: 1,
      text: 'Opção 1',
      icon: Icons.star,
    ),
    ModPopupMenuItem<int>(
      value: 2,
      child: Row(
        children: [
          Icon(Icons.favorite, color: Colors.red),
          SizedBox(width: 8),
          Text('Custom Widget'),
        ],
      ),
    ),
  ],
  onSelected: (value) {
    print('Selecionado: $value');
  },
)

// Exemplo com Submenus (Comportamento adaptativo):
//
// - Desktop/Web: Mouse hover abre submenus laterais (estilo Windows)
// - Mobile/Tablet: Navegação interna com botão voltar
//
ModPopupButton<String>(
  title: 'Configurações',
  leftIcon: Icons.settings,
  popupIcon: Icons.arrow_drop_down,
  type: ModButtonType.secondary,

  // Customizações de fontes e espaçamentos (opcionais)
  menuFontSize: 15,           // Tamanho da fonte dos itens do menu principal
  submenuFontSize: 14,        // Tamanho da fonte dos itens do submenu
  menuItemPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),      // Padding dos itens do menu
  submenuItemPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),  // Padding dos itens do submenu
  iconTextSpacing: 10,        // Espaçamento entre ícone e texto
  submenuOffset: 2,           // Distância entre menu principal e submenu (desktop)

  items: [
    ModPopupMenuItem<String>(
      value: 'perfil',
      text: 'Perfil',
      icon: Icons.person,
      submenu: [
        ModPopupMenuItem<String>(
          value: 'edit_profile',
          text: 'Editar Perfil',
          icon: Icons.edit,
        ),
        ModPopupMenuItem<String>(
          value: 'change_password',
          text: 'Alterar Senha',
          icon: Icons.lock,
        ),
        ModPopupMenuItem<String>(
          value: 'privacy',
          text: 'Privacidade',
          icon: Icons.privacy_tip,
        ),
      ],
    ),
    ModPopupMenuItem<String>(
      value: 'tema',
      text: 'Tema',
      icon: Icons.palette,
      submenu: [
        ModPopupMenuItem<String>(
          value: 'light_theme',
          text: 'Tema Claro',
          icon: Icons.light_mode,
        ),
        ModPopupMenuItem<String>(
          value: 'dark_theme',
          text: 'Tema Escuro',
          icon: Icons.dark_mode,
        ),
        ModPopupMenuItem<String>(
          value: 'auto_theme',
          text: 'Automático',
          icon: Icons.auto_mode,
        ),
      ],
    ),
    ModPopupMenuItem<String>(
      value: 'idioma',
      text: 'Idioma',
      icon: Icons.language,
      submenu: [
        ModPopupMenuItem<String>(
          value: 'pt_br',
          text: 'Português',
          icon: Icons.flag,
        ),
        ModPopupMenuItem<String>(
          value: 'en_us',
          text: 'English',
          icon: Icons.flag,
        ),
        ModPopupMenuItem<String>(
          value: 'es_es',
          text: 'Español',
          icon: Icons.flag,
        ),
      ],
    ),
    ModPopupMenuItem<String>(
      value: 'logout',
      text: 'Sair',
      icon: Icons.logout,
      textColor: Colors.red,
      iconColor: Colors.red,
    ),
  ],
  onSelected: (value) {
    print('Selecionado: $value');
  },
)
*/
