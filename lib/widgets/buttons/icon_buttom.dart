import 'package:flutter/material.dart';

class ModIconButton extends StatefulWidget {
  final IconData icon;
  final Future<void> Function() onPressed;
  final IconData loadingIcon;
  final double? iconSize;
  final VisualDensity? visualDensity;
  final EdgeInsetsGeometry? padding;
  final AlignmentGeometry? alignment;
  final double? splashRadius;
  final Color? color;
  final Color? focusColor;
  final Color? hoverColor;
  final Color? highlightColor;
  final Color? splashColor;
  final Color? disabledColor;
  final MouseCursor? mouseCursor;
  final FocusNode? focusNode;
  final bool autofocus;
  final String? tooltip;
  final bool? enableFeedback;
  final BoxConstraints? constraints;
  final ButtonStyle? style;
  final bool? isSelected;
  final IconData? selectedIcon;

  const ModIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.loadingIcon = Icons.autorenew,
    this.iconSize,
    this.visualDensity,
    this.padding,
    this.alignment,
    this.splashRadius,
    this.color,
    this.focusColor,
    this.hoverColor,
    this.highlightColor,
    this.splashColor,
    this.disabledColor,
    this.mouseCursor,
    this.focusNode,
    this.autofocus = false,
    this.tooltip,
    this.enableFeedback,
    this.constraints,
    this.style,
    this.isSelected,
    this.selectedIcon,
  });

  @override
  ModIconButtonState createState() => ModIconButtonState();
}

class ModIconButtonState extends State<ModIconButton>
    with SingleTickerProviderStateMixin {
  bool _isLoading = false;
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat();
    _rotationAnimation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handlePress() async {
    setState(() {
      _isLoading = true;
    });
    try {
      await widget.onPressed();
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: _isLoading
          ? RotationTransition(
              turns: _rotationAnimation,
              child: Icon(
                widget.loadingIcon,
                color: widget.color ?? Colors.grey,
                size: widget.iconSize,
              ),
            )
          : Icon(
              widget.icon,
              color: widget.color,
              size: widget.iconSize,
            ),
      onPressed: _isLoading ? null : _handlePress,
      iconSize: widget.iconSize,
      visualDensity: widget.visualDensity,
      padding: widget.padding,
      alignment: widget.alignment,
      splashRadius: widget.splashRadius,
      focusColor: widget.focusColor,
      hoverColor: widget.hoverColor,
      highlightColor: widget.highlightColor,
      splashColor: widget.splashColor,
      disabledColor: widget.disabledColor,
      mouseCursor: widget.mouseCursor,
      focusNode: widget.focusNode,
      autofocus: widget.autofocus,
      tooltip: widget.tooltip,
      enableFeedback: widget.enableFeedback,
      constraints: widget.constraints,
      style: widget.style,
      isSelected: widget.isSelected,
      selectedIcon:
          widget.selectedIcon != null ? Icon(widget.selectedIcon) : null,
    );
  }
}
