import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mod_layout_one/themes/mod_semantic_colors.dart';

enum ModButtonType {
  none,
  primary,
  secondary,
  success,
  info,
  warning,
  danger,
  dark,
  defaultType,
  custom,
}

enum ModBorderType { none, solid }

enum ModButtonSize { lg, md, sm, xs }

enum ModIconCenterAlign { top, bottom }

class ModButton extends StatefulWidget {
  final String? title;
  final IconData? leftIcon;
  final IconData? rightIcon;
  final IconData? centerIcon;
  final IconData? loadingIcon;
  final double borderRadius;
  final ModButtonType type;
  final ModBorderType borderType;
  final ModButtonSize size;
  final Future<void> Function()? onPressed;
  final String? loadingText;
  final ModButtonType borderColor;
  final Color? textColor;
  final Color? backgroundColor;
  final bool disabled;
  final bool autosize;
  final TextAlign textAlign;
  final ModIconCenterAlign iconCenterAlign;
  final double? fontSize;

  const ModButton({
    super.key,
    this.title,
    this.leftIcon,
    this.rightIcon,
    this.centerIcon,
    this.loadingIcon = Icons.refresh,
    this.borderRadius = 4.0,
    this.type = ModButtonType.defaultType,
    this.borderType = ModBorderType.solid,
    this.size = ModButtonSize.md,
    required this.onPressed,
    this.loadingText,
    this.borderColor = ModButtonType.defaultType,
    this.textColor,
    this.backgroundColor,
    this.disabled = false,
    this.autosize = true,
    this.textAlign = TextAlign.center,
    this.iconCenterAlign = ModIconCenterAlign.top,
    this.fontSize,
  });

  @override
  State<ModButton> createState() => _ModButtonState();
}

class _ModButtonState extends State<ModButton>
    with SingleTickerProviderStateMixin {
  bool _isLoading = false;
  late AnimationController _animationController;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.linear,
    ));
    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
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
    if (widget.fontSize != null) {
      return widget.fontSize!;
    }
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
    final theme = Get.theme;
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
    final theme = Get.theme;
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
    final theme = Get.theme;
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
    // Use onPrimary for colored buttons, onSurface for default type
    if (widget.type == ModButtonType.defaultType) {
      return theme.colorScheme.onSurface;
    }
    return theme.colorScheme.onPrimary;
  }

  Widget _buildCenterIconLayout() {
    final iconWidget = Icon(
      widget.centerIcon,
      color: _getTextColor(),
      size: _getIconSize(),
    );

    final titleWidget = widget.title != null
        ? Text(
            widget.title!,
            style: TextStyle(
              color: _getTextColor(),
              fontSize: _getFontSize(),
            ),
            textAlign: widget.textAlign,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          )
        : null;

    final children = <Widget>[];

    if (widget.iconCenterAlign == ModIconCenterAlign.top) {
      children.add(iconWidget);
      if (titleWidget != null) {
        children.add(const SizedBox(height: 4));
        children.add(titleWidget);
      }
    } else {
      if (titleWidget != null) {
        children.add(titleWidget);
        children.add(const SizedBox(height: 4));
      }
      children.add(iconWidget);
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: children,
    );
  }

  Widget _buildDefaultLayout() {
    return Row(
      mainAxisSize: widget.autosize ? MainAxisSize.min : MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (widget.leftIcon != null && !_isLoading)
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Icon(
              widget.leftIcon,
              color: _getTextColor(),
              size: _getIconSize(),
            ),
          ),
        if (_isLoading)
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: RotationTransition(
              turns: _rotationAnimation,
              child: Icon(
                widget.loadingIcon,
                color: _getTextColor(),
                size: _getIconSize(),
              ),
            ),
          ),
        if (_isLoading && widget.loadingText != null)
          Flexible(
            child: Text(
              widget.loadingText!,
              style: TextStyle(
                color: _getTextColor(),
                fontSize: _getFontSize(),
              ),
              textAlign: widget.textAlign,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          )
        else if (widget.title != null)
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
        if (widget.rightIcon != null && !_isLoading)
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Icon(
              widget.rightIcon,
              color: _getTextColor(),
              size: _getIconSize(),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = _getHeight();

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: (widget.disabled || _isLoading)
            ? null
            : () async {
                if (widget.onPressed != null) {
                  if (mounted) setState(() => _isLoading = true);
                  try {
                    await widget.onPressed!();
                  } finally {
                    if (mounted) {
                      if (mounted) setState(() => _isLoading = false);
                    }
                  }
                }
              },
        child: Container(
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
          child: widget.centerIcon != null
              ? _buildCenterIconLayout()
              : _buildDefaultLayout(),
        ),
      ),
    );
  }
}
