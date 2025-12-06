import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'mod_progress_controller.dart';

/// Position options for the progress widget
enum ModProgressPosition {
  topLeft,
  topCenter,
  topRight,
  bottomLeft,
  bottomCenter,
  bottomRight,
}

/// Type of progress indicator
enum ModProgressType {
  circular,
  linear,
}

/// Configuration for the progress widget appearance
class ModProgressConfig {
  /// Position on screen
  final ModProgressPosition position;

  /// Type of progress indicator (circular or linear)
  final ModProgressType type;

  /// Title text (optional)
  final String? title;

  /// Subtitle/message text (optional)
  final String? subtitle;

  /// Initial progress value (0.0 to 1.0), null for indeterminate
  final double? initialProgress;

  /// Background color of the container
  final Color? backgroundColor;

  /// Border color
  final Color? borderColor;

  /// Border width
  final double borderWidth;

  /// Border radius
  final double borderRadius;

  /// Progress indicator color
  final Color? progressColor;

  /// Progress background color (track color)
  final Color? progressBackgroundColor;

  /// Text color for title
  final Color? titleColor;

  /// Text color for subtitle
  final Color? subtitleColor;

  /// Title font size
  final double titleFontSize;

  /// Subtitle font size
  final double subtitleFontSize;

  /// Width of the progress container
  final double? width;

  /// Height of the progress container (for linear type)
  final double? height;

  /// Size of circular progress indicator
  final double circularSize;

  /// Stroke width for circular progress
  final double circularStrokeWidth;

  /// Height of linear progress bar
  final double linearHeight;

  /// Padding inside the container
  final EdgeInsets padding;

  /// Margin from screen edges
  final EdgeInsets margin;

  /// Whether to show close button
  final bool showCloseButton;

  /// Whether clicking outside dismisses the progress
  final bool barrierDismissible;

  /// Whether to show barrier (dim background)
  final bool showBarrier;

  /// Barrier color when showBarrier is true
  final Color barrierColor;

  /// Box shadow for the container
  final List<BoxShadow>? boxShadow;

  /// Icon to show (optional, for completed/error states)
  final IconData? icon;

  /// Icon color
  final Color? iconColor;

  /// Icon size
  final double iconSize;

  const ModProgressConfig({
    this.position = ModProgressPosition.topRight,
    this.type = ModProgressType.circular,
    this.title,
    this.subtitle,
    this.initialProgress,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth = 1.0,
    this.borderRadius = 8.0,
    this.progressColor,
    this.progressBackgroundColor,
    this.titleColor,
    this.subtitleColor,
    this.titleFontSize = 14.0,
    this.subtitleFontSize = 12.0,
    this.width = 300.0,
    this.height,
    this.circularSize = 24.0,
    this.circularStrokeWidth = 3.0,
    this.linearHeight = 4.0,
    this.padding = const EdgeInsets.all(16.0),
    this.margin = const EdgeInsets.all(16.0),
    this.showCloseButton = true,
    this.barrierDismissible = false,
    this.showBarrier = false,
    this.barrierColor = Colors.black26,
    this.boxShadow,
    this.icon,
    this.iconColor,
    this.iconSize = 20.0,
  });

