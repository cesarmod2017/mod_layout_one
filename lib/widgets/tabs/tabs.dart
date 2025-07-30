import 'package:flutter/material.dart';

enum TabBorderType {
  none,
  bottom,
  all,
}

enum TabAlignment {
  left,
  center,
  right,
  justify,
}

enum TabOrientation {
  horizontalTop,
  horizontalBottom,
  verticalLeft,
  verticalRight,
}

class ModTab {
  final String id;
  final String text;
  final TextStyle? style;
  final Color? backgroundColor;
  final VoidCallback? onClose;
  final bool closeable;
  final Future<bool> Function()? onClosing;

  /// A dynamic field that can store any type of object associated with this tab
  final dynamic data;

  /// Optional icon widget to display to the left of the text
  final Widget? icon;

  const ModTab({
    required this.id,
    required this.text,
    this.style,
    this.backgroundColor,
    this.onClose,
    this.closeable = false,
    this.onClosing,
    this.data,
    this.icon,
  });
}

class ModTabs extends StatefulWidget {
  final List<Widget> children;
  final List<ModTab> tabs;
  final Color selectedTabColor;
  final Color unselectedTabColor;
  final TabBorderType borderType;
  final Color selectedBackgroundColor;
  final TabAlignment alignment;
  final Color selectedTextColor;
  final Color unselectedTextColor;
  final TabOrientation orientation;
  final int initialIndex;

  /// Índice da aba selecionada, pode ser controlado externamente
  final int? selectedIndex;

  /// Callback when a tab is selected, provides both index and tab object
  final void Function(int index, ModTab tab)? onTabSelected;

  /// Callback when a tab is closed, provides both index and tab object
  final void Function(int index, ModTab tab)? onTabClose;
  final double? minTabWidth;
  final double? maxTabWidth;
  final bool enableNewTab;
  final VoidCallback? onNewTab;
  final bool shrinkToFit;
  final Widget? emptyWidget;

  const ModTabs({
    super.key,
    required this.children,
    required this.tabs,
    this.selectedTabColor = Colors.blue,
    this.unselectedTabColor = Colors.grey,
    this.borderType = TabBorderType.bottom,
    this.selectedBackgroundColor = Colors.transparent,
    this.alignment = TabAlignment.left,
    this.selectedTextColor = Colors.black,
    this.unselectedTextColor = Colors.grey,
    this.orientation = TabOrientation.horizontalTop,
    this.initialIndex = 0,
    this.selectedIndex,
    this.onTabSelected,
    this.onTabClose,
    this.minTabWidth = 60.0,
    this.maxTabWidth,
    this.enableNewTab = false,
    this.onNewTab,
    this.shrinkToFit = false,
    this.emptyWidget,
  }) : assert(children.length == tabs.length,
            'Children and tabs must have the same length');

  @override
  State<ModTabs> createState() => _ModTabsState();
}

