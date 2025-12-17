import 'package:flutter/foundation.dart' show kIsWeb, defaultTargetPlatform, TargetPlatform;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum ModTextBoxLabelPosition { top, left }

enum ModTextBoxSize { lg, md, sm, xs }

/// Position of increment/decrement buttons for number mode
enum ModTextBoxNumberButtonPosition {
  /// Buttons positioned on left and right sides of the text field
  leftRight,
  /// Buttons positioned above and below the text field
  topBottom,
}

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
  final Widget? suffixButton;
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
  final TextInputAction? textInputAction;
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
  final ModTextBoxSize size;
  final double? fixedHeight;
  final bool multiline;
  final bool autoHeight;

  // Parâmetros para customização do evento Enter
  final bool enableEnterAction;
  final Future<void> Function()? enterOnPressed;

  // Novos parâmetros para customização
  final bool showBorder;
  final Color? backgroundColor;
  final Color? borderColor;
  final double borderWidth;

  // Parâmetros para modo numérico
  /// Enables number mode with increment/decrement buttons
  final bool numberMode;
  /// Position of increment/decrement buttons (leftRight or topBottom)
  final ModTextBoxNumberButtonPosition numberButtonPosition;
  /// Minimum value for number mode
  final num? minValue;
  /// Maximum value for number mode
  final num? maxValue;
  /// Step value for increment/decrement
  final num step;
  /// Number of decimal places (0 for integers)
  final int decimalPlaces;
  /// Custom icon for increment button
  final IconData? incrementIcon;
  /// Custom icon for decrement button
  final IconData? decrementIcon;
  /// Color for increment/decrement buttons
  final Color? numberButtonColor;
  /// Background color for increment/decrement buttons
  final Color? numberButtonBackgroundColor;

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
    this.suffixButton,
    this.keyboardType,
    this.style,
    this.labelPosition = ModTextBoxLabelPosition.top,
    this.floatingLabel = false,
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
    this.textInputAction,
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
    this.size = ModTextBoxSize.md,
    this.fixedHeight,
    this.multiline = false,
    this.autoHeight = false,
    this.enableEnterAction = false,
    this.enterOnPressed,
    this.showBorder = false,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth = 1.0,
    this.numberMode = false,
    this.numberButtonPosition = ModTextBoxNumberButtonPosition.leftRight,
    this.minValue,
    this.maxValue,
    this.step = 1,
    this.decimalPlaces = 0,
    this.incrementIcon,
    this.decrementIcon,
    this.numberButtonColor,
    this.numberButtonBackgroundColor,
  });

  @override
  State<ModTextBox> createState() => _ModTextBoxState();
}

