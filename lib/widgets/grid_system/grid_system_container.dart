import 'package:flutter/material.dart';

class ModContainer extends StatelessWidget {
  final Widget child;
  final bool fluid;
  final EdgeInsetsGeometry? padding;

  const ModContainer({
    super.key,
    required this.child,
    this.fluid = false,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        return Center(
          child: Container(
            width: maxWidth,
            padding: padding,
            child: child,
          ),
        );
      },
    );
  }
}
