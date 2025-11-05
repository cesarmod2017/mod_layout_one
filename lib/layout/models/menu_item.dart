import 'package:flutter/material.dart';

class MenuItem {
  final String title;
  final IconData icon;
  final String? route;
  final List<MenuItem>? subItems;
  final String? type;
  final String? value;
  final String? claimName;
  final String? url;
  final VoidCallback? onTap;
  final double? fontSize;
  final FontWeight? fontWeight;
  final double? iconSize;
  final dynamic arguments;

  const MenuItem({
    required this.title,
    required this.icon,
    this.route,
    this.subItems,
    this.type,
    this.value,
    this.claimName,
    this.url,
    this.onTap,
    this.fontSize,
    this.fontWeight,
    this.iconSize,
    this.arguments,
  });
}
