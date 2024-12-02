import 'package:flutter/material.dart';

enum ModDropDownSize { lg, md, sm, xs }

enum ModDropDownLabelPosition { top, left }

class ModDropDown<T> extends StatefulWidget {
  final String? label;
  final String? hint;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final bool readOnly;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextStyle? style;
  final ModDropDownLabelPosition labelPosition;
  final String? Function(T?)? validator;
  final String? errorText;
  final double? width;
  final double borderRadius;
  final AutovalidateMode autovalidateMode;
  final bool? enabled;
  final FocusNode? focusNode;
  final ModDropDownSize size;

  const ModDropDown({
    super.key,
    this.label,
    this.hint,
    this.value,
    required this.items,
    this.onChanged,
    this.readOnly = false,
    this.prefixIcon,
    this.suffixIcon,
    this.style,
    this.labelPosition = ModDropDownLabelPosition.top,
    this.validator,
    this.errorText,
    this.width,
    this.borderRadius = 8.0,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.enabled,
    this.focusNode,
    this.size = ModDropDownSize.md,
  });

  @override
  State<ModDropDown<T>> createState() => _ModDropDownState<T>();
}

class _ModDropDownState<T> extends State<ModDropDown<T>> {
  bool _hasFocus = false;
  bool _showValidationError = false;

  double _getHeight() {
    switch (widget.size) {
      case ModDropDownSize.lg:
        return 58;
      case ModDropDownSize.md:
        return 47;
      case ModDropDownSize.sm:
        return 39;
      case ModDropDownSize.xs:
        return 25;
    }
  }

  double _getFontSize() {
    switch (widget.size) {
      case ModDropDownSize.lg:
        return 18;
      case ModDropDownSize.md:
        return 16;
      case ModDropDownSize.sm:
        return 14;
      case ModDropDownSize.xs:
        return 10;
    }
  }

  double _getIconSize() {
    switch (widget.size) {
      case ModDropDownSize.lg:
        return 24;
      case ModDropDownSize.md:
        return 20;
      case ModDropDownSize.sm:
        return 18;
      case ModDropDownSize.xs:
        return 16;
    }
  }

  EdgeInsets _getContentPadding() {
    final height = _getHeight();
    return EdgeInsets.symmetric(
      horizontal: 12,
      vertical: (height - _getFontSize() - 8) / 2,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final height = _getHeight();
    final hasError = _showValidationError &&
        (widget.errorText != null ||
            (widget.validator != null &&
                widget.validator!(widget.value) != null));
    final errorMessage = _showValidationError
        ? widget.errorText ??
            (widget.validator != null ? widget.validator!(widget.value) : null)
        : null;

    Widget dropDown = Focus(
      onFocusChange: (hasFocus) {
        setState(() {
          _hasFocus = hasFocus;
          if (!hasFocus) {
            _showValidationError = true;
          }
        });
      },
      child: SizedBox(
        height: height,
        child: Tooltip(
          message: hasError ? errorMessage ?? '' : '',
          textStyle: const TextStyle(
            fontSize: 12,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(4),
          ),
          child: DropdownButtonFormField<T>(
            value: widget.value,
            items: widget.items,
            onChanged: widget.readOnly ? null : widget.onChanged,
            style: widget.style?.copyWith(fontSize: _getFontSize()) ??
                TextStyle(fontSize: _getFontSize()),
            validator: widget.validator,
            autovalidateMode: widget.autovalidateMode,
            icon: widget.suffixIcon ??
                Icon(
                  Icons.arrow_drop_down,
                  size: _getIconSize(),
                ),
            focusNode: widget.focusNode,
            decoration: InputDecoration(
              isDense: true,
              contentPadding: _getContentPadding(),
              hintText: widget.hint,
              errorStyle: const TextStyle(height: 0, fontSize: 0),
              prefixIcon: widget.prefixIcon != null
                  ? IconTheme(
                      data: IconThemeData(size: _getIconSize()),
                      child: widget.prefixIcon!,
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.borderRadius),
                borderSide: BorderSide(
                  color:
                      hasError ? theme.colorScheme.error : theme.dividerColor,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.borderRadius),
                borderSide: BorderSide(
                  color:
                      hasError ? theme.colorScheme.error : theme.dividerColor,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.borderRadius),
                borderSide: BorderSide(
                  color:
                      hasError ? theme.colorScheme.error : theme.dividerColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );

    if (widget.label == null) {
      return SizedBox(width: widget.width, child: dropDown);
    }

    if (widget.labelPosition == ModDropDownLabelPosition.left) {
      return SizedBox(
        width: widget.width,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(widget.label!, style: theme.textTheme.bodyMedium),
            const SizedBox(width: 8),
            Expanded(child: dropDown),
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
          dropDown,
        ],
      ),
    );
  }
}
