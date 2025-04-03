import 'package:flutter/material.dart';

class MenuItem {
  final String title;
  final IconData icon;
  final String? route;
  final List<MenuItem>? subItems;
  final String? type;
  final String? value;
  final String? url;
  final VoidCallback? onTap;

  const MenuItem({
    required this.title,
    required this.icon,
    this.route,
    this.subItems,
    this.type,
    this.value,
    this.url,
    this.onTap,
  });
}
