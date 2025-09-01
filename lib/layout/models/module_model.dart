import 'package:flutter/material.dart';
import 'package:mod_layout_one/layout/models/menu_group.dart';

class ModuleMenu {
  final String name;
  final IconData? icon;
  final Widget? image;
  final String? description;
  final List<MenuGroup> menuGroups;
  final Function(ModuleMenu)? onSelect;
  final double? fontSize;
  final FontWeight? fontWeight;
  final double? iconSize;

  const ModuleMenu({
    required this.name,
    this.icon,
    this.image,
    this.description,
    required this.menuGroups,
    this.onSelect,
    this.fontSize,
    this.fontWeight,
    this.iconSize,
  });
}
