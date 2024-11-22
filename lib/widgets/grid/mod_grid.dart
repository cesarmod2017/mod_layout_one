import 'package:flutter/material.dart';

class ModGrid extends StatelessWidget {
  final int itemCount;
  final Widget Function(BuildContext, int) itemBuilder;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final double childAspectRatio;
  final int largeCols;
  final int mediumCols;
  final int smallCols;
  final int mobileCols;

  const ModGrid({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.mainAxisSpacing = 8.0,
    this.crossAxisSpacing = 8.0,
    this.childAspectRatio = 1.0,
    this.largeCols = 4,
    this.mediumCols = 3,
    this.smallCols = 2,
    this.mobileCols = 1,
  });

  int _getColumnCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (width > 1200) {
      return largeCols;
    } else if (width > 900) {
      return mediumCols;
    } else if (width > 600) {
      return smallCols;
    } else {
      return mobileCols;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _getColumnCount(context),
        childAspectRatio: childAspectRatio,
        crossAxisSpacing: crossAxisSpacing,
        mainAxisSpacing: mainAxisSpacing,
      ),
      itemCount: itemCount,
      itemBuilder: itemBuilder,
    );
  }
}
