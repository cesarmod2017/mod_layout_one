import 'package:flutter/material.dart';

enum ModModalPosition { top, center, bottom }

enum ModModalSize { xs, sm, md, lg }

enum ModModalHeight { normal, full, auto }

class ModModal extends StatelessWidget {
  final Widget header;
  final Widget body;
  final Widget footer;
  final Color? headerColor;
  final Color? bodyColor;
  final Color? footerColor;
  final ModModalPosition position;
  final ModModalSize size;
  final ModModalHeight height;
  final bool fullScreen;
  final double borderRadius;
  final bool barrierDismissible;
  final VoidCallback? onClose;
  final EdgeInsets? padding;

  /// Largura máxima do modal (em pixels)
  final double? maxWidth;

  /// Largura mínima do modal (em pixels)
  final double? minWidth;

  /// Altura máxima do modal (em pixels)
  final double? maxHeight;

  /// Altura mínima do modal (em pixels)
  final double? minHeight;

  const ModModal({
    super.key,
    required this.header,
    required this.body,
    required this.footer,
    this.headerColor,
    this.bodyColor,
    this.footerColor,
    this.position = ModModalPosition.center,
    this.size = ModModalSize.md,
    this.height = ModModalHeight.normal,
    this.fullScreen = false,
    this.borderRadius = 8.0,
    this.barrierDismissible = true,
    this.onClose,
    this.maxWidth,
    this.minWidth,
    this.maxHeight,
    this.minHeight,
    this.padding,
  });

  double _getModalWidth(BuildContext context) {
    if (fullScreen) return MediaQuery.of(context).size.width;

    final screenWidth = MediaQuery.of(context).size.width;
    double calculatedWidth;

    switch (size) {
      case ModModalSize.xs:
        calculatedWidth = screenWidth * 0.3;
        break;
      case ModModalSize.sm:
        calculatedWidth = screenWidth * 0.5;
        break;
      case ModModalSize.md:
        calculatedWidth = screenWidth * 0.7;
        break;
      case ModModalSize.lg:
        calculatedWidth = screenWidth * 0.9;
        break;
    }

    // Aplicar limitações de largura
    if (maxWidth != null && calculatedWidth > maxWidth!) {
      calculatedWidth = maxWidth!;
    }
    if (minWidth != null && calculatedWidth < minWidth!) {
      calculatedWidth = minWidth!;
    }

    return calculatedWidth;
  }

  double _getModalHeight(BuildContext context) {
    if (fullScreen) return MediaQuery.of(context).size.height;

    final screenHeight = MediaQuery.of(context).size.height;
    double calculatedHeight;

    switch (height) {
      case ModModalHeight.full:
        calculatedHeight = screenHeight * 0.9;
        break;
      case ModModalHeight.auto:
        // Para auto, usar maxHeight se disponível, senão permitir expansão livre
        return maxHeight ?? double.infinity;
      case ModModalHeight.normal:
        calculatedHeight = screenHeight * 0.6;
        break;
    }

    // Aplicar limitações de altura apenas se não for auto
    if (maxHeight != null && calculatedHeight > maxHeight!) {
      calculatedHeight = maxHeight!;
    }
    if (minHeight != null && calculatedHeight < minHeight!) {
      calculatedHeight = minHeight!;
    }

    return calculatedHeight;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: fullScreen
          ? EdgeInsets.zero
          : const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Container(
        width: _getModalWidth(context),
        constraints: BoxConstraints(
          maxHeight: _getModalHeight(context),
          minWidth: minWidth ?? 0,
          maxWidth: maxWidth ?? double.infinity,
          minHeight: minHeight ?? 0,
        ),
        decoration: BoxDecoration(
          borderRadius: fullScreen
              ? BorderRadius.zero
              : BorderRadius.circular(borderRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: headerColor ?? theme.colorScheme.surface,
                borderRadius: fullScreen
                    ? BorderRadius.zero
                    : BorderRadius.only(
                        topLeft: Radius.circular(borderRadius),
                        topRight: Radius.circular(borderRadius),
                      ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: header),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      if (onClose != null) {
                        onClose!();
                      }
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
            const Divider(height: 1, thickness: 1),
            Flexible(
              child: Container(
                width: double.infinity,
                color: bodyColor ?? theme.colorScheme.surface,
                padding: padding ?? const EdgeInsets.all(16),
                child: body,
              ),
            ),
            const Divider(height: 1, thickness: 1),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: footerColor ?? theme.colorScheme.surface,
                borderRadius: fullScreen
                    ? BorderRadius.zero
                    : BorderRadius.only(
                        bottomLeft: Radius.circular(borderRadius),
                        bottomRight: Radius.circular(borderRadius),
                      ),
              ),
              child: footer,
            ),
          ],
        ),
      ),
    );
  }

  static Future<T?> show<T>({
    required BuildContext context,
    required Widget header,
    required Widget body,
    required Widget footer,
    Color? headerColor,
    Color? bodyColor,
    Color? footerColor,
    ModModalPosition position = ModModalPosition.center,
    ModModalSize size = ModModalSize.md,
    ModModalHeight height = ModModalHeight.normal,
    bool fullScreen = false,
    double borderRadius = 8.0,
    bool barrierDismissible = true,
    VoidCallback? onClose,
    double? maxWidth,
    double? minWidth,
    double? maxHeight,
    double? minHeight,
    EdgeInsets? padding,
  }) {
    final modalAlignment = position == ModModalPosition.top
        ? Alignment.topCenter
        : position == ModModalPosition.bottom
            ? Alignment.bottomCenter
            : Alignment.center;

    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => Align(
        alignment: modalAlignment,
        child: ModModal(
          header: header,
          body: body,
          padding: padding,
          footer: footer,
          headerColor: headerColor,
          bodyColor: bodyColor,
          footerColor: footerColor,
          position: position,
          size: size,
          height: height,
          fullScreen: fullScreen,
          borderRadius: borderRadius,
          barrierDismissible: barrierDismissible,
          onClose: onClose,
          maxWidth: maxWidth,
          minWidth: minWidth,
          maxHeight: maxHeight,
          minHeight: minHeight,
        ),
      ),
    );
  }
}
