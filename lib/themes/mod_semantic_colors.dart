import 'package:flutter/material.dart';

/// Theme extension for semantic colors used across ModLayoutOne components.
///
/// This extension provides semantic color tokens that adapt to the app's theme,
/// ensuring visual consistency and proper theming support.
///
/// ## Usage:
/// ```dart
/// // Access in widgets
/// final colors = Theme.of(context).extension<ModSemanticColors>()
///     ?? ModSemanticColors.defaultLight;
/// final successColor = colors.success;
///
/// // Or with GetX
/// final colors = Get.theme.extension<ModSemanticColors>()
///     ?? ModSemanticColors.defaultLight;
/// ```
///
/// ## Setup in consuming app:
/// ```dart
/// MaterialApp(
///   theme: ThemeData.light().copyWith(
///     extensions: [ModSemanticColors.defaultLight],
///   ),
///   darkTheme: ThemeData.dark().copyWith(
///     extensions: [ModSemanticColors.defaultDark],
///   ),
/// )
/// ```
class ModSemanticColors extends ThemeExtension<ModSemanticColors> {
  /// Success color - used for confirmations, positive feedback
  final Color success;

  /// Light variant of success color - used for backgrounds
  final Color successLight;

  /// Warning color - used for alerts, caution states
  final Color warning;

  /// Light variant of warning color - used for backgrounds
  final Color warningLight;

  /// Info color - used for informational messages
  final Color info;

  /// Light variant of info color - used for backgrounds
  final Color infoLight;

  /// Danger color - used for errors, destructive actions
  /// Note: For most cases, prefer using `Theme.colorScheme.error`
  final Color danger;

  /// Light variant of danger color - used for backgrounds
  final Color dangerLight;

  /// Default disabled state color
  final Color disabled;

  /// Light variant of disabled color
  final Color disabledLight;

  const ModSemanticColors({
    required this.success,
    required this.successLight,
    required this.warning,
    required this.warningLight,
    required this.info,
    required this.infoLight,
    required this.danger,
    required this.dangerLight,
    required this.disabled,
    required this.disabledLight,
  });

  /// Default semantic colors for light theme
  static const defaultLight = ModSemanticColors(
    success: Color(0xFF4CAF50),
    successLight: Color(0xFFE8F5E9),
    warning: Color(0xFFFF9800),
    warningLight: Color(0xFFFFF3E0),
    info: Color(0xFF03A9F4),
    infoLight: Color(0xFFE1F5FE),
    danger: Color(0xFFF44336),
    dangerLight: Color(0xFFFFEBEE),
    disabled: Color(0xFF9E9E9E),
    disabledLight: Color(0xFFE0E0E0),
  );

  /// Default semantic colors for dark theme
  static const defaultDark = ModSemanticColors(
    success: Color(0xFF81C784),
    successLight: Color(0xFF1B5E20),
    warning: Color(0xFFFFB74D),
    warningLight: Color(0xFFE65100),
    info: Color(0xFF4FC3F7),
    infoLight: Color(0xFF01579B),
    danger: Color(0xFFE57373),
    dangerLight: Color(0xFFB71C1C),
    disabled: Color(0xFF757575),
    disabledLight: Color(0xFF424242),
  );

  @override
  ModSemanticColors copyWith({
    Color? success,
    Color? successLight,
    Color? warning,
    Color? warningLight,
    Color? info,
    Color? infoLight,
    Color? danger,
    Color? dangerLight,
    Color? disabled,
    Color? disabledLight,
  }) {
    return ModSemanticColors(
      success: success ?? this.success,
      successLight: successLight ?? this.successLight,
      warning: warning ?? this.warning,
      warningLight: warningLight ?? this.warningLight,
      info: info ?? this.info,
      infoLight: infoLight ?? this.infoLight,
      danger: danger ?? this.danger,
      dangerLight: dangerLight ?? this.dangerLight,
      disabled: disabled ?? this.disabled,
      disabledLight: disabledLight ?? this.disabledLight,
    );
  }

  @override
  ModSemanticColors lerp(ModSemanticColors? other, double t) {
    if (other == null) return this;
    return ModSemanticColors(
      success: Color.lerp(success, other.success, t)!,
      successLight: Color.lerp(successLight, other.successLight, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      warningLight: Color.lerp(warningLight, other.warningLight, t)!,
      info: Color.lerp(info, other.info, t)!,
      infoLight: Color.lerp(infoLight, other.infoLight, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
      dangerLight: Color.lerp(dangerLight, other.dangerLight, t)!,
      disabled: Color.lerp(disabled, other.disabled, t)!,
      disabledLight: Color.lerp(disabledLight, other.disabledLight, t)!,
    );
  }
}
