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
  });

  double _getModalWidth(BuildContext context) {
    if (fullScreen) return MediaQuery.of(context).size.width;

    final screenWidth = MediaQuery.of(context).size.width;
    switch (size) {
      case ModModalSize.xs:
        return screenWidth * 0.3;
      case ModModalSize.sm:
        return screenWidth * 0.5;
      case ModModalSize.md:
        return screenWidth * 0.7;
      case ModModalSize.lg:
        return screenWidth * 0.9;
    }
  }

  double _getModalHeight(BuildContext context) {
    if (fullScreen) return MediaQuery.of(context).size.height;

    final screenHeight = MediaQuery.of(context).size.height;
    switch (height) {
      case ModModalHeight.full:
        return screenHeight * 0.9;
      case ModModalHeight.auto:
        return double
            .infinity; // Allow the modal to take the height of its content
      case ModModalHeight.normal:
        return screenHeight * 0.6;
    }
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
                padding: const EdgeInsets.all(16),
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
        ),
      ),
    );
  }
}