  /// Creates a copy with modified values
  ModProgressConfig copyWith({
    ModProgressPosition? position,
    ModProgressType? type,
    String? title,
    String? subtitle,
    double? initialProgress,
    Color? backgroundColor,
    Color? borderColor,
    double? borderWidth,
    double? borderRadius,
    Color? progressColor,
    Color? progressBackgroundColor,
    Color? titleColor,
    Color? subtitleColor,
    double? titleFontSize,
    double? subtitleFontSize,
    double? width,
    double? height,
    double? circularSize,
    double? circularStrokeWidth,
    double? linearHeight,
    EdgeInsets? padding,
    EdgeInsets? margin,
    bool? showCloseButton,
    bool? barrierDismissible,
    bool? showBarrier,
    Color? barrierColor,
    List<BoxShadow>? boxShadow,
    IconData? icon,
    Color? iconColor,
    double? iconSize,
  }) {
    return ModProgressConfig(
      position: position ?? this.position,
      type: type ?? this.type,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      initialProgress: initialProgress ?? this.initialProgress,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      borderColor: borderColor ?? this.borderColor,
      borderWidth: borderWidth ?? this.borderWidth,
      borderRadius: borderRadius ?? this.borderRadius,
      progressColor: progressColor ?? this.progressColor,
      progressBackgroundColor:
          progressBackgroundColor ?? this.progressBackgroundColor,
      titleColor: titleColor ?? this.titleColor,
      subtitleColor: subtitleColor ?? this.subtitleColor,
      titleFontSize: titleFontSize ?? this.titleFontSize,
      subtitleFontSize: subtitleFontSize ?? this.subtitleFontSize,
      width: width ?? this.width,
      height: height ?? this.height,
      circularSize: circularSize ?? this.circularSize,
      circularStrokeWidth: circularStrokeWidth ?? this.circularStrokeWidth,
      linearHeight: linearHeight ?? this.linearHeight,
      padding: padding ?? this.padding,
      margin: margin ?? this.margin,
      showCloseButton: showCloseButton ?? this.showCloseButton,
      barrierDismissible: barrierDismissible ?? this.barrierDismissible,
      showBarrier: showBarrier ?? this.showBarrier,
      barrierColor: barrierColor ?? this.barrierColor,
      boxShadow: boxShadow ?? this.boxShadow,
      icon: icon ?? this.icon,
      iconColor: iconColor ?? this.iconColor,
      iconSize: iconSize ?? this.iconSize,
    );
  }
}

/// A customizable progress widget that displays progress status
/// with support for real-time updates via GetX controller.
class ModProgress extends StatelessWidget {
  /// The controller managing the progress state
  final ModProgressController controller;

  /// Configuration for the widget appearance
  final ModProgressConfig config;

  /// Callback when close button is pressed
  final VoidCallback? onClose;

  const ModProgress({
    super.key,
    required this.controller,
    this.config = const ModProgressConfig(),
    this.onClose,
  });

