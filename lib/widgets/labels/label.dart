import 'package:flutter/material.dart';

/// A custom text widget that supports basic markdown-like formatting.
///
/// Allows for bold text by wrapping words with asterisks (*).
/// Example: "Hello *world*" will render "world" in bold.
class ModLabel extends StatelessWidget {
  /// The text to be displayed.
  final String text;

  /// The style to apply to the text.
  final TextStyle? style;

  /// The color of the text.
  final Color? color;

  /// The font size of the text.
  final double? fontSize;

  /// The text alignment.
  final TextAlign? align;

  const ModLabel({
    super.key,
    required this.text,
    this.style,
    this.color,
    this.fontSize,
    this.align,
  });

  @override
  Widget build(BuildContext context) {
    // Parse the text to identify bold sections
    final List<InlineSpan> spans = [];
    final RegExp boldPattern = RegExp(r'\*(.*?)\*');

    String remainingText = text;
    int lastMatchEnd = 0;

    for (final Match match in boldPattern.allMatches(text)) {
      // Add text before the match
      if (match.start > lastMatchEnd) {
        final normalText = text.substring(lastMatchEnd, match.start);
        spans.add(TextSpan(
          text: normalText,
          style: _getBaseStyle(context),
        ));
      }

      // Add the bold text (without the asterisks)
      final boldText = match.group(1);
      if (boldText != null) {
        spans.add(TextSpan(
          text: boldText,
          style: _getBaseStyle(context).copyWith(
            fontWeight: FontWeight.bold,
          ),
        ));
      }

      lastMatchEnd = match.end;
    }

    // Add any remaining text after the last match
    if (lastMatchEnd < text.length) {
      spans.add(TextSpan(
        text: text.substring(lastMatchEnd),
        style: _getBaseStyle(context),
      ));
    }

    return RichText(
      text: TextSpan(
        children: spans,
      ),
      textAlign: align ?? TextAlign.start,
    );
  }

  /// Creates a base TextStyle with the provided properties.
  TextStyle _getBaseStyle(BuildContext context) {
    final textColor = color ?? Theme.of(context).textTheme.bodyMedium?.color;

    return (style ?? const TextStyle()).copyWith(
      color: textColor,
      fontSize: fontSize,
    );
  }
}
