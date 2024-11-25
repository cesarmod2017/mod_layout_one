import 'package:flutter/material.dart';

enum ModButtonType {
  none,
  primary,
  secondary,
  success,
  info,
  warning,
  danger,
  dark,
  defaultType
}

enum ModBorderType { none, solid, dashed, dotted }

enum ModButtonSize { lg, md, sm, xs }

class ModButton extends StatefulWidget {
  final String? title;
  final IconData? leftIcon;
  final IconData? rightIcon;
  final IconData? loadingIcon;
  final double borderRadius;
  final ModButtonType type;
  final ModBorderType borderType;
  final ModButtonSize size;
  final Future<void> Function()? onPressed;
  final String? loadingText;
  final ModButtonType borderColor;
  final Color? textColor;
  final bool disabled;
  final bool autosize;
  final TextAlign textAlign;

  const ModButton({
    super.key,
    this.title,
    this.leftIcon,
    this.rightIcon,
    this.loadingIcon = Icons.refresh,
    this.borderRadius = 4.0,
    this.type = ModButtonType.defaultType,
    this.borderType = ModBorderType.solid,
    this.size = ModButtonSize.md,
    required this.onPressed,
    this.loadingText,
    this.borderColor = ModButtonType.defaultType,
    this.textColor,
    this.disabled = false,
    this.autosize = true,
    this.textAlign = TextAlign.center,
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
      case ModBorderType.dashed:
        borderStyle =
            BorderStyle.solid; // Flutter doesn't support dashed directly
        break;
      case ModBorderType.dotted:
        borderStyle =
            BorderStyle.solid; // Flutter doesn't support dotted directly
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

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: (widget.disabled || _isLoading)
            ? null
            : () async {
                if (widget.onPressed != null) {
                  setState(() => _isLoading = true);
                  try {
                    await widget.onPressed!();
                  } finally {
                    if (mounted) {
                      setState(() => _isLoading = false);
                    }
                  }
                }
              },
        child: Container(
          padding: _getPadding(),
          width: widget.autosize ? null : double.infinity,
          decoration: BoxDecoration(
            color: _getTypeColor(),
            borderRadius: BorderRadius.circular(widget.borderRadius),
            border: _getBorder(),
          ),
          child: Row(
            mainAxisSize: widget.autosize ? MainAxisSize.min : MainAxisSize.max,
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
                Text(
                  widget.loadingText!,
                  style: TextStyle(
                    color: _getTextColor(),
                    fontSize: _getFontSize(),
                  ),
                  textAlign: widget.textAlign,
                )
              else if (widget.title != null)
                Text(
                  widget.title!,
                  style: TextStyle(
                    color: _getTextColor(),
                    fontSize: _getFontSize(),
                  ),
                  textAlign: widget.textAlign,
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
          ),
        ),
      ),
    );
  }
}
