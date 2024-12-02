import 'package:flutter/material.dart';

enum ModDropdownSearchSize { lg, md, sm, xs }

enum ModDropdownSearchLabelPosition { top, inside }

class ModDropdownSearchMenuItem<T> extends DropdownMenuItem<T> {
  final IconData? icon;
  final String? imageUrl;

  const ModDropdownSearchMenuItem({
    required super.value,
    required super.child,
    this.icon,
    this.imageUrl,
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

  const ModDropdownSearch({
    super.key,
    required this.items,
    this.value,
    this.size = ModDropdownSearchSize.md,
    this.labelPosition = ModDropdownSearchLabelPosition.top,
    this.label,
    this.hint,
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
  });

  @override
  State<ModDropdownSearch<T>> createState() => _ModDropdownSearchState<T>();
}

class _ModDropdownSearchState<T> extends State<ModDropdownSearch<T>> {
  final LayerLink _layerLink = LayerLink();
  final TextEditingController _searchController = TextEditingController();
  bool _isOpen = false;
  List<T> _selectedItems = [];
  OverlayEntry? _overlayEntry;
  List<ModDropdownSearchMenuItem<T>> _filteredItems = [];

  @override
  void initState() {
    super.initState();
    if (widget.value != null && !widget.multiSelect) {
      _selectedItems = [widget.value as T];
    }
    _filteredItems = widget.items;
  }

  @override
  void dispose() {
    _searchController.dispose();
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
        return 48;
      case ModDropdownSearchSize.md:
        return 39;
      case ModDropdownSearchSize.sm:
        return 33;
      case ModDropdownSearchSize.xs:
        return 25;
    }
  }

  double _getFontSize() {
    switch (widget.size) {
      case ModDropdownSearchSize.lg:
        return 16;
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

  void _openDropdown() {
    _isOpen = true;
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    setState(() {});
  }

  void _closeDropdown() {
    _isOpen = false;
    _overlayEntry?.remove();
    _overlayEntry = null;
    setState(() {});
  }

  void _onItemSelected(T? value) {
    if (value == null) return;

    if (widget.multiSelect) {
      setState(() {
        if (_selectedItems.contains(value)) {
          _selectedItems.remove(value);
        } else {
          _selectedItems.add(value);
        }
      });
      widget.onChanged?.call(value);
      _updateOverlay();
    } else {
      setState(() {
        _selectedItems = [value];
      });
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
    setState(() {
      _filteredItems = widget.items
          .where((item) =>
              item.value.toString().toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
    _updateOverlay();
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;
    var offset = renderBox.localToGlobal(Offset.zero);

    // Calculate item height based on ListTile default height
    double itemHeight = 48.0; // Default ListTile height
    double defaultListHeight = itemHeight * 5; // Height for 5 items

    return OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0.0, _getHeight() + 3),
          child: Material(
            elevation: 4.0,
            borderRadius: BorderRadius.circular(widget.borderRadius),
            child: Container(
              decoration: BoxDecoration(
                color: widget.dropdownBackgroundColor ?? Colors.transparent,
                borderRadius: BorderRadius.circular(widget.borderRadius),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        widget.searchBoxPadding ?? const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _searchController,
                      decoration: widget.searchDecoration ??
                          InputDecoration(
                            hintText: 'Search...',
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
                      onChanged: _updateSearch,
                    ),
                  ),
                  Container(
                    constraints: BoxConstraints(
                      maxHeight: widget.dropdownHeight ?? defaultListHeight,
                    ),
                    child: ListView(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      children: _filteredItems.map((item) {
                        final isSelected = _selectedItems.contains(item.value);
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
                        return ListTile(
                          selected: isSelected,
                          leading: leading,
                          title: item.child,
                          onTap: () => _onItemSelected(item.value),
                          trailing: widget.multiSelect && isSelected
                              ? (widget.checkIcon ?? const Icon(Icons.check))
                              : null,
                        );
                      }).toList(),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return FormField<T>(
      validator: widget.validator,
      builder: (FormFieldState<T> field) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.label != null &&
                widget.labelPosition == ModDropdownSearchLabelPosition.top)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  widget.label!,
                  style: theme.textTheme.bodyMedium,
                ),
              ),
            CompositedTransformTarget(
              link: _layerLink,
              child: InkWell(
                onTap: widget.enabled ? _toggleDropdown : null,
                child: Container(
                  height: _getHeight(),
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  decoration: BoxDecoration(
                    color: widget.enabled
                        ? (widget.backgroundColor ?? Colors.transparent)
                        : Theme.of(context).disabledColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(widget.borderRadius),
                    border: Border.all(
                      color: widget.errorText != null
                          ? Theme.of(context).colorScheme.error
                          : (widget.borderColor ??
                              Theme.of(context).dividerColor),
                    ),
                  ),
                  child: Row(
                    children: [
                      if (widget.prefixIcon != null) ...[
                        widget.prefixIcon!,
                        const SizedBox(width: 8),
                      ],
                      Expanded(
                        child: Text(
                          _selectedItems.isEmpty
                              ? widget.hint ?? ''
                              : _selectedItems
                                  .map((e) => e.toString())
                                  .join(', '),
                          style: TextStyle(
                            fontSize: _getFontSize(),
                            color: widget.textColor ??
                                Theme.of(context).textTheme.bodyMedium?.color,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (widget.suffixIcon != null)
                        widget.suffixIcon!
                      else
                        Icon(
                          _isOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                          size: _getIconSize(),
                          color: widget.iconColor ??
                              Theme.of(context).iconTheme.color,
                        ),
                    ],
                  ),
                ),
              ),
            ),
            if (widget.errorText != null || field.hasError)
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  widget.errorText ?? field.errorText ?? '',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                    fontSize: _getFontSize() - 2,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

/*
Exemplo de uso do ModDropdownSearch:

// Exemplo básico com strings e ícones
ModDropdownSearch<String>(
  items: [
    ModDropdownSearchMenuItem(
      value: 'Item 1',
      child: Text('Item 1'),
      icon: Icons.person
    ),
    ModDropdownSearchMenuItem(
      value: 'Item 2',
      child: Text('Item 2'),
      imageUrl: 'https://example.com/image.jpg'
    ),
    ModDropdownSearchMenuItem(
      value: 'Item 3',
      child: Text('Item 3')
    ),
  ],
  hint: 'Selecione um item',
  label: 'Items',
  onChanged: (value) => print(value),
)

// Exemplo com objetos customizados
class User {
  final int id;
  final String name;

  User(this.id, this.name);

  @override
  String toString() => name;
}

ModDropdownSearch<User>(
  items: [
    ModDropdownSearchMenuItem(
      value: User(1, 'João'),
      child: Text('João'),
      icon: Icons.person
    ),
    ModDropdownSearchMenuItem(
      value: User(2, 'Maria'),
      child: Text('Maria'),
      imageUrl: 'https://example.com/maria.jpg'
    ),
    ModDropdownSearchMenuItem(
      value: User(3, 'Pedro'),
      child: Text('Pedro')
    ),
  ],
  hint: 'Selecione um usuário',
  label: 'Usuários',
  size: ModDropdownSearchSize.lg,
  labelPosition: ModDropDownLabelPosition.inside,
  multiSelect: true,
  prefixIcon: Icon(Icons.person),
  validator: (value) {
    if (value == null) return 'Selecione um usuário';
    return null;
  },
  backgroundColor: Colors.grey[100],
  borderRadius: 12.0,
  onChanged: (user) => print(user?.name),
)

// Exemplo com validação em um Form
Form(
  child: ModDropdownSearch<String>(
    items: [
      ModDropdownSearchMenuItem(
        value: 'Item 1',
        child: Text('Item 1'),
        icon: Icons.star
      ),
      ModDropdownSearchMenuItem(
        value: 'Item 2',
        child: Text('Item 2'),
        imageUrl: 'https://example.com/item2.jpg'
      ),
    ],
    validator: (value) {
      if (value == null) return 'Campo obrigatório';
      return null;
    },
    hint: 'Selecione',
    label: 'Campo obrigatório',
  ),
)
*/
