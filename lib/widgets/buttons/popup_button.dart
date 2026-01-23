import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mod_layout_one/themes/mod_semantic_colors.dart';
import 'package:mod_layout_one/themes/mod_tokens.dart';

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

  // Customizacoes de fontes e espacamentos (todas opcionais)
  final double? menuFontSize; // Tamanho da fonte dos itens do menu principal
  final double? submenuFontSize; // Tamanho da fonte dos itens do submenu
  final EdgeInsets? menuItemPadding; // Padding dos itens do menu principal
  final EdgeInsets? submenuItemPadding; // Padding dos itens do submenu
  final double? iconTextSpacing; // Espacamento entre icone e texto
  final double? submenuOffset; // Distancia entre menu e submenu (desktop)

  const ModPopupButton({
    super.key,
    this.title,
    this.leftIcon,
    this.rightIcon,
    this.popupIcon,
    this.borderRadius = ModTokens.radiusSm,
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

  // Detectar se e desktop/web vs mobile/tablet
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

    // Usar offset customizado ou padrao
    final offset = widget.submenuOffset ?? ModTokens.space4;

    // Calcular posicao do submenu baseado na posicao do item, nao do botao
    double submenuLeft = itemPosition.dx + itemBox.size.width + offset;

    // Se nao cabe a direita, posicionar a esquerda
    const submenuWidth = 200.0;
    if (submenuLeft + submenuWidth > screenSize.width) {
      submenuLeft = itemPosition.dx - submenuWidth - offset;
    }

    _submenuOverlay = OverlayEntry(
      builder: (context) => Positioned(
        left: submenuLeft,
        top: itemPosition.dy,
        child: Material(
          elevation: widget.elevation ?? ModTokens.elevationHigh,
          color: widget.popupBackgroundColor ?? Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(ModTokens.radiusSm),
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
    final theme = Theme.of(context);
    final semanticColors = theme.extension<ModSemanticColors>()
        ?? ModSemanticColors.defaultLight;

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
                  color: item.iconColor ?? (item.enabled ? null : semanticColors.disabled),
                ),
                SizedBox(width: widget.iconTextSpacing ?? ModTokens.space8),
              ],
              if (item.text != null)
                Text(
                  item.text!,
                  style: TextStyle(
                    color:
                        item.textColor ?? (item.enabled ? null : semanticColors.disabled),
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
    _submenuTimer = Timer(ModTokens.durationStandard, () {
      _removeSubmenuOverlay();
    });
  }

  void _cancelSubmenuTimer() {
    _submenuTimer?.cancel();
  }

  double _getHeight() {
    switch (widget.size) {
      case ModButtonSize.lg:
        return ModTokens.buttonHeightLg;
      case ModButtonSize.md:
        return ModTokens.buttonHeightMd;
      case ModButtonSize.sm:
        return ModTokens.buttonHeightSm;
      case ModButtonSize.xs:
        return ModTokens.buttonHeightXs;
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
        return ModTokens.iconSizeLg;
      case ModButtonSize.md:
        return ModTokens.iconSizeMd;
      case ModButtonSize.sm:
        return ModTokens.iconSizeSm;
      case ModButtonSize.xs:
        return ModTokens.iconSizeXs;
    }
  }

  double _getFontSize() {
    switch (widget.size) {
      case ModButtonSize.lg:
        return ModTokens.fontSizeLg;
      case ModButtonSize.md:
        return ModTokens.fontSizeBase;
      case ModButtonSize.sm:
        return ModTokens.fontSizeMd;
      case ModButtonSize.xs:
        return ModTokens.fontSizeSm;
    }
  }

  Color _getTypeColor() {
    final theme = Theme.of(context);
    final semanticColors = theme.extension<ModSemanticColors>()
        ?? ModSemanticColors.defaultLight;

    if (widget.disabled) {
      return semanticColors.disabledLight;
    }
    switch (widget.type) {
      case ModButtonType.none:
        return Colors.transparent;
      case ModButtonType.primary:
        return theme.colorScheme.primary;
      case ModButtonType.secondary:
        return theme.colorScheme.secondary;
      case ModButtonType.success:
        return semanticColors.success;
      case ModButtonType.info:
        return semanticColors.info;
      case ModButtonType.warning:
        return semanticColors.warning;
      case ModButtonType.danger:
        return theme.colorScheme.error;
      case ModButtonType.dark:
        return theme.colorScheme.surface;
      case ModButtonType.defaultType:
        return theme.colorScheme.surfaceContainerHighest;
      case ModButtonType.custom:
        return widget.backgroundColor ?? theme.colorScheme.surfaceContainerHighest;
    }
  }

  Color _getBorderColor() {
    final theme = Theme.of(context);
    final semanticColors = theme.extension<ModSemanticColors>()
        ?? ModSemanticColors.defaultLight;

    if (widget.disabled) {
      return semanticColors.disabledLight;
    }
    switch (widget.borderColor) {
      case ModButtonType.none:
        return Colors.transparent;
      case ModButtonType.primary:
        return theme.colorScheme.primary;
      case ModButtonType.secondary:
        return theme.colorScheme.secondary;
      case ModButtonType.success:
        return semanticColors.success;
      case ModButtonType.info:
        return semanticColors.info;
      case ModButtonType.warning:
        return semanticColors.warning;
      case ModButtonType.danger:
        return theme.colorScheme.error;
      case ModButtonType.dark:
        return theme.colorScheme.surface;
      case ModButtonType.defaultType:
        return theme.colorScheme.surfaceContainerHighest;
      case ModButtonType.custom:
        return widget.backgroundColor ?? theme.colorScheme.surfaceContainerHighest;
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
    final theme = Theme.of(context);
    final semanticColors = theme.extension<ModSemanticColors>()
        ?? ModSemanticColors.defaultLight;

    if (widget.disabled) {
      return semanticColors.disabled;
    }
    if (widget.textColor != null) {
      return widget.textColor!;
    }
    if (widget.type == ModButtonType.none) {
      return _getBorderColor();
    }
    if (widget.type == ModButtonType.defaultType) {
      return theme.colorScheme.onSurface;
    }
    return theme.colorScheme.onPrimary;
  }

  List<PopupMenuEntry<T>> _buildMenuItems() {
    if (_isDesktop) {
      return _buildDesktopMenuItems();
    } else {
      return _buildMobileMenuItems();
    }
  }

  List<PopupMenuEntry<T>> _buildDesktopMenuItems() {
    final theme = Theme.of(context);
    final semanticColors = theme.extension<ModSemanticColors>()
        ?? ModSemanticColors.defaultLight;

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
                color: item.iconColor ?? (item.enabled ? null : semanticColors.disabled),
              ),
              SizedBox(width: widget.iconTextSpacing ?? ModTokens.space8),
            ],
            if (item.text != null)
              Expanded(
                child: Text(
                  item.text!,
                  style: TextStyle(
                    color:
                        item.textColor ?? (item.enabled ? null : semanticColors.disabled),
                    fontSize: widget.menuFontSize ?? _getFontSize(),
                  ),
                ),
              ),
            if (item.submenu != null) ...[
              SizedBox(width: widget.iconTextSpacing ?? ModTokens.space8),
              Icon(
                Icons.arrow_right,
                size: _getIconSize() - 4,
                color: item.enabled ? theme.iconTheme.color?.withValues(alpha: 0.6) : semanticColors.disabled,
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
    final theme = Theme.of(context);
    final semanticColors = theme.extension<ModSemanticColors>()
        ?? ModSemanticColors.defaultLight;

    // Para mobile: navegacao interna com botao voltar
    final items = _currentSubmenu ?? widget.items;
    final menuItems = <PopupMenuEntry<T>>[];

    // Adicionar botao "Voltar" se estamos em um submenu
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
                color: theme.iconTheme.color?.withValues(alpha: 0.6),
              ),
              const SizedBox(width: ModTokens.space8),
              Text(
                'Voltar',
                style: TextStyle(
                  color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.6),
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
              padding: const EdgeInsets.symmetric(vertical: ModTokens.space4),
              child: Text(
                _currentParent!.text!,
                style: TextStyle(
                  fontSize: _getFontSize() - 1,
                  fontWeight: FontWeight.bold,
                  color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
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
                  color: item.iconColor ?? (item.enabled ? null : semanticColors.disabled),
                ),
                SizedBox(width: widget.iconTextSpacing ?? ModTokens.space8),
              ],
              if (item.text != null)
                Expanded(
                  child: Text(
                    item.text!,
                    style: TextStyle(
                      color:
                          item.textColor ?? (item.enabled ? null : semanticColors.disabled),
                      fontSize: widget.menuFontSize ?? _getFontSize(),
                    ),
                  ),
                ),
              if (item.submenu != null) ...[
                SizedBox(width: widget.iconTextSpacing ?? ModTokens.space8),
                Icon(
                  Icons.arrow_right,
                  size: _getIconSize() - 4,
                  color: item.enabled ? theme.iconTheme.color?.withValues(alpha: 0.6) : semanticColors.disabled,
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
              padding: const EdgeInsets.only(right: ModTokens.space8),
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
              padding: const EdgeInsets.only(left: ModTokens.space8),
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
                  ? const EdgeInsets.only(left: ModTokens.space8)
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
