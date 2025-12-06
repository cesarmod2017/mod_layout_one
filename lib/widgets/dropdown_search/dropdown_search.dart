import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum ModDropdownSearchSize { lg, md, sm, xs }

enum ModDropdownSearchLabelPosition { top, inside }

/// Helper class to hold the calculated dropdown position information
class _DropdownPosition {
  final bool openAbove;
  final bool openToSide;
  final Alignment sideAlignment;
  final double spaceBelow;
  final double spaceAbove;
  final double spaceRight;
  final double spaceLeft;

  const _DropdownPosition({
    required this.openAbove,
    required this.openToSide,
    required this.sideAlignment,
    required this.spaceBelow,
    required this.spaceAbove,
    required this.spaceRight,
    required this.spaceLeft,
  });
}

class ModDropdownSearchMenuItem<T> extends DropdownMenuItem<T> {
  final IconData? icon;
  final String? imageUrl;
  final String Function(T)? displayStringForOption;

  const ModDropdownSearchMenuItem({
    required super.value,
    required super.child,
    this.icon,
    this.imageUrl,
    this.displayStringForOption,
    super.key,
    super.enabled,
    super.alignment,
    super.onTap,
  });
}

class ModDropdownSearch<T> extends StatefulWidget {
  final List<ModDropdownSearchMenuItem<T>> items;
  final T? value;
  final ModDropdownSearchSize size;
  final ModDropdownSearchLabelPosition labelPosition;
  final String? label;
  final String? hint;
  final String? searchHint;
  final double borderRadius;
  final bool multiSelect;
  final Function(T?)? onChanged;
  final String? Function(T?)? validator;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? errorText;
  final bool enabled;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? iconColor;
  final Color? borderColor;
  final Color? dropdownBackgroundColor;
  final Color? searchBackgroundColor;
  final Widget? checkIcon;
  final String? closeButtonText;
  final EdgeInsetsGeometry? searchBoxPadding;
  final InputDecoration? searchDecoration;
  final double? dropdownHeight;
  final String Function(T)? displayStringForOption;
  final bool hasBorder;
  final double borderWidth;
  final double? fontSize;
  final double? iconSize;
  final bool floatingLabel;
  final Color? floatingLabelBackgroundColor;
  final bool searchEnabled;
  final Widget Function(T)? selectedItemBuilder;

  /// Background color for hovered/highlighted items in the dropdown list.
  /// If not specified, uses the theme's hover color.
  final Color? backgroundHover;

  const ModDropdownSearch({
    super.key,
    required this.items,
    this.value,
    this.size = ModDropdownSearchSize.md,
    this.labelPosition = ModDropdownSearchLabelPosition.top,
    this.label,
    this.hint,
    this.searchHint,
    this.borderRadius = 8.0,
    this.multiSelect = false,
    this.onChanged,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.errorText,
    this.enabled = true,
    this.backgroundColor,
    this.textColor,
    this.iconColor,
    this.borderColor,
    this.dropdownBackgroundColor,
    this.searchBackgroundColor,
    this.checkIcon,
    this.closeButtonText,
    this.searchBoxPadding,
    this.searchDecoration,
    this.dropdownHeight,
    this.displayStringForOption,
    this.hasBorder = false,
    this.borderWidth = 1.0,
    this.fontSize,
    this.iconSize,
    this.floatingLabel = false,
    this.floatingLabelBackgroundColor = Colors.transparent,
    this.searchEnabled = true,
    this.selectedItemBuilder,
    this.backgroundHover,
  });

  @override
  State<ModDropdownSearch<T>> createState() => _ModDropdownSearchState<T>();
}

class _ModDropdownSearchState<T> extends State<ModDropdownSearch<T>> {
  final LayerLink _layerLink = LayerLink();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final FocusNode _searchFocusNode = FocusNode();
  bool _isOpen = false;
  List<T> _selectedItems = [];
  OverlayEntry? _overlayEntry;
  List<ModDropdownSearchMenuItem<T>> _filteredItems = [];