  Alignment _getAlignment() {
    switch (config.position) {
      case ModProgressPosition.topLeft:
        return Alignment.topLeft;
      case ModProgressPosition.topCenter:
        return Alignment.topCenter;
      case ModProgressPosition.topRight:
        return Alignment.topRight;
      case ModProgressPosition.bottomLeft:
        return Alignment.bottomLeft;
      case ModProgressPosition.bottomCenter:
        return Alignment.bottomCenter;
      case ModProgressPosition.bottomRight:
        return Alignment.bottomRight;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Obx(() {
      if (!controller.isVisible.value) {
        return const SizedBox.shrink();
      }

      return _buildContent(context, theme);
    });
  }

  Widget _buildContent(BuildContext context, ThemeData theme) {
    final content = Container(
      width: config.width,
      height: config.height,
      margin: config.margin,
      padding: config.padding,
      decoration: BoxDecoration(
        color: config.backgroundColor ?? theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(config.borderRadius),
        border: config.borderColor != null || config.borderWidth > 0
            ? Border.all(
                color: config.borderColor ?? theme.dividerColor,
                width: config.borderWidth,
              )
            : null,
        boxShadow: config.boxShadow ??
            [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(theme),
          if (controller.title.value.isNotEmpty ||
              controller.subtitle.value.isNotEmpty)
            const SizedBox(height: 12),
          _buildProgressContent(theme),
        ],
      ),
    );

    if (config.showBarrier) {
      return GestureDetector(
        onTap: config.barrierDismissible ? _handleClose : null,
        child: Container(
          color: config.barrierColor,
          child: Align(
            alignment: _getAlignment(),
            child: GestureDetector(
              onTap: () {}, // Prevent tap through
              child: content,
            ),
          ),
        ),
      );
    }

    return Align(
      alignment: _getAlignment(),
      child: content,
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (config.icon != null) ...[
          Icon(
            config.icon,
            color: config.iconColor ?? theme.colorScheme.primary,
            size: config.iconSize,
          ),
          const SizedBox(width: 8),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (controller.title.value.isNotEmpty)
                Text(
                  controller.title.value,
                  style: TextStyle(
                    color: config.titleColor ?? theme.textTheme.titleMedium?.color,
                    fontSize: config.titleFontSize,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              if (controller.subtitle.value.isNotEmpty) ...[
                if (controller.title.value.isNotEmpty) const SizedBox(height: 4),
                Text(
                  controller.subtitle.value,
                  style: TextStyle(
                    color: _getSubtitleColor(theme),
                    fontSize: config.subtitleFontSize,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
        if (config.showCloseButton)
          GestureDetector(
            onTap: _handleClose,
            child: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Icon(
                Icons.close,
                size: 18,
                color: theme.iconTheme.color?.withValues(alpha: 0.6),
              ),
            ),
          ),
      ],
    );
  }

  Color _getSubtitleColor(ThemeData theme) {
    if (controller.hasError.value) {
      return Colors.red.shade600;
    }
    if (controller.isCompleted.value) {
      return Colors.green.shade600;
    }
    return config.subtitleColor ?? theme.textTheme.bodySmall?.color ?? Colors.grey;
  }

  Widget _buildProgressContent(ThemeData theme) {
    if (controller.isCompleted.value) {
      return _buildCompletedIndicator(theme);
    }

    if (controller.hasError.value) {
      return _buildErrorIndicator(theme);
    }

    return config.type == ModProgressType.circular
        ? _buildCircularProgress(theme)
        : _buildLinearProgress(theme);
  }

  Widget _buildCircularProgress(ThemeData theme) {
    final progress = controller.progress.value;
    final progressColor = config.progressColor ?? theme.colorScheme.primary;
    final bgColor = config.progressBackgroundColor ??
        progressColor.withValues(alpha: 0.2);

    return Row(
      children: [
        SizedBox(
          width: config.circularSize,
          height: config.circularSize,
          child: progress != null
              ? CircularProgressIndicator(
                  value: progress,
                  strokeWidth: config.circularStrokeWidth,
                  valueColor: AlwaysStoppedAnimation(progressColor),
                  backgroundColor: bgColor,
                )
              : CircularProgressIndicator(
                  strokeWidth: config.circularStrokeWidth,
                  valueColor: AlwaysStoppedAnimation(progressColor),
                ),
        ),
        if (progress != null) ...[
          const SizedBox(width: 12),
          Text(
            '${(progress * 100).toInt()}%',
            style: TextStyle(
              color: theme.textTheme.bodyMedium?.color,
              fontSize: config.subtitleFontSize,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildLinearProgress(ThemeData theme) {
    final progress = controller.progress.value;
    final progressColor = config.progressColor ?? theme.colorScheme.primary;
    final bgColor = config.progressBackgroundColor ??
        progressColor.withValues(alpha: 0.2);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(config.linearHeight / 2),
          child: SizedBox(
            height: config.linearHeight,
            child: progress != null
                ? LinearProgressIndicator(
                    value: progress,
                    valueColor: AlwaysStoppedAnimation(progressColor),
                    backgroundColor: bgColor,
                  )
                : LinearProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(progressColor),
                    backgroundColor: bgColor,
                  ),
          ),
        ),
        if (progress != null) ...[
          const SizedBox(height: 4),
          Text(
            '${(progress * 100).toInt()}%',
            style: TextStyle(
              color: theme.textTheme.bodySmall?.color,
              fontSize: config.subtitleFontSize - 2,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildCompletedIndicator(ThemeData theme) {
    return Row(
      children: [
        Icon(
          Icons.check_circle,
          color: Colors.green.shade600,
          size: config.circularSize,
        ),
        const SizedBox(width: 8),
        Text(
          '100%',
          style: TextStyle(
            color: Colors.green.shade600,
            fontSize: config.subtitleFontSize,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildErrorIndicator(ThemeData theme) {
    return Row(
      children: [
        Icon(
          Icons.error,
          color: Colors.red.shade600,
          size: config.circularSize,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            controller.errorMessage.value.isNotEmpty
                ? controller.errorMessage.value
                : 'Error',
            style: TextStyle(
              color: Colors.red.shade600,
              fontSize: config.subtitleFontSize,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  void _handleClose() {
    controller.close();
    onClose?.call();
  }
}
