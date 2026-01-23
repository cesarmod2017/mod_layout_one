import 'package:flutter/material.dart';
import 'package:mod_layout_one/themes/mod_semantic_colors.dart';
import 'package:mod_layout_one/themes/mod_tokens.dart';

enum ToastPosition {
  top,
  topLeft,
  topCenter,
  topRight,
  bottom,
  bottomLeft,
  bottomCenter,
  bottomRight,
  left,
  leftCenter,
  right,
  rightCenter,
  center,
}

enum ToastType {
  success,
  error,
  warning,
  info,
  custom,
}

class ModToast extends StatefulWidget {
  final String? title;
  final String message;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? iconColor;
  final Duration duration;
  final ToastPosition position;
  final bool showCloseButton;
  final VoidCallback? onClose;
  final EdgeInsetsGeometry margin;
  final double borderRadius;
  final double? width;
  final double? height;
  final ToastType type;
  final BoxShadow? shadow;
  final double? maxWidth;

  const ModToast({
    super.key,
    this.title,
    required this.message,
    this.icon,
    this.backgroundColor,
    this.textColor,
    this.iconColor,
    this.duration = const Duration(seconds: 4),
    this.position = ToastPosition.topCenter,
    this.showCloseButton = true,
    this.onClose,
    this.margin = const EdgeInsets.all(16),
    this.borderRadius = ModTokens.radiusMd,
    this.width,
    this.height,
    this.type = ToastType.custom,
    this.shadow,
    this.maxWidth,
  });

  @override
  State<ModToast> createState() => _ModToastState();
}

class _ModToastState extends State<ModToast>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: ModTokens.durationStandard,
      vsync: this,
    );

    _slideAnimation = Tween<double>(
      begin: _getSlideBegin(),
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _animationController.forward();

    // Auto dismiss after duration
    Future.delayed(widget.duration, () {
      if (mounted) {
        _dismiss();
      }
    });
  }

  double _getSlideBegin() {
    switch (widget.position) {
      case ToastPosition.top:
      case ToastPosition.topLeft:
      case ToastPosition.topCenter:
      case ToastPosition.topRight:
        return -1.0;
      case ToastPosition.bottom:
      case ToastPosition.bottomLeft:
      case ToastPosition.bottomCenter:
      case ToastPosition.bottomRight:
        return 1.0;
      case ToastPosition.left:
      case ToastPosition.leftCenter:
        return -1.0;
      case ToastPosition.right:
      case ToastPosition.rightCenter:
        return 1.0;
      case ToastPosition.center:
        return 0.0;
    }
  }

  void _dismiss() {
    _animationController.reverse().then((_) {
      if (mounted) {
        widget.onClose?.call();
      }
    });
  }

  Color _getDefaultBackgroundColor(BuildContext context) {
    final theme = Theme.of(context);
    final semanticColors = theme.extension<ModSemanticColors>()
        ?? ModSemanticColors.defaultLight;

    switch (widget.type) {
      case ToastType.success:
        return semanticColors.success;
      case ToastType.error:
        return theme.colorScheme.error;
      case ToastType.warning:
        return semanticColors.warning;
      case ToastType.info:
        return semanticColors.info;
      case ToastType.custom:
        return theme.colorScheme.surface;
    }
  }

  IconData _getDefaultIcon() {
    switch (widget.type) {
      case ToastType.success:
        return Icons.check_circle;
      case ToastType.error:
        return Icons.error;
      case ToastType.warning:
        return Icons.warning;
      case ToastType.info:
        return Icons.info;
      case ToastType.custom:
        return Icons.notifications;
    }
  }

  Color _getDefaultTextColor(BuildContext context) {
    final theme = Theme.of(context);
    if (widget.type == ToastType.custom) {
      return theme.colorScheme.onSurface;
    }
    // For colored backgrounds, use white or onPrimary
    return theme.colorScheme.onPrimary;
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final backgroundColor = widget.backgroundColor ?? _getDefaultBackgroundColor(context);
    final textColor = widget.textColor ?? _getDefaultTextColor(context);
    final iconColor = widget.iconColor ?? textColor;
    final icon = widget.icon ?? _getDefaultIcon();

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: Transform.translate(
            offset: _getTransformOffset(),
            child: Container(
              width: widget.width,
              height: widget.height,
              margin: widget.margin,
              padding: const EdgeInsets.all(ModTokens.space12),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(widget.borderRadius),
                boxShadow: [
                  widget.shadow ??
                      BoxShadow(
                        color: theme.shadowColor.withValues(alpha: ModTokens.opacityLight),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    icon,
                    color: iconColor,
                    size: ModTokens.iconSizeLg,
                  ),
                  const SizedBox(width: ModTokens.space12),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (widget.title != null) ...[
                          Text(
                            widget.title!,
                            style: theme.textTheme.titleSmall?.copyWith(
                              color: textColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: ModTokens.space4),
                        ],
                        Text(
                          widget.message,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: textColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (widget.showCloseButton) ...[
                    const SizedBox(width: ModTokens.space8),
                    GestureDetector(
                      onTap: _dismiss,
                      child: Container(
                        padding: const EdgeInsets.all(ModTokens.space4),
                        child: Icon(
                          Icons.close,
                          color: textColor.withValues(alpha: ModTokens.opacityHigh),
                          size: ModTokens.iconSizeSm,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Offset _getTransformOffset() {
    double dx = 0;
    double dy = 0;

    switch (widget.position) {
      case ToastPosition.top:
      case ToastPosition.topCenter:
        dy = _slideAnimation.value * 50;
        break;
      case ToastPosition.topLeft:
        dx = _slideAnimation.value * 50;
        dy = _slideAnimation.value * 50;
        break;
      case ToastPosition.topRight:
        dx = _slideAnimation.value * -50;
        dy = _slideAnimation.value * 50;
        break;
      case ToastPosition.bottom:
      case ToastPosition.bottomCenter:
        dy = _slideAnimation.value * -50;
        break;
      case ToastPosition.bottomLeft:
        dx = _slideAnimation.value * 50;
        dy = _slideAnimation.value * -50;
        break;
      case ToastPosition.bottomRight:
        dx = _slideAnimation.value * -50;
        dy = _slideAnimation.value * -50;
        break;
      case ToastPosition.left:
      case ToastPosition.leftCenter:
        dx = _slideAnimation.value * 50;
        break;
      case ToastPosition.right:
      case ToastPosition.rightCenter:
        dx = _slideAnimation.value * -50;
        break;
      case ToastPosition.center:
        break;
    }

    return Offset(dx, dy);
  }
}
