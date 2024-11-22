import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum ModTextBoxLabelPosition { top, left }

class ModTextBox extends StatefulWidget {
  final String? label;
  final String? hint;
  final String? value;
  final ValueChanged<String>? onChange;
  final TextEditingController? controller;
  final List<TextInputFormatter>? inputFormatters;
  final bool isPassword;
  final bool readOnly;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final TextStyle? style;
  final ModTextBoxLabelPosition labelPosition;
  final bool floatingLabel;
  final String? Function(String?)? validator;
  final String? errorText;
  final double? width;
  final double borderRadius;
  final AutovalidateMode autovalidateMode;
  final bool autocorrect;
  final bool autofocus;
  final Color? cursorColor;
  final double? cursorHeight;
  final bool? enabled;
  final bool expands;
  final FocusNode? focusNode;
  final int? maxLength;
  final int? maxLines;
  final int? minLines;
  final TextAlign textAlign;
  final GestureTapCallback? onTapOutside;
  final VoidCallback? onEditingComplete;
  final FormFieldSetter<String>? onSaved;
  final GestureTapCallback? onTap;
  final bool onTapAlwaysCalled;
  final ValueChanged<String>? onFieldSubmitted;

  const ModTextBox({
    super.key,
    this.label,
    this.hint,
    this.value,
    this.onChange,
    this.controller,
    this.inputFormatters,
    this.isPassword = false,
    this.readOnly = false,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType,
    this.style,
    this.labelPosition = ModTextBoxLabelPosition.top,
    this.floatingLabel = true,
    this.validator,
    this.errorText,
    this.width,
    this.borderRadius = 8.0,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.autocorrect = false,
    this.autofocus = false,
    this.cursorColor,
    this.cursorHeight,
    this.enabled,
    this.expands = false,
    this.focusNode,
    this.maxLength,
    this.maxLines,
    this.minLines,
    this.textAlign = TextAlign.start,
    this.onTapOutside,
    this.onEditingComplete,
    this.onSaved,
    this.onTap,
    this.onTapAlwaysCalled = false,
    this.onFieldSubmitted,
  });

  @override
  State<ModTextBox> createState() => _ModTextBoxState();
}

class _ModTextBoxState extends State<ModTextBox> {
  late TextEditingController _controller;
  bool _obscureText = true;
  bool _hasFocus = false;

  @override
  void initState() {
    super.initState();
    _controller =
        widget.controller ?? TextEditingController(text: widget.value);
    _controller.addListener(() {
      if (widget.onChange != null && _hasFocus) {
        widget.onChange!(_controller.text);
      }
    });
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Ensure that if the field is a password field, it cannot be multiline
    final maxLines = widget.isPassword ? 1 : widget.maxLines;

    Widget textField = Focus(
      onFocusChange: (hasFocus) {
        setState(() {
          _hasFocus = hasFocus;
        });
      },
      child: TextFormField(
        controller: _controller,
        obscureText: widget.isPassword && _obscureText,
        readOnly: widget.readOnly,
        keyboardType: widget.keyboardType ?? TextInputType.text,
        style: widget.style ?? theme.textTheme.bodyMedium,
        inputFormatters: widget.inputFormatters,
        validator: widget.validator,
        autovalidateMode: widget.autovalidateMode,
        autocorrect: widget.autocorrect,
        autofocus: widget.autofocus,
        cursorColor: widget.cursorColor,
        cursorHeight: widget.cursorHeight,
        enabled: widget.enabled,
        expands: widget.expands,
        focusNode: widget.focusNode,
        maxLength: widget.maxLength,
        maxLines: maxLines,
        minLines: widget.minLines,
        textAlign: widget.textAlign,
        onTapOutside: widget.onTapOutside as TapRegionCallback?,
        onEditingComplete: widget.onEditingComplete,
        onSaved: widget.onSaved,
        onTap: widget.onTap,
        onFieldSubmitted: widget.onFieldSubmitted,
        decoration: InputDecoration(
          hintText: widget.hint,
          errorText: widget.errorText,
          prefixIcon: widget.prefixIcon,
          suffixIcon: widget.isPassword
              ? IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                )
              : widget.suffixIcon,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius),
          ),
          floatingLabelBehavior: widget.floatingLabel
              ? FloatingLabelBehavior.auto
              : FloatingLabelBehavior.never,
        ),
      ),
    );

    if (widget.label == null) {
      return SizedBox(width: widget.width, child: textField);
    }

    if (widget.labelPosition == ModTextBoxLabelPosition.left) {
      return SizedBox(
        width: widget.width,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(widget.label!, style: theme.textTheme.bodyMedium),
            const SizedBox(width: 8),
            Expanded(child: textField),
          ],
        ),
      );
    }

    return SizedBox(
      width: widget.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.label!, style: theme.textTheme.bodyMedium),
          const SizedBox(height: 8),
          textField,
        ],
      ),
    );
  }
}
