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

class ModTabs extends StatefulWidget {
  final List<Widget> children;
  final List<Widget> tabs;
  final Color selectedTabColor;
  final Color unselectedTabColor;
  final TabBorderType borderType;
  final Color selectedBackgroundColor;
  final TabAlignment alignment;
  final Color selectedTextColor;
  final Color unselectedTextColor;
  final TabOrientation orientation;
  final int initialIndex;
  final void Function(int)? onTabSelected;

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
    this.onTabSelected,
  }) : assert(children.length == tabs.length,
            'Children and tabs must have the same length');

  @override
  State<ModTabs> createState() => _ModTabsState();
}

class _ModTabsState extends State<ModTabs> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  Widget _buildTab(int index, Widget tab) {
    final isSelected = index == _selectedIndex;

    // Make text bold if selected and tab is a Text widget
    Widget finalTab = tab;
    if (isSelected && tab is Text) {
      finalTab = Text(
        tab.data ?? '',
        style: (tab.style ?? const TextStyle()).copyWith(
          fontWeight: FontWeight.bold,
          color: widget.selectedTextColor,
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        setState(() => _selectedIndex = index);
        if (widget.onTabSelected != null) {
          widget.onTabSelected!(index);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color:
              isSelected ? widget.selectedBackgroundColor : Colors.transparent,
          border: Border(
            bottom: BorderSide(
              color: isSelected ? widget.selectedTabColor : Colors.transparent,
              width: 2.0,
            ),
          ),
        ),
        child: DefaultTextStyle(
          style: TextStyle(
            color: isSelected
                ? widget.selectedTextColor
                : widget.unselectedTextColor,
            height: 1.4,
            leadingDistribution: TextLeadingDistribution.even,
            decoration: TextDecoration.none,
            decorationColor: const Color(0xffe1e2e8),
          ),
          child: finalTab,
        ),
      ),
    );
  }

  Widget _buildTabs() {
    final tabList = List.generate(
      widget.tabs.length,
      (index) => _buildTab(index, widget.tabs[index]),
    );

    if (widget.alignment == TabAlignment.justify) {
      return Row(
        children: tabList.map((tab) => Expanded(child: tab)).toList(),
      );
    }

    if (widget.orientation == TabOrientation.horizontalTop ||
        widget.orientation == TabOrientation.horizontalBottom) {
      return Row(
        mainAxisAlignment: _getMainAxisAlignment(),
        children: tabList,
      );
    }

    return Column(
      mainAxisAlignment: _getMainAxisAlignment(),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: tabList,
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
    switch (widget.orientation) {
      case TabOrientation.horizontalTop:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTabs(),
            Flexible(
              fit: FlexFit.loose,
              child: widget.children[_selectedIndex],
            ),
          ],
        );

      case TabOrientation.horizontalBottom:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              fit: FlexFit.loose,
              child: widget.children[_selectedIndex],
            ),
            _buildTabs(),
          ],
        );

      case TabOrientation.verticalLeft:
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTabs(),
            Expanded(
              child: widget.children[_selectedIndex],
            ),
          ],
        );

      case TabOrientation.verticalRight:
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: widget.children[_selectedIndex],
            ),
            _buildTabs(),
          ],
        );
    }
  }
}
