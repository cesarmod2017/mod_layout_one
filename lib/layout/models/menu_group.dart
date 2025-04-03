import 'package:flutter/material.dart';
import 'package:mod_layout_one/layout/models/menu_item.dart';

class MenuGroup {
  final Widget title;
  final List<MenuItem> items;

  const MenuGroup({
    required this.title,
    required this.items,
  });
}
