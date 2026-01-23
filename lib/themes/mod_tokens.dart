/// Design tokens for ModLayoutOne components.
///
/// These tokens define the foundational design values used across all components.
/// Use these values for consistent spacing, sizing, and animations throughout the package.
///
/// ## Spacing Usage:
/// ```dart
/// Padding(
///   padding: EdgeInsets.all(ModTokens.space16),
///   child: ...
/// )
/// ```
///
/// ## Duration Usage:
/// ```dart
/// AnimatedContainer(
///   duration: ModTokens.durationNormal,
///   ...
/// )
/// ```
class ModTokens {
  ModTokens._();

  // ============================================
  // SPACING
  // ============================================

  /// 2px - Minimal spacing
  static const double space2 = 2.0;

  /// 4px - Extra small spacing
  static const double space4 = 4.0;

  /// 6px - Small spacing (button vertical padding xs/sm)
  static const double space6 = 6.0;

  /// 8px - Base spacing unit
  static const double space8 = 8.0;

  /// 12px - Medium-small spacing
  static const double space12 = 12.0;

  /// 16px - Standard spacing
  static const double space16 = 16.0;

  /// 20px - Medium spacing
  static const double space20 = 20.0;

  /// 24px - Large spacing
  static const double space24 = 24.0;

  /// 32px - Extra large spacing
  static const double space32 = 32.0;

  /// 40px - 2XL spacing
  static const double space40 = 40.0;

  /// 48px - 3XL spacing
  static const double space48 = 48.0;

  // ============================================
  // BORDER RADIUS
  // ============================================

  /// 4px - Small radius (buttons default)
  static const double radiusSm = 4.0;

  /// 6px - Progress bars
  static const double radiusProgress = 6.0;

  /// 8px - Medium radius (cards, inputs, modals)
  static const double radiusMd = 8.0;

  /// 12px - Large radius
  static const double radiusLg = 12.0;

  /// 16px - Extra large radius
  static const double radiusXl = 16.0;

  /// 999px - Full/pill radius
  static const double radiusFull = 999.0;

  // ============================================
  // COMPONENT HEIGHTS - BUTTONS
  // ============================================

  /// 24px - Extra small button height
  static const double buttonHeightXs = 24.0;

  /// 32px - Small button height
  static const double buttonHeightSm = 32.0;

  /// 40px - Medium button height (default)
  static const double buttonHeightMd = 40.0;

  /// 48px - Large button height
  static const double buttonHeightLg = 48.0;

  // ============================================
  // COMPONENT HEIGHTS - TEXT INPUTS
  // ============================================

  /// 29px - Extra small textbox height
  static const double textBoxHeightXs = 29.0;

  /// 42px - Small textbox height
  static const double textBoxHeightSm = 42.0;

  /// 50px - Medium textbox height (default)
  static const double textBoxHeightMd = 50.0;

  /// 61px - Large textbox height
  static const double textBoxHeightLg = 61.0;

  // ============================================
  // FONT SIZES
  // ============================================

  /// 10px - Extra small font
  static const double fontSizeXs = 10.0;

  /// 12px - Small font
  static const double fontSizeSm = 12.0;

  /// 14px - Medium-small font (labels, secondary text)
  static const double fontSizeMd = 14.0;

  /// 16px - Base font size
  static const double fontSizeBase = 16.0;

  /// 18px - Large font
  static const double fontSizeLg = 18.0;

  /// 20px - Extra large font
  static const double fontSizeXl = 20.0;

  /// 24px - Title font
  static const double fontSizeTitle = 24.0;

  // ============================================
  // ICON SIZES
  // ============================================

  /// 16px - Extra small icon
  static const double iconSizeXs = 16.0;

  /// 18px - Small icon
  static const double iconSizeSm = 18.0;

  /// 20px - Medium icon
  static const double iconSizeMd = 20.0;

  /// 24px - Large icon (default)
  static const double iconSizeLg = 24.0;

  /// 32px - Extra large icon
  static const double iconSizeXl = 32.0;

  // ============================================
  // ANIMATION DURATIONS
  // ============================================

  /// 150ms - Fast animations (hover, focus)
  static const Duration durationFast = Duration(milliseconds: 150);

  /// 200ms - Normal animations (expansion, collapse)
  static const Duration durationNormal = Duration(milliseconds: 200);

  /// 250ms - Medium animations
  static const Duration durationMedium = Duration(milliseconds: 250);

  /// 300ms - Standard animations (modals, dialogs)
  static const Duration durationStandard = Duration(milliseconds: 300);

  /// 400ms - Slow animations
  static const Duration durationSlow = Duration(milliseconds: 400);

  /// 1000ms - Loading rotation
  static const Duration durationRotation = Duration(milliseconds: 1000);

  // ============================================
  // LAYOUT DIMENSIONS
  // ============================================

  /// 70px - Collapsed sidebar width
  static const double sidebarCollapsedWidth = 70.0;

  /// 240px - Expanded sidebar width
  static const double sidebarExpandedWidth = 240.0;

  /// 50px - Footer height (default)
  static const double footerHeight = 50.0;

  /// 56px - AppBar height (kToolbarHeight equivalent)
  static const double appBarHeight = 56.0;

  // ============================================
  // BREAKPOINTS
  // ============================================

  /// 768px - Mobile/Desktop breakpoint
  static const double breakpointMobile = 768.0;

  /// 576px - Small devices
  static const double breakpointSm = 576.0;

  /// 768px - Medium devices (tablets)
  static const double breakpointMd = 768.0;

  /// 992px - Large devices (desktops)
  static const double breakpointLg = 992.0;

  /// 1200px - Extra large devices
  static const double breakpointXl = 1200.0;

  /// 1400px - Extra extra large devices
  static const double breakpointXxl = 1400.0;

  // ============================================
  // ELEVATION
  // ============================================

  /// 0 - No elevation
  static const double elevationNone = 0.0;

  /// 2 - Low elevation (sidebar, cards)
  static const double elevationLow = 2.0;

  /// 4 - Medium elevation
  static const double elevationMedium = 4.0;

  /// 6 - Default elevation (chatbot button)
  static const double elevationDefault = 6.0;

  /// 8 - High elevation (dialogs, modals)
  static const double elevationHigh = 8.0;

  /// 12 - Maximum elevation (overlays)
  static const double elevationMax = 12.0;

  // ============================================
  // OPACITY
  // ============================================

  /// 0.05 - Very subtle opacity
  static const double opacitySubtle = 0.05;

  /// 0.1 - Light opacity (hover states, selection)
  static const double opacityLight = 0.1;

  /// 0.2 - Medium-low opacity (shadows)
  static const double opacityMediumLow = 0.2;

  /// 0.5 - Medium opacity
  static const double opacityMedium = 0.5;

  /// 0.6 - Medium-high opacity (scrollbar thumb)
  static const double opacityMediumHigh = 0.6;

  /// 0.7 - High opacity (close button icons)
  static const double opacityHigh = 0.7;

  /// 0.87 - Text opacity
  static const double opacityText = 0.87;
}
