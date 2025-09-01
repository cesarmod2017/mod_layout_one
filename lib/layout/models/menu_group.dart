import 'package:flutter/material.dart';
import 'package:mod_layout_one/layout/models/menu_item.dart';

class MenuGroup {
  final Widget title;
  final List<MenuItem> items;
  final double? fontSize;
  final FontWeight? fontWeight;
  final double? iconSize;

  const MenuGroup({
    required this.title,
    required this.items,
    this.fontSize,
    this.fontWeight,
    this.iconSize,
  });
}
