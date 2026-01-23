import 'package:flutter/material.dart';

class MenuItem {
  /// Identificador único do item de menu.
  ///
  /// Quando fornecido, este campo é usado para determinar qual item está
  /// selecionado, permitindo distinguir entre diferentes instâncias de MenuItem
  /// que apontam para a mesma rota mas possuem argumentos distintos.
  ///
  /// Se não fornecido, a verificação de seleção usará a rota como fallback.
  final String? id;
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
  final bool reloadOnNavigate;

  const MenuItem({
    this.id,
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
    this.reloadOnNavigate = false,
  });
}
