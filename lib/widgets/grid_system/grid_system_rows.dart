import 'package:flutter/material.dart';
import 'package:mod_layout_one/widgets/grid_system/grid_system.dart';

class ModRow extends StatelessWidget {
  final List<ModColumn> columns;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final double? height;

  const ModRow({
    super.key,
    required this.columns,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final content = SizedBox(
          width: constraints.maxWidth,
          child: Wrap(
            spacing: 0,
            runSpacing: 0,
            alignment: WrapAlignment.start,
            children: columns,
          ),
        );

        if (height != null) {
          return SizedBox(
            height: height,
            child: SingleChildScrollView(
              child: content,
            ),
          );
        }

        return content;
      },
    );
  }
}
