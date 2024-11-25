import 'package:flutter/material.dart';

class ModTextDivider extends StatelessWidget {
  final String text;
  final TextStyle? textStyle;
  final Color? dividerColor;
  final double dividerThickness;

  const ModTextDivider({
    super.key,
    required this.text,
    this.textStyle,
    this.dividerColor,
    this.dividerThickness = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultDividerColor = theme.dividerColor;

    return Row(
      children: [
        Expanded(
          child: Divider(
            color: dividerColor ?? defaultDividerColor,
            thickness: dividerThickness,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            text,
            style:
                textStyle ?? theme.textTheme.bodyLarge?.copyWith(fontSize: 16),
          ),
        ),
        Expanded(
          child: Divider(
            color: dividerColor ?? defaultDividerColor,
            thickness: dividerThickness,
          ),
        ),
      ],
    );
  }
}