  /// Index of the currently highlighted item for keyboard navigation (-1 means no selection)
  int _highlightedIndex = -1;

  bool get _shouldFloatLabel {
    // Debug para verificar o estado
    final shouldFloat =
        widget.floatingLabel && (_isOpen || _selectedItems.isNotEmpty);
    return shouldFloat;
  }

  String _getDisplayString(T value) {
    if (widget.displayStringForOption != null) {
      return widget.displayStringForOption!(value);
    }

    final item = widget.items.firstWhere(
      (item) => item.value == value,
      orElse: () => widget.items.first,
    );

    if (item.displayStringForOption != null) {
      return item.displayStringForOption!(value);
    }

    return value.toString();
  }

  @override
  void initState() {
    super.initState();
    if (widget.value != null && !widget.multiSelect) {
      _selectedItems = [widget.value as T];
    }
    _filteredItems = widget.items;

    // Força rebuild após primeiro frame para garantir que estado esteja correto
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // As animações agora são feitas pelos widgets AnimatedPositioned e AnimatedScale
  }

  @override
  void didUpdateWidget(ModDropdownSearch<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Atualiza selectedItems se o value mudou
    if (widget.value != oldWidget.value) {
      if (widget.value != null && !widget.multiSelect) {
        _selectedItems = [widget.value as T];
      } else if (widget.value == null) {
        _selectedItems = [];
      }
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    _searchFocusNode.dispose();
    _overlayEntry?.remove();
    super.dispose();
  }

  void _toggleDropdown() {
    if (_isOpen) {
      _closeDropdown();
    } else {
      _openDropdown();
    }
  }

  double _getHeight() {
    switch (widget.size) {
      case ModDropdownSearchSize.lg:
        return 58; // Valor original mantido
      case ModDropdownSearchSize.md:
        return 47; // Valor original mantido
      case ModDropdownSearchSize.sm:
        return 39; // Valor original mantido
      case ModDropdownSearchSize.xs:
        return 25; // Valor original mantido
    }
  }

  double _getFontSize() {
    switch (widget.size) {
      case ModDropdownSearchSize.lg:
        return 18;
      case ModDropdownSearchSize.md:
        return 16;
      case ModDropdownSearchSize.sm:
        return 14;
      case ModDropdownSearchSize.xs:
        return 10;
    }
  }

  double _getIconSize() {
    switch (widget.size) {
      case ModDropdownSearchSize.lg:
        return 24;
      case ModDropdownSearchSize.md:
        return 20;
      case ModDropdownSearchSize.sm:
        return 18;
      case ModDropdownSearchSize.xs:
        return 16;
    }
  }

  EdgeInsets _getContentPadding() {
    final height = _getHeight();
    final fontSize = widget.fontSize ?? _getFontSize();

    // Calcula o padding vertical para centralizar o texto
    // Usa multiplicador otimizado para acomodar caracteres com descendentes (p, g, j, y, q)
    // sem desperdiçar espaço vertical
    final lineHeight = fontSize * 1.35; // Valor otimizado para descendentes
    final calculatedPadding = (height - lineHeight) / 2;

    // Define padding mínimo baseado no tamanho para garantir espaço para descendentes
    final minVerticalPadding =
        widget.size == ModDropdownSearchSize.xs ? 3.0 : 5.0;
    final verticalPadding = calculatedPadding > minVerticalPadding
        ? calculatedPadding
        : minVerticalPadding;

    // Se floating label está ativo, ajusta o padding
    if (_shouldFloatLabel) {
      return EdgeInsets.fromLTRB(
        12,
        verticalPadding - 1, // Reduz padding top para dar mais espaço ao texto
        12,
        verticalPadding + 1, // Aumenta padding bottom para descendentes
      );
    }

    return EdgeInsets.symmetric(
      horizontal: 12,
      vertical: verticalPadding,
    );
  }

  Widget _buildSelectedDisplay(BuildContext context) {
    // If no items selected, show hint or empty string
    if (_selectedItems.isEmpty) {
      return Text(
        widget.floatingLabel ? '' : (widget.hint ?? ''),
        style: TextStyle(
          fontSize: widget.fontSize ?? _getFontSize(),
          color: widget.textColor ??
              Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.6),
        ),
        overflow: TextOverflow.ellipsis,
      );
    }

    // If selectedItemBuilder is provided, use it
    if (widget.selectedItemBuilder != null) {
      // For single select, use the first (only) item
      // For multi-select, wrap in a Row with all items
      if (!widget.multiSelect && _selectedItems.length == 1) {
        return widget.selectedItemBuilder!(_selectedItems.first);
      } else {
        // Multi-select: display all selected items
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: _selectedItems
                .map((item) => Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: widget.selectedItemBuilder!(item),
                    ))
                .toList(),
          ),
        );
      }
    }

    // Default behavior: show display string(s)
    return Text(
      _selectedItems.map((e) => _getDisplayString(e)).join(', '),
      style: TextStyle(
        fontSize: widget.fontSize ?? _getFontSize(),
        color:
            widget.textColor ?? Theme.of(context).textTheme.bodyMedium?.color,
      ),
      overflow: TextOverflow.ellipsis,
    );
  }

  void _openDropdown() {
    _isOpen = true;
    _highlightedIndex = -1; // Reset keyboard navigation index
    _searchController.clear(); // Clear previous search
    _filteredItems = widget.items; // Reset filtered items
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);

    if (mounted) setState(() {});

    // Auto-focus on search bar after the overlay is built
    if (widget.searchEnabled) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _isOpen) {
          _searchFocusNode.requestFocus();
        }
      });
    } else {
      // If search is disabled, focus on the main focusNode for keyboard navigation
      _focusNode.requestFocus();
    }
  }

  void _closeDropdown() {
    _isOpen = false;
    _focusNode.unfocus(); // Remove o foco
    _overlayEntry?.remove();
    _overlayEntry = null;

    if (mounted) setState(() {});
  }

  void _onItemSelected(T? value) {
    if (value == null) return;

    if (widget.multiSelect) {
      if (mounted) {
        setState(() {
          if (_selectedItems.contains(value)) {
            _selectedItems.remove(value);
          } else {
            _selectedItems.add(value);
          }
        });
      }

      widget.onChanged?.call(value);
      _updateOverlay();
    } else {
      if (mounted) {
        setState(() {
          _selectedItems = [value];
        });
      }

      widget.onChanged?.call(value);
      _closeDropdown();
    }
  }

  void _updateOverlay() {
    if (_overlayEntry != null) {
      _overlayEntry!.markNeedsBuild();
    }
  }

  void _updateSearch(String value) {
    if (!widget.searchEnabled) return;

    if (mounted) {
      setState(() {
        _filteredItems = widget.items
            .where((item) => _getDisplayString(item.value as T)
                .toLowerCase()
                .contains(value.toLowerCase()))
            .toList();
      });
      _updateOverlay();
    }
  }

  // Método para lidar com eventos de teclado
  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.escape) {
        if (_isOpen) {
          _closeDropdown();
          return KeyEventResult.handled;
        }
      } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
        if (_isOpen && _filteredItems.isNotEmpty) {
          setState(() {
            _highlightedIndex = (_highlightedIndex + 1) % _filteredItems.length;
          });
          _updateOverlay();
          return KeyEventResult.handled;
        }
      } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
        if (_isOpen && _filteredItems.isNotEmpty) {
          setState(() {
            _highlightedIndex = _highlightedIndex <= 0
                ? _filteredItems.length - 1
                : _highlightedIndex - 1;
          });
          _updateOverlay();
          return KeyEventResult.handled;
        }
      } else if (event.logicalKey == LogicalKeyboardKey.enter) {
        if (_isOpen &&
            _highlightedIndex >= 0 &&
            _highlightedIndex < _filteredItems.length) {
          _onItemSelected(_filteredItems[_highlightedIndex].value);
          return KeyEventResult.handled;
        }
      }
    }
    return KeyEventResult.ignored;
  }

  /// Calculates the best position for the dropdown based on available screen space
  _DropdownPosition _calculateDropdownPosition(
    RenderBox renderBox,
    Size screenSize,
    double dropdownHeight,
  ) {
    final position = renderBox.localToGlobal(Offset.zero);
    final widgetSize = renderBox.size;
    final widgetHeight = _getHeight();

    // Calculate available space in each direction
    final spaceBelow = screenSize.height - position.dy - widgetHeight;
    final spaceAbove = position.dy;
    final spaceRight = screenSize.width - position.dx - widgetSize.width;
    final spaceLeft = position.dx;

    // Determine vertical direction
    bool openAbove = false;
    bool openToSide = false;
    Alignment sideAlignment = Alignment.topLeft;

    // Check if dropdown fits below
    if (spaceBelow >= dropdownHeight) {
      // Fits below - default behavior
      openAbove = false;
    } else if (spaceAbove >= dropdownHeight) {
      // Fits above
      openAbove = true;
    } else if (spaceRight >= widgetSize.width &&
        (spaceBelow + spaceAbove >= dropdownHeight ||
            screenSize.height * 0.5 >= dropdownHeight)) {
      // Open to the right side
      openToSide = true;
      sideAlignment = Alignment.topLeft;
    } else if (spaceLeft >= widgetSize.width &&
        (spaceBelow + spaceAbove >= dropdownHeight ||
            screenSize.height * 0.5 >= dropdownHeight)) {
      // Open to the left side
      openToSide = true;
      sideAlignment = Alignment.topRight;
    } else {
      // Not enough space anywhere, choose the direction with most space
      if (spaceAbove > spaceBelow) {
        openAbove = true;
      }
    }

    return _DropdownPosition(
      openAbove: openAbove,
      openToSide: openToSide,
      sideAlignment: sideAlignment,
      spaceBelow: spaceBelow,
      spaceAbove: spaceAbove,
      spaceRight: spaceRight,
      spaceLeft: spaceLeft,
    );
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;
    final screenSize = MediaQuery.of(context).size;

    // Calculate item height based on ListTile default height
    double itemHeight = 48.0; // Default ListTile height
    double searchBoxHeight =
        widget.searchEnabled ? 56.0 : 0.0; // Approximate search box height
    double closeButtonHeight =
        widget.multiSelect ? 56.0 : 0.0; // Close button height

    // Calculate the actual list height based on number of items
    // Use the smaller of: max 5 items height, actual items height, or custom dropdownHeight
    int maxVisibleItems = 5;
    int actualItemCount = _filteredItems.length;
    double maxListHeight = itemHeight * maxVisibleItems;
    double actualItemsHeight = itemHeight * actualItemCount;

    double defaultListHeight = widget.dropdownHeight ??
        (actualItemsHeight < maxListHeight ? actualItemsHeight : maxListHeight);

    double totalDropdownHeight =
        defaultListHeight + searchBoxHeight + closeButtonHeight;

    // Calculate the best position for the dropdown
    final dropdownPosition = _calculateDropdownPosition(
      renderBox,
      screenSize,
      totalDropdownHeight,
    );

    // Constrain dropdown height to available space
    double constrainedHeight = defaultListHeight;
    if (!dropdownPosition.openToSide) {
      final availableSpace = dropdownPosition.openAbove
          ? dropdownPosition.spaceAbove - 3
          : dropdownPosition.spaceBelow - 3;
      final availableListHeight =
          availableSpace - searchBoxHeight - closeButtonHeight;
      if (availableListHeight < constrainedHeight && availableListHeight > 0) {
        constrainedHeight = availableListHeight;
      }
    }

    // Calculate the actual total height of the dropdown popup
    final actualDropdownHeight =
        constrainedHeight + searchBoxHeight + closeButtonHeight;

    // Calculate offset based on position
    Offset dropdownOffset;
    if (dropdownPosition.openToSide) {
      if (dropdownPosition.sideAlignment == Alignment.topLeft) {
        // Open to the right
        dropdownOffset = Offset(size.width + 4, 0);
      } else {
        // Open to the left
        dropdownOffset = Offset(-size.width - 4, 0);
      }
    } else if (dropdownPosition.openAbove) {
      // Open above - position so popup's bottom edge is at the top of the dropdown widget
      dropdownOffset = Offset(0.0, -actualDropdownHeight - 3);
    } else {
      // Open below (default)
      dropdownOffset = Offset(0.0, _getHeight() + 3);
    }

    return OverlayEntry(
      builder: (context) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          // Clique fora da área do dropdown fecha o dropdown
          _closeDropdown();
        },
        child: Stack(
          children: [
            // Área invisível que cobre toda a tela para detectar cliques fora
            Positioned.fill(
              child: Container(
                color: Colors.transparent,
              ),
            ),
            // O dropdown propriamente dito
            Positioned(
              width: size.width,
              child: CompositedTransformFollower(
                link: _layerLink,
                showWhenUnlinked: false,
                offset: dropdownOffset,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    // Impede que cliques dentro do dropdown o fechem
                    // Este GestureDetector "consome" o tap, impedindo que chegue ao GestureDetector pai
                  },
                  child: Material(
                    elevation: 4.0,
                    borderRadius: BorderRadius.circular(widget.borderRadius),
                    child: Container(
                      decoration: BoxDecoration(
                        color: widget.dropdownBackgroundColor ??
                            Theme.of(context).scaffoldBackgroundColor,
                        borderRadius:
                            BorderRadius.circular(widget.borderRadius),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          if (widget.searchEnabled)
                            Padding(
                              padding: widget.searchBoxPadding ??
                                  const EdgeInsets.all(8.0),
                              child: Focus(
                                onKeyEvent: _handleKeyEvent,
                                child: TextField(
                                  controller: _searchController,
                                  focusNode: _searchFocusNode,
                                  decoration: widget.searchDecoration ??
                                      InputDecoration(
                                        hintText:
                                            widget.searchHint ?? 'Search...',
                                        prefixIcon: const Icon(Icons.search),
                                        suffixIcon: IconButton(
                                          icon: const Icon(Icons.clear),
                                          onPressed: () {
                                            _searchController.clear();
                                            _updateSearch('');
                                          },
                                        ),
                                        filled: true,
                                        fillColor: widget.searchBackgroundColor,
                                      ),
                                  onChanged: (value) {
                                    _highlightedIndex =
                                        -1; // Reset highlight when search changes
                                    _updateSearch(value);
                                  },
                                ),
                              ),
                            ),
                          Container(
                            constraints: BoxConstraints(
                              maxHeight: constrainedHeight,
                            ),
                            child: ListView.builder(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              itemCount: _filteredItems.length,
                              itemBuilder: (context, index) {
                                final item = _filteredItems[index];
                                final isSelected =
                                    _selectedItems.contains(item.value);
                                final isHighlighted =
                                    index == _highlightedIndex;
                                Widget? leading;
                                if (item.imageUrl != null) {
                                  leading = Image.network(
                                    item.imageUrl!,
                                    width: 24,
                                    height: 24,
                                    fit: BoxFit.cover,
                                  );
                                } else if (item.icon != null) {
                                  leading = Icon(item.icon);
                                }

                                // Get hover color from widget or theme
                                final hoverColor = widget.backgroundHover ??
                                    Theme.of(context).hoverColor;

                                return Container(
                                  color: isHighlighted ? hoverColor : null,
                                  child: ListTile(
                                    selected: isSelected,
                                    leading: leading,
                                    title: item.child,
                                    onTap: () => _onItemSelected(item.value),
                                    trailing: widget.multiSelect && isSelected
                                        ? (widget.checkIcon ??
                                            const Icon(Icons.check))
                                        : null,
                                  ),
                                );
                              },
                            ),
                          ),
                          if (widget.multiSelect)
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton(
                                onPressed: _closeDropdown,
                                child: Text(widget.closeButtonText ?? 'Close'),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Definir cor de fundo padrão baseada no tema (igual ao ModDropDown)
    Color defaultBackgroundColor;
    if (theme.brightness == Brightness.dark) {
      defaultBackgroundColor = theme.scaffoldBackgroundColor.withOpacity(0.8);
    } else {
      defaultBackgroundColor = theme.scaffoldBackgroundColor.withOpacity(0.05);
    }

    final backgroundColor = widget.backgroundColor ?? defaultBackgroundColor;
    final borderColor = widget.borderColor ?? theme.dividerColor;

    return FormField<T>(
      validator: widget.validator,
      builder: (FormFieldState<T> field) {
        return Focus(
          focusNode: _focusNode,
          onKeyEvent: _handleKeyEvent,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.label != null &&
                  widget.labelPosition == ModDropdownSearchLabelPosition.top &&
                  !widget.floatingLabel)
                Padding(
                  padding: const EdgeInsets.only(bottom: 2.0),
                  child: Text(
                    widget.label!,
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  CompositedTransformTarget(
                    link: _layerLink,
                    child: InkWell(
                      onTap: widget.enabled ? _toggleDropdown : null,
                      child: Container(
                        height: _getHeight(),
                        padding: _getContentPadding(),
                        decoration: BoxDecoration(
                          color: widget.enabled
                              ? backgroundColor
                              : Theme.of(context)
                                  .disabledColor
                                  .withOpacity(0.1),
                          borderRadius:
                              BorderRadius.circular(widget.borderRadius),
                          border: widget.hasBorder
                              ? Border.all(
                                  color: widget.errorText != null
                                      ? Theme.of(context).colorScheme.error
                                      : borderColor,
                                  width: widget.borderWidth,
                                )
                              : null,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            if (widget.prefixIcon != null) ...[
                              widget.prefixIcon!,
                              const SizedBox(width: 8),
                            ],
                            Expanded(
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: _buildSelectedDisplay(context),
                              ),
                            ),
                            if (widget.suffixIcon != null)
                              widget.suffixIcon!
                            else
                              Icon(
                                _isOpen
                                    ? Icons.arrow_drop_up
                                    : Icons.arrow_drop_down,
                                size: widget.iconSize ?? _getIconSize(),
                                color: widget.iconColor ??
                                    Theme.of(context).iconTheme.color,
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Floating Label
                  if (widget.label != null && widget.floatingLabel)
                    Positioned(
                      left: 12,
                      top: _shouldFloatLabel ? -12 : (_getHeight() - 16) / 2,
                      child: AnimatedScale(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeInOut,
                        scale: _shouldFloatLabel ? 0.75 : 1.0,
                        alignment: Alignment.centerLeft,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeInOut,
                          padding: _shouldFloatLabel
                              ? const EdgeInsets.symmetric(
                                  horizontal: 4, vertical: 2)
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
                                  ? (widget.fontSize ?? _getFontSize())
                                  : (widget.fontSize ?? _getFontSize()),
                              color: _shouldFloatLabel
                                  ? theme.textTheme.bodyMedium?.color
                                  : theme.textTheme.bodyMedium?.color
                                      ?.withOpacity(0.6),
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
              if (widget.errorText != null || field.hasError)
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    widget.errorText ?? field.errorText ?? '',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                      fontSize: (widget.fontSize ?? _getFontSize()) - 2,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
