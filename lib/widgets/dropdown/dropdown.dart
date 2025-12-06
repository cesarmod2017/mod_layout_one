import 'package:flutter/material.dart';

enum ModDropDownSize { lg, md, sm, xs }

enum ModDropDownLabelPosition { top, left, inside }

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
  final bool hasBorder;
  final Color? backgroundColor;
  final Color? borderColor;
  final double borderWidth;
  final double? fontSize;
  final double? iconSize;
  final bool floatingLabel;
  final Color? floatingLabelBackgroundColor;

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
    this.hasBorder = false,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth = 1.0,
    this.fontSize,
    this.iconSize,
    this.floatingLabel = false,
    this.floatingLabelBackgroundColor = Colors.transparent,
  });

  @override
  State<ModDropDown<T>> createState() => _ModDropDownState<T>();
}

class _ModDropDownState<T> extends State<ModDropDown<T>> {
  // ignore: unused_field
  bool _hasFocus = false;
  bool _showValidationError = false;

  bool get _shouldFloatLabel {
    return widget.floatingLabel && (_hasFocus || widget.value != null);
  }

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

  double _getEffectiveFontSize() {
    return widget.fontSize ?? _getFontSize();
  }

  double _getEffectiveIconSize() {
    return widget.iconSize ?? _getIconSize();
  }

  EdgeInsets _getContentPadding() {
    final height = _getHeight();
    final fontSize = _getEffectiveFontSize();

    // Calcula o padding vertical para centralizar o texto
    // Considera a altura da linha baseada no tamanho da fonte
    final lineHeight = fontSize * 1.2; // Altura da linha padrão
    final verticalPadding = (height - lineHeight) / 2;

    // Se floating label está ativo, ajusta o padding
    if (_shouldFloatLabel) {
      return EdgeInsets.fromLTRB(
        12,
        verticalPadding > 0 ? verticalPadding - 2 : 2, // Padding top menor
        12,
        verticalPadding > 0 ? verticalPadding + 2 : 6, // Padding bottom maior
      );
    }

    return EdgeInsets.symmetric(
      horizontal: 12,
      vertical: verticalPadding > 0 ? verticalPadding : 4,
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

    // Definir cor de fundo padrão baseada no tema
    Color defaultBackgroundColor;
    if (theme.brightness == Brightness.dark) {
      defaultBackgroundColor =
          theme.scaffoldBackgroundColor.withValues(alpha: 0.8);
    } else {
      defaultBackgroundColor =
          theme.scaffoldBackgroundColor.withValues(alpha: 0.05);
    }

    final backgroundColor = widget.backgroundColor ?? defaultBackgroundColor;
    final borderColor = widget.borderColor ?? theme.dividerColor;

    Widget dropDown = Focus(
      onFocusChange: (hasFocus) {
        if (mounted) {
          setState(() {
            _hasFocus = hasFocus;
            if (!hasFocus) {
              _showValidationError = true;
            }
          });
        }
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
            initialValue: widget.value,
            items: widget.items,
            onChanged: widget.readOnly ? null : widget.onChanged,
            style: widget.style?.copyWith(fontSize: _getEffectiveFontSize()) ??
                TextStyle(fontSize: _getEffectiveFontSize()),
            validator: widget.validator,
            autovalidateMode: widget.autovalidateMode,
            isExpanded: true,
            icon: widget.suffixIcon ??
                Icon(
                  Icons.arrow_drop_down,
                  size: _getEffectiveIconSize(),
                ),
            focusNode: widget.focusNode,
            decoration: InputDecoration(
              isDense: true,
              contentPadding: _getContentPadding(),
              hintText: widget.floatingLabel ? null : widget.hint,
              hintStyle: TextStyle(
                fontSize: _getEffectiveFontSize(),
                height: 1.0,
              ),
              errorStyle: const TextStyle(height: 0, fontSize: 0),
              filled: true,
              fillColor: backgroundColor,
              prefixIcon: widget.prefixIcon != null
                  ? IconTheme(
                      data: IconThemeData(size: _getEffectiveIconSize()),
                      child: widget.prefixIcon!,
                    )
                  : null,
              border: widget.hasBorder
                  ? OutlineInputBorder(
                      borderRadius: BorderRadius.circular(widget.borderRadius),
                      borderSide: BorderSide(
                        color: hasError ? theme.colorScheme.error : borderColor,
                        width: widget.borderWidth,
                      ),
                    )
                  : OutlineInputBorder(
                      borderRadius: BorderRadius.circular(widget.borderRadius),
                      borderSide: BorderSide.none,
                    ),
              enabledBorder: widget.hasBorder
                  ? OutlineInputBorder(
                      borderRadius: BorderRadius.circular(widget.borderRadius),
                      borderSide: BorderSide(
                        color: hasError ? theme.colorScheme.error : borderColor,
                        width: widget.borderWidth,
                      ),
                    )
                  : OutlineInputBorder(
                      borderRadius: BorderRadius.circular(widget.borderRadius),
                      borderSide: BorderSide.none,
                    ),
              focusedBorder: widget.hasBorder
                  ? OutlineInputBorder(
                      borderRadius: BorderRadius.circular(widget.borderRadius),
                      borderSide: BorderSide(
                        color: hasError ? theme.colorScheme.error : borderColor,
                        width: widget.borderWidth,
                      ),
                    )
                  : OutlineInputBorder(
                      borderRadius: BorderRadius.circular(widget.borderRadius),
                      borderSide: BorderSide.none,
                    ),
            ),
          ),
        ),
      ),
    );

    if (widget.label == null) {
      return SizedBox(width: widget.width, child: dropDown);
    }

    // Se floatingLabel for true, usar Stack com Positioned
    if (widget.floatingLabel) {
      return SizedBox(
        width: widget.width,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            dropDown,
            // Floating Label
            Positioned(
              left: 12,
              top: _shouldFloatLabel ? -12 : (height - 16) / 2,
              child: AnimatedScale(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                scale: _shouldFloatLabel ? 0.75 : 1.0,
                alignment: Alignment.centerLeft,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  padding: _shouldFloatLabel
                      ? const EdgeInsets.symmetric(horizontal: 4, vertical: 2)
                      : EdgeInsets.zero,
                  decoration: _shouldFloatLabel
                      ? BoxDecoration(
                          color: widget.floatingLabelBackgroundColor ??
                              backgroundColor,
                          borderRadius: BorderRadius.circular(2),
                        )
                      : null,
                  child: Text(
                    widget.label!,
                    style: TextStyle(
                      fontSize: _shouldFloatLabel
                          ? _getEffectiveFontSize()
                          : _getEffectiveFontSize(),
                      color: _shouldFloatLabel
                          ? theme.textTheme.bodyMedium?.color
                          : theme.textTheme.bodyMedium?.color
                              ?.withValues(alpha: 0.6),
                      fontWeight: _shouldFloatLabel
                          ? FontWeight.w500
                          : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
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
          const SizedBox(height: 2),
          dropDown,
        ],
      ),
    );
  }
}