class _ModTextBoxState extends State<ModTextBox> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  bool _obscureText = true;
  bool _hasFocus = false;
  bool _showValidationError = false;
  bool _isProcessingEnter = false;

  // Verifica se a plataforma suporta o evento Enter customizado
  bool get _shouldEnableEnterAction {
    if (!widget.enableEnterAction || widget.enterOnPressed == null) {
      return false;
    }
    // Habilitar para Web e Desktop (Windows, macOS, Linux)
    return kIsWeb ||
        defaultTargetPlatform == TargetPlatform.windows ||
        defaultTargetPlatform == TargetPlatform.macOS ||
        defaultTargetPlatform == TargetPlatform.linux;
  }

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

    // Inicializar o focusNode
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChange);

    // Registrar o handler de teclas para o evento Enter
    if (widget.enableEnterAction && widget.enterOnPressed != null) {
      _focusNode.onKeyEvent = _onKeyEvent;
    }
  }

  Future<void> _handleEnterKey() async {
    if (_isProcessingEnter || widget.enterOnPressed == null) return;

    setState(() {
      _isProcessingEnter = true;
    });

    try {
      await widget.enterOnPressed!();
    } finally {
      if (mounted) {
        setState(() {
          _isProcessingEnter = false;
        });
      }
    }
  }

  KeyEventResult _onKeyEvent(FocusNode node, KeyEvent event) {
    if (!_shouldEnableEnterAction) {
      return KeyEventResult.ignored;
    }

    // Detectar tecla Enter (KeyDown para evitar duplicação)
    if (event is KeyDownEvent &&
        (event.logicalKey == LogicalKeyboardKey.enter ||
            event.logicalKey == LogicalKeyboardKey.numpadEnter)) {
      // Se for multiline, não interceptar o Enter (permite nova linha)
      if (widget.multiline) {
        return KeyEventResult.ignored;
      }

      _handleEnterKey();
      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }

  void _onFocusChange() {
    if (mounted) {
      setState(() {
        _hasFocus = _focusNode.hasFocus;
        if (!_hasFocus) {
          _showValidationError = true;
        }
      });
    }
  }

  // Métodos para modo numérico
  num _getCurrentValue() {
    final text = _controller.text.trim();
    if (text.isEmpty) return 0;
    return num.tryParse(text) ?? 0;
  }

  String _formatValue(num value) {
    if (widget.decimalPlaces == 0) {
      return value.toInt().toString();
    }
    return value.toStringAsFixed(widget.decimalPlaces);
  }

  void _increment() {
    num currentValue = _getCurrentValue();
    num newValue = currentValue + widget.step;

    if (widget.maxValue != null && newValue > widget.maxValue!) {
      newValue = widget.maxValue!;
    }

    final formattedValue = _formatValue(newValue);
    _controller.text = formattedValue;
    widget.onChange?.call(formattedValue);
  }

  void _decrement() {
    num currentValue = _getCurrentValue();
    num newValue = currentValue - widget.step;

    if (widget.minValue != null && newValue < widget.minValue!) {
      newValue = widget.minValue!;
    }

    final formattedValue = _formatValue(newValue);
    _controller.text = formattedValue;
    widget.onChange?.call(formattedValue);
  }

  List<TextInputFormatter> _getInputFormatters() {
    if (!widget.numberMode) {
      return widget.inputFormatters ?? [];
    }

    final List<TextInputFormatter> formatters = [];

    if (widget.decimalPlaces == 0) {
      // Apenas inteiros (permite números negativos se minValue for nulo ou negativo)
      if (widget.minValue == null || widget.minValue! < 0) {
        formatters.add(FilteringTextInputFormatter.allow(RegExp(r'^-?\d*$')));
      } else {
        formatters.add(FilteringTextInputFormatter.digitsOnly);
      }
    } else {
      // Permite decimais
      if (widget.minValue == null || widget.minValue! < 0) {
        formatters.add(FilteringTextInputFormatter.allow(RegExp(r'^-?\d*\.?\d*$')));
      } else {
        formatters.add(FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')));
      }
    }

    // Adiciona formatters adicionais passados pelo usuário
    if (widget.inputFormatters != null) {
      formatters.addAll(widget.inputFormatters!);
    }

    return formatters;
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    // Remover o handler de teclas se foi registrado
    if (widget.enableEnterAction && widget.enterOnPressed != null) {
      _focusNode.onKeyEvent = null;
    }
    // Só dispose do focusNode se ele foi criado internamente
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  double _getHeight() {
    if (widget.fixedHeight != null) {
      return widget.fixedHeight!;
    }

    if (widget.multiline && !widget.autoHeight) {
      switch (widget.size) {
        case ModTextBoxSize.lg:
          return 120;
        case ModTextBoxSize.md:
          return 100;
        case ModTextBoxSize.sm:
          return 80;
        case ModTextBoxSize.xs:
          return 60;
      }
    }

    switch (widget.size) {
      case ModTextBoxSize.lg:
        return 61;
      case ModTextBoxSize.md:
        return 50;
      case ModTextBoxSize.sm:
        return 42;
      case ModTextBoxSize.xs:
        return 29;
    }
  }

  double _getFontSize() {
    switch (widget.size) {
      case ModTextBoxSize.lg:
        return 18;
      case ModTextBoxSize.md:
        return 16;
      case ModTextBoxSize.sm:
        return 14;
      case ModTextBoxSize.xs:
        return 10;
    }
  }

  double _getIconSize() {
    switch (widget.size) {
      case ModTextBoxSize.lg:
        return 24;
      case ModTextBoxSize.md:
        return 20;
      case ModTextBoxSize.sm:
        return 18;
      case ModTextBoxSize.xs:
        return 16;
    }
  }

  EdgeInsets _getContentPadding() {
    final height = _getHeight();
    final fontSize = _getFontSize();

    if (widget.multiline) {
      return const EdgeInsets.symmetric(horizontal: 12, vertical: 12);
    }

    // Calcula o padding vertical para centralizar o texto
    // Considera a altura da linha baseada no tamanho da fonte
    final lineHeight = fontSize * 1.2; // Altura da linha padrão
    final verticalPadding = (height - lineHeight) / 2;

    return EdgeInsets.symmetric(
      horizontal: 12,
      vertical: verticalPadding > 0 ? verticalPadding : 4,
    );
  }

  Widget _buildNumberButton({
    required IconData icon,
    required VoidCallback onPressed,
    required ThemeData theme,
    required bool isVertical,
  }) {
    final buttonSize = _getHeight();
    final iconSize = _getIconSize();
    final buttonColor = widget.numberButtonColor ?? theme.colorScheme.primary;
    final backgroundColor = widget.numberButtonBackgroundColor ??
        theme.colorScheme.surfaceContainerHighest;

    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(widget.borderRadius),
      child: InkWell(
        onTap: widget.enabled != false && !widget.readOnly ? onPressed : null,
        borderRadius: BorderRadius.circular(widget.borderRadius),
        child: Container(
          width: isVertical ? null : buttonSize,
          height: isVertical ? buttonSize / 2 : buttonSize,
          alignment: Alignment.center,
          child: Icon(
            icon,
            size: iconSize,
            color: widget.enabled != false && !widget.readOnly
                ? buttonColor
                : theme.disabledColor,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final maxLines = widget.isPassword
        ? 1
        : (widget.multiline ? (widget.autoHeight ? null : 10) : 1);
    final minLines = widget.multiline ? (widget.autoHeight ? 3 : null) : 1;
    final height = widget.multiline && widget.autoHeight ? null : _getHeight();
    final hasError = _showValidationError &&
        (widget.errorText != null ||
            (widget.validator != null &&
                widget.validator!(_controller.text) != null));
    final errorMessage = _showValidationError
        ? widget.errorText ??
            (widget.validator != null
                ? widget.validator!(_controller.text)
                : null)
        : null;

    // Em desktop (Windows, macOS, Linux), usar tooltip
    // Em web, iOS e Android, mostrar erro abaixo do campo
    final bool isDesktop = !kIsWeb &&
        (defaultTargetPlatform == TargetPlatform.windows ||
         defaultTargetPlatform == TargetPlatform.macOS ||
         defaultTargetPlatform == TargetPlatform.linux);

    // Definir cor de fundo padrão baseada no tema
    Color getDefaultBackgroundColor() {
      if (widget.backgroundColor != null) {
        return widget.backgroundColor!;
      }

      final brightness = theme.brightness;
      if (brightness == Brightness.dark) {
        // Para tema escuro, usar uma cor mais clara que o fundo
        return theme.scaffoldBackgroundColor.withValues(alpha: 0.7);
      } else {
        // Para tema claro, usar uma cor mais escura que o branco
        return theme.scaffoldBackgroundColor;
      }
    }

    // Definir cor da borda
    Color getBorderColor() {
      if (hasError) {
        return theme.colorScheme.error;
      }

      if (widget.borderColor != null) {
        return widget.borderColor!;
      }

      return theme.dividerColor;
    }

    Widget textField = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: height,
          child: Tooltip(
            message: hasError && isDesktop ? errorMessage ?? '' : '',
            textStyle: const TextStyle(
              fontSize: 12,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(4),
            ),
            child: TextFormField(
              controller: _controller,
              obscureText: widget.isPassword && _obscureText,
              readOnly: widget.readOnly,
              keyboardType: widget.keyboardType ??
                  (widget.numberMode
                      ? (widget.decimalPlaces > 0
                          ? const TextInputType.numberWithOptions(decimal: true, signed: true)
                          : const TextInputType.numberWithOptions(signed: true))
                      : (widget.multiline
                          ? TextInputType.multiline
                          : TextInputType.text)),
              style: widget.style?.copyWith(fontSize: _getFontSize()) ??
                  TextStyle(fontSize: _getFontSize()),
              inputFormatters: _getInputFormatters(),
              textAlign: widget.numberMode && widget.textAlign == TextAlign.start
                  ? TextAlign.center
                  : widget.textAlign,
              validator: widget.validator,
              autovalidateMode: widget.autovalidateMode,
              autocorrect: widget.autocorrect,
              autofocus: widget.autofocus,
              cursorColor: widget.cursorColor,
              cursorHeight: widget.cursorHeight,
              enabled: widget.enabled,
              expands: widget.expands,
              textInputAction: widget.textInputAction,
              focusNode: _focusNode,
              maxLength: widget.maxLength,
              maxLines: maxLines,
              minLines: minLines,
              onTapOutside: widget.onTapOutside as TapRegionCallback?,
              onEditingComplete: widget.onEditingComplete,
              onSaved: widget.onSaved,
              onTap: widget.onTap,
              onFieldSubmitted: widget.onFieldSubmitted,
              decoration: InputDecoration(
                isDense: true,
                contentPadding: _getContentPadding(),
                hintText: widget.hint,
                labelText: widget.floatingLabel ? widget.label : null,
                labelStyle: widget.floatingLabel
                    ? TextStyle(fontSize: _getFontSize())
                    : null,
                hintStyle: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: _getFontSize(),
                  height: 1.0,
                ),
                errorStyle: const TextStyle(height: 0, fontSize: 0),
                errorText: null,
                filled: true,
                fillColor: getDefaultBackgroundColor(),
                prefixIcon: widget.prefixIcon != null
                    ? IconTheme(
                        data: IconThemeData(size: _getIconSize()),
                        child: widget.prefixIcon!,
                      )
                    : null,
                suffixIcon: widget.isPassword
                    ? IconButton(
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility
                              : Icons.visibility_off,
                          size: _getIconSize(),
                        ),
                        onPressed: () {
                          if (mounted) {
                            setState(() => _obscureText = !_obscureText);
                          }
                        })
                    : widget.suffixButton ??
                        (widget.suffixIcon != null
                            ? IconTheme(
                                data: IconThemeData(size: _getIconSize()),
                                child: widget.suffixIcon!,
                              )
                            : null),
                border: widget.showBorder
                    ? OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(widget.borderRadius),
                        borderSide: BorderSide(
                          color: getBorderColor(),
                          width: widget.borderWidth,
                        ),
                      )
                    : OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(widget.borderRadius),
                        borderSide: BorderSide.none,
                      ),
                enabledBorder: widget.showBorder
                    ? OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(widget.borderRadius),
                        borderSide: BorderSide(
                          color: getBorderColor(),
                          width: widget.borderWidth,
                        ),
                      )
                    : OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(widget.borderRadius),
                        borderSide: BorderSide.none,
                      ),
                focusedBorder: widget.showBorder
                    ? OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(widget.borderRadius),
                        borderSide: BorderSide(
                          color: hasError
                              ? theme.colorScheme.error
                              : (widget.borderColor ??
                                  theme.colorScheme.primary),
                          width: widget.borderWidth,
                        ),
                      )
                    : OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(widget.borderRadius),
                        borderSide: BorderSide.none,
                      ),
                errorBorder: widget.showBorder
                    ? OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(widget.borderRadius),
                        borderSide: BorderSide(
                          color: theme.colorScheme.error,
                          width: widget.borderWidth,
                        ),
                      )
                    : OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(widget.borderRadius),
                        borderSide: BorderSide.none,
                      ),
                focusedErrorBorder: widget.showBorder
                    ? OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(widget.borderRadius),
                        borderSide: BorderSide(
                          color: theme.colorScheme.error,
                          width: widget.borderWidth,
                        ),
                      )
                    : OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(widget.borderRadius),
                        borderSide: BorderSide.none,
                      ),
                floatingLabelBehavior: widget.floatingLabel
                    ? FloatingLabelBehavior.auto
                    : FloatingLabelBehavior.never,
              ),
            ),
          ),
        ),
        if (!isDesktop && hasError && errorMessage != null)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 12),
            child: Text(
              errorMessage,
              style: TextStyle(
                color: theme.colorScheme.error,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );

    // Wrap textField with number buttons if numberMode is enabled
    if (widget.numberMode) {
      final decrementIcon = widget.decrementIcon ??
          (widget.numberButtonPosition == ModTextBoxNumberButtonPosition.topBottom
              ? Icons.keyboard_arrow_down
              : Icons.remove);
      final incrementIcon = widget.incrementIcon ??
          (widget.numberButtonPosition == ModTextBoxNumberButtonPosition.topBottom
              ? Icons.keyboard_arrow_up
              : Icons.add);

      if (widget.numberButtonPosition == ModTextBoxNumberButtonPosition.leftRight) {
        textField = Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildNumberButton(
              icon: decrementIcon,
              onPressed: _decrement,
              theme: theme,
              isVertical: false,
            ),
            const SizedBox(width: 4),
            Expanded(child: textField),
            const SizedBox(width: 4),
            _buildNumberButton(
              icon: incrementIcon,
              onPressed: _increment,
              theme: theme,
              isVertical: false,
            ),
          ],
        );
      } else {
        // topBottom position
        textField = Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildNumberButton(
              icon: incrementIcon,
              onPressed: _increment,
              theme: theme,
              isVertical: true,
            ),
            const SizedBox(height: 2),
            textField,
            const SizedBox(height: 2),
            _buildNumberButton(
              icon: decrementIcon,
              onPressed: _decrement,
              theme: theme,
              isVertical: true,
            ),
          ],
        );
      }
    }

    if (widget.label == null) {
      return SizedBox(width: widget.width, child: textField);
    }

    // Se floatingLabel for true, usar apenas o labelText do InputDecoration
    if (widget.floatingLabel) {
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
          const SizedBox(height: 2),
          textField,
        ],
      ),
    );
  }
}
