import 'package:flutter/material.dart';

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
    this.borderRadius = 8.0,
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
      duration: const Duration(milliseconds: 300),
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
    switch (widget.type) {
      case ToastType.success:
        return Colors.green.shade600;
      case ToastType.error:
        return Colors.red.shade600;
      case ToastType.warning:
        return Colors.orange.shade600;
      case ToastType.info:
        return Colors.blue.shade600;
      case ToastType.custom:
        return Theme.of(context).colorScheme.surface;
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
    if (widget.type == ToastType.custom) {
      return Theme.of(context).textTheme.bodyMedium?.color ?? Colors.black;
    }
    return Colors.white;
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(widget.borderRadius),
                boxShadow: [
                  widget.shadow ??
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
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
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (widget.title != null) ...[
                          Text(
                            widget.title!,
                            style: TextStyle(
                              color: textColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                        ],
                        Text(
                          widget.message,
                          style: TextStyle(
                            color: textColor,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (widget.showCloseButton) ...[
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: _dismiss,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        child: Icon(
                          Icons.close,
                          color: textColor.withOpacity(0.7),
                          size: 18,
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