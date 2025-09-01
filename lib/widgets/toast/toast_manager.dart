import 'package:flutter/material.dart';
import 'mod_toast.dart';

class ToastManager {
  static final ToastManager _instance = ToastManager._internal();
  factory ToastManager() => _instance;
  ToastManager._internal();

  final List<OverlayEntry> _activeToasts = [];
  static const int _maxToasts = 3;

  void show({
    required BuildContext context,
    String? title,
    required String message,
    IconData? icon,
    Color? backgroundColor,
    Color? textColor,
    Color? iconColor,
    Duration duration = const Duration(seconds: 4),
    ToastPosition position = ToastPosition.topCenter,
    bool showCloseButton = true,
    EdgeInsetsGeometry margin = const EdgeInsets.all(16),
    double borderRadius = 8.0,
    double? width,
    double? height,
    ToastType type = ToastType.custom,
    BoxShadow? shadow,
    double? maxWidth,
  }) {
    final overlayState = Overlay.of(context);

    // Remove oldest toast if we have too many
    if (_activeToasts.length >= _maxToasts) {
      _removeToast(_activeToasts.first);
    }

    late OverlayEntry overlayEntry;

    final positioningData = _getPositioningData(position, context, width, maxWidth);
    
    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: positioningData['top'],
        bottom: positioningData['bottom'],
        left: positioningData['left'],
        right: positioningData['right'],
        width: positioningData['width'],
        child: Material(
          color: Colors.transparent,
          child: ModToast(
            title: title,
            message: message,
            icon: icon,
            backgroundColor: backgroundColor,
            textColor: textColor,
            iconColor: iconColor,
            duration: duration,
            position: position,
            showCloseButton: showCloseButton,
            margin: margin,
            borderRadius: borderRadius,
            width: width,
            height: height,
            type: type,
            shadow: shadow,
            maxWidth: maxWidth,
            onClose: () => _removeToast(overlayEntry),
          ),
        ),
      ),
    );

    overlayState.insert(overlayEntry);
    _activeToasts.add(overlayEntry);

    // Auto remove after duration + animation time
    Future.delayed(duration + const Duration(milliseconds: 300), () {
      if (_activeToasts.contains(overlayEntry)) {
        _removeToast(overlayEntry);
      }
    });
  }

  void _removeToast(OverlayEntry entry) {
    if (_activeToasts.contains(entry)) {
      entry.remove();
      _activeToasts.remove(entry);
    }
  }

  void clearAll() {
    for (final toast in List<OverlayEntry>.from(_activeToasts)) {
      _removeToast(toast);
    }
  }


  Map<String, double?> _getPositioningData(ToastPosition position, BuildContext context, double? customWidth, double? maxWidth) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final topPadding = MediaQuery.of(context).padding.top;
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    
    // Determine toast width considering maxWidth constraint
    double toastWidth;
    if (customWidth != null) {
      toastWidth = customWidth;
    } else if (maxWidth != null) {
      toastWidth = screenWidth > maxWidth ? maxWidth : screenWidth * 0.9;
    } else {
      toastWidth = screenWidth * 0.9;
    }
    
    switch (position) {
      // Top positions
      case ToastPosition.top:
      case ToastPosition.topCenter:
        return {
          'top': topPadding + 16.0,
          'bottom': null,
          'left': (screenWidth - toastWidth) / 2,
          'right': null,
          'width': toastWidth,
        };
      case ToastPosition.topLeft:
        return {
          'top': topPadding + 16.0,
          'bottom': null,
          'left': 16.0,
          'right': null,
          'width': toastWidth,
        };
      case ToastPosition.topRight:
        return {
          'top': topPadding + 16.0,
          'bottom': null,
          'left': null,
          'right': 16.0,
          'width': toastWidth,
        };
      
      // Bottom positions
      case ToastPosition.bottom:
      case ToastPosition.bottomCenter:
        return {
          'top': null,
          'bottom': bottomPadding + 16.0,
          'left': (screenWidth - toastWidth) / 2,
          'right': null,
          'width': toastWidth,
        };
      case ToastPosition.bottomLeft:
        return {
          'top': null,
          'bottom': bottomPadding + 16.0,
          'left': 16.0,
          'right': null,
          'width': toastWidth,
        };
      case ToastPosition.bottomRight:
        return {
          'top': null,
          'bottom': bottomPadding + 16.0,
          'left': null,
          'right': 16.0,
          'width': toastWidth,
        };
        
      // Center positions
      case ToastPosition.center:
        final centerY = (screenHeight - topPadding - bottomPadding) / 2 + topPadding - 50;
        return {
          'top': centerY,
          'bottom': null,
          'left': (screenWidth - toastWidth) / 2,
          'right': null,
          'width': toastWidth,
        };
      case ToastPosition.leftCenter:
        final centerY = (screenHeight - topPadding - bottomPadding) / 2 + topPadding - 50;
        return {
          'top': centerY,
          'bottom': null,
          'left': 16.0,
          'right': null,
          'width': screenWidth * 0.45,
        };
      case ToastPosition.rightCenter:
        final centerY = (screenHeight - topPadding - bottomPadding) / 2 + topPadding - 50;
        return {
          'top': centerY,
          'bottom': null,
          'left': null,
          'right': 16.0,
          'width': screenWidth * 0.45,
        };
        
      // Side positions
      case ToastPosition.left:
        final centerY = (screenHeight - topPadding - bottomPadding) / 2 + topPadding - 50;
        return {
          'top': centerY,
          'bottom': null,
          'left': 16.0,
          'right': null,
          'width': screenWidth * 0.45,
        };
      case ToastPosition.right:
        final centerY = (screenHeight - topPadding - bottomPadding) / 2 + topPadding - 50;
        return {
          'top': centerY,
          'bottom': null,
          'left': null,
          'right': 16.0,
          'width': screenWidth * 0.45,
        };
    }
  }

  // Convenience methods
  static void success({
    required BuildContext context,
    String? title,
    required String message,
    Duration duration = const Duration(seconds: 4),
    ToastPosition position = ToastPosition.topCenter,
    double? maxWidth,
  }) {
    ToastManager().show(
      context: context,
      title: title,
      message: message,
      type: ToastType.success,
      duration: duration,
      position: position,
      maxWidth: maxWidth,
    );
  }

  static void error({
    required BuildContext context,
    String? title,
    required String message,
    Duration duration = const Duration(seconds: 6),
    ToastPosition position = ToastPosition.topCenter,
    double? maxWidth,
  }) {
    ToastManager().show(
      context: context,
      title: title,
      message: message,
      type: ToastType.error,
      duration: duration,
      position: position,
      maxWidth: maxWidth,
    );
  }

  static void warning({
    required BuildContext context,
    String? title,
    required String message,
    Duration duration = const Duration(seconds: 5),
    ToastPosition position = ToastPosition.topCenter,
    double? maxWidth,
  }) {
    ToastManager().show(
      context: context,
      title: title,
      message: message,
      type: ToastType.warning,
      duration: duration,
      position: position,
      maxWidth: maxWidth,
    );
  }

  static void info({
    required BuildContext context,
    String? title,
    required String message,
    Duration duration = const Duration(seconds: 4),
    ToastPosition position = ToastPosition.topCenter,
    double? maxWidth,
  }) {
    ToastManager().show(
      context: context,
      title: title,
      message: message,
      type: ToastType.info,
      duration: duration,
      position: position,
      maxWidth: maxWidth,
    );
  }

  static void custom({
    required BuildContext context,
    String? title,
    required String message,
    IconData? icon,
    Color? backgroundColor,
    Color? textColor,
    Color? iconColor,
    Duration duration = const Duration(seconds: 4),
    ToastPosition position = ToastPosition.topCenter,
    bool showCloseButton = true,
    EdgeInsetsGeometry margin = const EdgeInsets.all(16),
    double borderRadius = 8.0,
    double? width,
    double? height,
    BoxShadow? shadow,
    double? maxWidth,
  }) {
    ToastManager().show(
      context: context,
      title: title,
      message: message,
      icon: icon,
      backgroundColor: backgroundColor,
      textColor: textColor,
      iconColor: iconColor,
      duration: duration,
      position: position,
      showCloseButton: showCloseButton,
      margin: margin,
      borderRadius: borderRadius,
      width: width,
      height: height,
      type: ToastType.custom,
      shadow: shadow,
      maxWidth: maxWidth,
    );
  }
}