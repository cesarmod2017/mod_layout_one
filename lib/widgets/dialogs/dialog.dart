import 'package:flutter/material.dart';
import 'package:mod_layout_one/themes/mod_tokens.dart';

enum DialogSize {
  sm,
  md,
  lg,
}

enum DialogPosition {
  topLeft,
  topCenter,
  topRight,
  centerLeft,
  center,
  centerRight,
  bottomLeft,
  bottomCenter,
  bottomRight,
}

class ModDialog extends StatelessWidget {
  final String title;
  final Widget content;
  final List<Widget> buttons;
  final ButtonAlignment buttonAlignment;
  final bool dismissible;
  final VoidCallback? onClose;
  final DialogSize size;
  final DialogPosition position;
  final Color? headerColor;
  final Color? contentColor;
  final Color? footerColor;
  final IconData? icon;
  final double borderRadius;
  final double? maxWidth;
  final double? minWidth;
  final double? maxHeight;
  final double? minHeight;

  const ModDialog({
    super.key,
    required this.title,
    required this.content,
    required this.buttons,
    this.buttonAlignment = ButtonAlignment.right,
    this.dismissible = true,
    this.onClose,
    this.size = DialogSize.md,
    this.position = DialogPosition.center,
    this.headerColor,
    this.contentColor,
    this.footerColor,
    this.icon,
    this.borderRadius = ModTokens.radiusMd,
    this.maxWidth,
    this.minWidth,
    this.maxHeight,
    this.minHeight,
  });

  double _getDialogWidth(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    double width;

    switch (size) {
      case DialogSize.sm:
        width = screenWidth * 0.3;
        break;
      case DialogSize.md:
        width = screenWidth * 0.5;
        break;
      case DialogSize.lg:
        width = screenWidth * 0.7;
        break;
    }

    // Aplicar limites de largura
    if (maxWidth != null && width > maxWidth!) {
      width = maxWidth!;
    }
    if (minWidth != null && width < minWidth!) {
      width = minWidth!;
    }

    return width;
  }

  Alignment _getDialogPosition() {
    switch (position) {
      case DialogPosition.topLeft:
        return Alignment.topLeft;
      case DialogPosition.topCenter:
        return Alignment.topCenter;
      case DialogPosition.topRight:
        return Alignment.topRight;
      case DialogPosition.centerLeft:
        return Alignment.centerLeft;
      case DialogPosition.center:
        return Alignment.center;
      case DialogPosition.centerRight:
        return Alignment.centerRight;
      case DialogPosition.bottomLeft:
        return Alignment.bottomLeft;
      case DialogPosition.bottomCenter:
        return Alignment.bottomCenter;
      case DialogPosition.bottomRight:
        return Alignment.bottomRight;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PopScope(
      canPop: dismissible,
      child: Dialog(
        alignment: _getDialogPosition(),
        elevation: ModTokens.elevationHigh,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: maxHeight ?? double.infinity,
            minHeight: minHeight ?? 0,
          ),
          child: Container(
            width: _getDialogWidth(context),
            decoration: BoxDecoration(
              color: theme.dialogBackgroundColor,
              borderRadius: BorderRadius.circular(borderRadius),
              boxShadow: [
                BoxShadow(
                  color: theme.shadowColor.withValues(alpha: ModTokens.opacityMediumLow),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(ModTokens.space16),
                  decoration: BoxDecoration(
                    color: headerColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(borderRadius),
                      topRight: Radius.circular(borderRadius),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            if (icon != null) ...[
                              Icon(icon),
                              const SizedBox(width: ModTokens.space8),
                            ],
                            Text(
                              title,
                              style: theme.textTheme.titleLarge,
                            ),
                          ],
                        ),
                      ),
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

                // Content
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.all(ModTokens.space16),
                    width: double.infinity,
                    color: contentColor,
                    child: content,
                  ),
                ),

                // Footer
                Container(
                  padding: const EdgeInsets.all(ModTokens.space16),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: footerColor,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(borderRadius),
                      bottomRight: Radius.circular(borderRadius),
                    ),
                  ),
                  alignment: _getAlignment(),
                  child: Wrap(
                    spacing: ModTokens.space8,
                    children: buttons,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Alignment _getAlignment() {
    switch (buttonAlignment) {
      case ButtonAlignment.left:
        return Alignment.centerLeft;
      case ButtonAlignment.center:
        return Alignment.center;
      case ButtonAlignment.right:
        return Alignment.centerRight;
    }
  }
}

enum ButtonAlignment {
  left,
  center,
  right,
}
