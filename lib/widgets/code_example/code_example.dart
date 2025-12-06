import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A widget that displays a collapsible code example with copy functionality.
///
/// This widget is designed to show code snippets below component examples,
/// allowing users to expand/collapse the code and copy it to clipboard.
class ModCodeExample extends StatefulWidget {
  /// The code to display and copy
  final String code;

  /// Optional title for the code example section
  final String title;

  /// Whether the code example is initially expanded
  final bool initiallyExpanded;

  /// Background color for the code area
  final Color? codeBackgroundColor;

  /// Text style for the code
  final TextStyle? codeStyle;

  /// Border radius for the component
  final double borderRadius;

  const ModCodeExample({
    super.key,
    required this.code,
    this.title = 'Exemplo de Código',
    this.initiallyExpanded = false,
    this.codeBackgroundColor,
    this.codeStyle,
    this.borderRadius = 8.0,
  });

  @override
  State<ModCodeExample> createState() => _ModCodeExampleState();
}

class _ModCodeExampleState extends State<ModCodeExample>
    with SingleTickerProviderStateMixin {
  late bool _isExpanded;
  bool _isCopied = false;
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    if (_isExpanded) {
      _animationController.value = 1.0;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  Future<void> _copyToClipboard() async {
    await Clipboard.setData(ClipboardData(text: widget.code));
    setState(() => _isCopied = true);

    await Future.delayed(const Duration(milliseconds: 1500));
    if (mounted) {
      setState(() => _isCopied = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final codeBackground = widget.codeBackgroundColor ??
        (isDark ? const Color(0xFF1E1E1E) : const Color(0xFFF5F5F5));
    final headerBackground =
        isDark ? const Color(0xFF2D2D2D) : const Color(0xFFE0E0E0);
    final textColor = isDark ? Colors.white70 : Colors.black87;

    return Container(
      margin: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        border: Border.all(
          color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header with toggle and copy button
          InkWell(
            onTap: _toggleExpanded,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(widget.borderRadius),
              topRight: Radius.circular(widget.borderRadius),
              bottomLeft: Radius.circular(_isExpanded ? 0 : widget.borderRadius),
              bottomRight:
                  Radius.circular(_isExpanded ? 0 : widget.borderRadius),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: headerBackground,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(widget.borderRadius),
                  topRight: Radius.circular(widget.borderRadius),
                  bottomLeft:
                      Radius.circular(_isExpanded ? 0 : widget.borderRadius),
                  bottomRight:
                      Radius.circular(_isExpanded ? 0 : widget.borderRadius),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.code,
                    size: 18,
                    color: textColor,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      widget.title,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: textColor,
                      ),
                    ),
                  ),
                  // Copy button
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: _copyToClipboard,
                      borderRadius: BorderRadius.circular(4),
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 200),
                              child: _isCopied
                                  ? Icon(
                                      Icons.check,
                                      key: const ValueKey('check'),
                                      size: 16,
                                      color: Colors.green,
                                    )
                                  : Icon(
                                      Icons.copy,
                                      key: const ValueKey('copy'),
                                      size: 16,
                                      color: textColor,
                                    ),
                            ),
                            const SizedBox(width: 4),
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 200),
                              child: Text(
                                _isCopied ? 'Copiado!' : 'Copiar',
                                key: ValueKey(_isCopied),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: _isCopied ? Colors.green : textColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Expand/Collapse icon
                  AnimatedRotation(
                    turns: _isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 300),
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      size: 20,
                      color: textColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Code content
          SizeTransition(
            sizeFactor: _expandAnimation,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: codeBackground,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(widget.borderRadius),
                  bottomRight: Radius.circular(widget.borderRadius),
                ),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.all(12),
                child: SelectableText(
                  widget.code,
                  style: widget.codeStyle ??
                      TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 13,
                        color: isDark ? Colors.white70 : Colors.black87,
                        height: 1.5,
                      ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
