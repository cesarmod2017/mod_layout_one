import 'package:flutter/material.dart';

enum UnitPosition {
  left, // Ex: R$ 100,00
  right, // Ex: 100,00%
}

class ModChartDataItem {
  final String label;
  final double value;
  final Color? color;

  ModChartDataItem({
    required this.label,
    required this.value,
    this.color,
  });

  factory ModChartDataItem.fromJson(Map<String, dynamic> json) {
    return ModChartDataItem(
      label: json['label'] as String,
      value: (json['value'] as num).toDouble(),
    );
  }
}

class ModChartData {
  final String title;
  final String period;
  final String unit;
  final UnitPosition unitPosition;
  final DateTime? updatedAt;
  final List<ModChartDataItem> data;
  final double? maxHint;

  ModChartData({
    required this.title,
    required this.period,
    this.unit = '',
    this.unitPosition = UnitPosition.right,
    this.updatedAt,
    required this.data,
    this.maxHint,
  });

  factory ModChartData.fromJson(Map<String, dynamic> json) {
    return ModChartData(
      title: json['title'] as String,
      period: json['period'] as String,
      unit: json['unit'] as String? ?? '',
      unitPosition: json['unitPosition'] != null
          ? UnitPosition.values.firstWhere(
              (e) => e.name == json['unitPosition'],
              orElse: () => UnitPosition.right,
            )
          : UnitPosition.right,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
      data: (json['data'] as List<dynamic>)
          .map(
              (item) => ModChartDataItem.fromJson(item as Map<String, dynamic>))
          .toList(),
      maxHint:
          json['maxHint'] != null ? (json['maxHint'] as num).toDouble() : null,
    );
  }
}

class ChartActionButton {
  final String title;
  final VoidCallback onPressed;
  final bool isSelected;
  final TextStyle? textStyle;

  ChartActionButton({
    required this.title,
    required this.onPressed,
    this.isSelected = false,
    this.textStyle,
  });
}
