import 'package:flutter/material.dart';
import 'package:mod_layout_one/widgets/grid_system/grid_system.dart';

class ModColumn extends StatelessWidget {
  final Widget child;
  final Map<ScreenSize, ColumnSize> columnSizes;

  const ModColumn({
    super.key,
    required this.child,
    required this.columnSizes,
  });

  double _getColumnWidth(BuildContext context, BoxConstraints constraints) {
    final width = MediaQuery.of(context).size.width;
    ScreenSize currentSize;

    if (width >= 1200) {
      currentSize = ScreenSize.xl;
    } else if (width >= 992) {
      currentSize = ScreenSize.lg;
    } else if (width >= 768) {
      currentSize = ScreenSize.md;
    } else if (width >= 576) {
      currentSize = ScreenSize.sm;
    } else {
      currentSize = ScreenSize.xs;
    }

    ColumnSize? colSize = columnSizes[currentSize];
    if (colSize == null) {
      if (currentSize == ScreenSize.xl) {
        colSize = columnSizes[ScreenSize.lg] ??
            columnSizes[ScreenSize.md] ??
            columnSizes[ScreenSize.sm] ??
            columnSizes[ScreenSize.xs];
      } else if (currentSize == ScreenSize.lg) {
        colSize = columnSizes[ScreenSize.md] ??
            columnSizes[ScreenSize.sm] ??
            columnSizes[ScreenSize.xs];
      } else if (currentSize == ScreenSize.md) {
        colSize = columnSizes[ScreenSize.sm] ?? columnSizes[ScreenSize.xs];
      } else if (currentSize == ScreenSize.sm) {
        colSize = columnSizes[ScreenSize.xs];
      }
    }

    colSize ??= ColumnSize.col12;
    return ((colSize.index + 1) / 12);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final percentage = _getColumnWidth(context, constraints);
        final columnWidth = constraints.maxWidth * percentage;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          child: SizedBox(
            width:
                columnWidth, // Removido a subtração do padding já que agora é 0
            child: child,
          ),
        );
      },
    );
  }
}
