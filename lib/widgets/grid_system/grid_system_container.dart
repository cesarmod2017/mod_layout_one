import 'package:flutter/material.dart';

class ModContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final double? maxHeight;

  const ModContainer({
    super.key,
    required this.child,
    this.padding,
    this.backgroundColor,
    this.maxHeight,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        return Center(
          child: Container(
            width: maxWidth,
            height: maxHeight,
            padding: padding,
            color: backgroundColor,
            child: child,
          ),
        );
      },
    );
  }
}