class _ModTabsState extends State<ModTabs> {
  late int _selectedIndex;
  final ScrollController _scrollController = ScrollController();
  late List<ModTab> _tabs;
  late List<Widget> _children;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
    _tabs = List.from(widget.tabs);
    _children = List.from(widget.children);
  }

  @override
  void didUpdateWidget(ModTabs oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Atualiza o índice selecionado se for fornecido externamente
    if (widget.selectedIndex != null &&
        widget.selectedIndex != _selectedIndex) {
      _selectedIndex = widget.selectedIndex!;
    }

    // Always update the internal lists to ensure GetX updates are captured
    setState(() {
      _tabs = List.from(widget.tabs);
      _children = List.from(widget.children);

      // Ensure selected index is valid
      if (_selectedIndex >= _tabs.length) {
        _selectedIndex = _tabs.isEmpty ? -1 : _tabs.length - 1;
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _handleTabClose(int index, ModTab tab) async {
    bool canClose = true;

    if (tab.onClosing != null) {
      canClose = await tab.onClosing!();
    }

    if (canClose && mounted) {
      // Call the onTabClose callback before removing the tab
      if (widget.onTabClose != null) {
        widget.onTabClose!(index, tab);
      }

      setState(() {
        _tabs.removeAt(index);
        _children.removeAt(index);
        if (_selectedIndex >= _tabs.length) {
          _selectedIndex = _tabs.isEmpty ? -1 : _tabs.length - 1;
        }
      });

      if (tab.onClose != null) {
        tab.onClose!();
      }
    }
  }

  Widget _buildTab(int index, ModTab tab) {
    final isSelected = index == _selectedIndex;
    final textPainter = TextPainter(
      text: TextSpan(
        text: tab.text,
        style: tab.style ?? const TextStyle(),
      ),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout();

    double calculatedWidth =
        textPainter.width + 40; // Adiciona espaço para padding
    if (tab.icon != null) {
      calculatedWidth += 24; // Adiciona espaço para o ícone
    }
    if (tab.closeable) {
      calculatedWidth += 24; // Adiciona espaço para o botão de fechar
    }

    if (widget.minTabWidth != null && calculatedWidth < widget.minTabWidth!) {
      calculatedWidth = widget.minTabWidth!;
    }

    if (widget.maxTabWidth != null && calculatedWidth > widget.maxTabWidth!) {
      calculatedWidth = widget.maxTabWidth!;
    }

    final isVertical = widget.orientation == TabOrientation.verticalLeft ||
        widget.orientation == TabOrientation.verticalRight;

    return GestureDetector(
      onTap: () {
        if (_selectedIndex != index) {
          setState(() {
            _selectedIndex = index;
          });
          // Call the onTabSelected callback with both index and tab
          if (widget.onTabSelected != null) {
            widget.onTabSelected!(index, tab);
          }
        }
      },
      child: Container(
        constraints: BoxConstraints(
          minWidth: isVertical ? double.infinity : (widget.minTabWidth ?? 0),
          maxWidth: isVertical
              ? double.infinity
              : (widget.maxTabWidth ?? double.infinity),
        ),
        width: isVertical ? double.infinity : calculatedWidth,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? tab.backgroundColor ?? widget.selectedBackgroundColor
              : Colors.transparent,
          border: _getBorder(isSelected),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (tab.icon != null) ...[
              tab.icon!,
              const SizedBox(width: 8),
            ],
            Expanded(
              child: Text(
                tab.text,
                style: tab.style ??
                    TextStyle(
                      color: isSelected
                          ? widget.selectedTextColor
                          : widget.unselectedTextColor,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (tab.closeable)
              GestureDetector(
                onTap: () => _handleTabClose(index, tab),
                child: const Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Icon(
                    Icons.close,
                    size: 16,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildNewTabButton() {
    return SizedBox(
      width: 40,
      child: IconButton(
        icon: const Icon(Icons.add),
        onPressed: widget.onNewTab,
      ),
    );
  }

  Widget _buildTabs() {
    final tabList = List.generate(
      _tabs.length,
      (index) => _buildTab(index, _tabs[index]),
    );

    if (widget.enableNewTab) {
      tabList.add(_buildNewTabButton());
    }

    final isVertical = widget.orientation == TabOrientation.verticalLeft ||
        widget.orientation == TabOrientation.verticalRight;

    return SingleChildScrollView(
      controller: _scrollController,
      scrollDirection: isVertical ? Axis.vertical : Axis.horizontal,
      child: isVertical
          ? Column(
              mainAxisAlignment: widget.shrinkToFit
                  ? MainAxisAlignment.start
                  : _getMainAxisAlignment(),
              children: tabList,
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: widget.shrinkToFit
                  ? MainAxisAlignment.start
                  : _getMainAxisAlignment(),
              children: tabList,
            ),
    );
  }

  MainAxisAlignment _getMainAxisAlignment() {
    switch (widget.alignment) {
      case TabAlignment.left:
        return MainAxisAlignment.start;
      case TabAlignment.center:
        return MainAxisAlignment.center;
      case TabAlignment.right:
        return MainAxisAlignment.end;
      case TabAlignment.justify:
        return MainAxisAlignment.spaceBetween;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_tabs.isEmpty) {
      return widget.emptyWidget ?? Container();
    }

    // Garante que o índice selecionado seja válido
    if (_selectedIndex < 0 || _selectedIndex >= _children.length) {
      _selectedIndex = 0;
    }

    final content = _children[_selectedIndex];

    switch (widget.orientation) {
      case TabOrientation.horizontalTop:
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                _buildTabs(),
                if (_scrollController.hasClients &&
                    _scrollController.position.maxScrollExtent > 0)
                  Positioned(
                    right: 0,
                    top: 0,
                    bottom: 0,
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.chevron_left),
                          onPressed: () {
                            _scrollController.animateTo(
                              _scrollController.offset - 100,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.chevron_right),
                          onPressed: () {
                            _scrollController.animateTo(
                              _scrollController.offset + 100,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            Flexible(
              fit: FlexFit.loose,
              child: content,
            ),
          ],
        );

      case TabOrientation.horizontalBottom:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              fit: FlexFit.loose,
              child: content,
            ),
            _buildTabs(),
          ],
        );

      case TabOrientation.verticalLeft:
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 200,
              child: _buildTabs(),
            ),
            Expanded(child: content),
          ],
        );

      case TabOrientation.verticalRight:
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: content),
            SizedBox(
              width: 200,
              child: _buildTabs(),
            ),
          ],
        );
    }
  }

  Border _getBorder(bool isSelected) {
    switch (widget.borderType) {
      case TabBorderType.none:
        return Border.all(color: Colors.transparent);
      case TabBorderType.bottom:
        return Border(
          bottom: BorderSide(
            color: isSelected ? widget.selectedTabColor : Colors.transparent,
            width: 2.0,
          ),
        );
      case TabBorderType.all:
        return Border.all(
          color: isSelected ? widget.selectedTabColor : Colors.transparent,
          width: 2.0,
        );
    }
  }
}
