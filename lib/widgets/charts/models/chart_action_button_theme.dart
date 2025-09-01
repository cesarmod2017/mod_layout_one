import 'package:flutter/material.dart';

class ChartActionButtonTheme {
  final double? height;
  final double? fontSize;
  final EdgeInsetsGeometry? padding;
  final double? borderRadius;
  final double? borderWidth;
  
  // Light theme colors
  final Color? lightSelectedBackgroundColor;
  final Color? lightUnselectedBackgroundColor;
  final Color? lightSelectedTextColor;
  final Color? lightUnselectedTextColor;
  final Color? lightBorderColor;
  
  // Dark theme colors
  final Color? darkSelectedBackgroundColor;
  final Color? darkUnselectedBackgroundColor;
  final Color? darkSelectedTextColor;
  final Color? darkUnselectedTextColor;
  final Color? darkBorderColor;
  
  const ChartActionButtonTheme({
    this.height,
    this.fontSize,
    this.padding,
    this.borderRadius,
    this.borderWidth,
    // Light theme
    this.lightSelectedBackgroundColor,
    this.lightUnselectedBackgroundColor,
    this.lightSelectedTextColor,
    this.lightUnselectedTextColor,
    this.lightBorderColor,
    // Dark theme
    this.darkSelectedBackgroundColor,
    this.darkUnselectedBackgroundColor,
    this.darkSelectedTextColor,
    this.darkUnselectedTextColor,
    this.darkBorderColor,
  });
  
  ChartActionButtonTheme copyWith({
    double? height,
    double? fontSize,
    EdgeInsetsGeometry? padding,
    double? borderRadius,
    double? borderWidth,
    Color? lightSelectedBackgroundColor,
    Color? lightUnselectedBackgroundColor,
    Color? lightSelectedTextColor,
    Color? lightUnselectedTextColor,
    Color? lightBorderColor,
    Color? darkSelectedBackgroundColor,
    Color? darkUnselectedBackgroundColor,
    Color? darkSelectedTextColor,
    Color? darkUnselectedTextColor,
    Color? darkBorderColor,
  }) {
    return ChartActionButtonTheme(
      height: height ?? this.height,
      fontSize: fontSize ?? this.fontSize,
      padding: padding ?? this.padding,
      borderRadius: borderRadius ?? this.borderRadius,
      borderWidth: borderWidth ?? this.borderWidth,
      lightSelectedBackgroundColor: lightSelectedBackgroundColor ?? this.lightSelectedBackgroundColor,
      lightUnselectedBackgroundColor: lightUnselectedBackgroundColor ?? this.lightUnselectedBackgroundColor,
      lightSelectedTextColor: lightSelectedTextColor ?? this.lightSelectedTextColor,
      lightUnselectedTextColor: lightUnselectedTextColor ?? this.lightUnselectedTextColor,
      lightBorderColor: lightBorderColor ?? this.lightBorderColor,
      darkSelectedBackgroundColor: darkSelectedBackgroundColor ?? this.darkSelectedBackgroundColor,
      darkUnselectedBackgroundColor: darkUnselectedBackgroundColor ?? this.darkUnselectedBackgroundColor,
      darkSelectedTextColor: darkSelectedTextColor ?? this.darkSelectedTextColor,
      darkUnselectedTextColor: darkUnselectedTextColor ?? this.darkUnselectedTextColor,
      darkBorderColor: darkBorderColor ?? this.darkBorderColor,
    );
  }
}