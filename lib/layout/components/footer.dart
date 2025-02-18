import 'package:flutter/material.dart';

class ModFooter extends StatelessWidget {
  final Widget? child;
  final Color? backgroundColor;
  final double height;
  final EdgeInsetsGeometry padding;
  final Border? border;
  const ModFooter({
    super.key,
    this.child,
    this.backgroundColor,
    this.height = 50.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor ?? Theme.of(context).drawerTheme.backgroundColor,
        border: border,
      ),
      child: child,
    );
  }
}
