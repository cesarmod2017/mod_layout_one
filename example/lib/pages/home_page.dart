import 'package:example/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mod_layout_one/mod_layout_one.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomLayout(
      title: 'home'.tr,
      body: Center(
        child: ModCard(
          header: Text('welcome'.tr),
          content: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('This is an example of Mod Layout One package'),
              const SizedBox(height: 20),
              ModContainer(
                child: ModRow(
                  height: 200,
                  columns: List.generate(20, (index) {
                    return ModColumn(
                      padding: const EdgeInsets.all(16),
                      columnSizes: const {
                        ScreenSize.xs: ColumnSize.col12,
                        ScreenSize.md: ColumnSize.col4,
                      },
                      child: Container(
                        color: Colors.blue.withOpacity(0.2),
                        padding: const EdgeInsets.all(16),
                        child: Text('Column ${index + 1}'),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
      footer: Row(
        children: [Text('footer'.tr), Text('footer'.tr)],
      ),
    );
  }
}
