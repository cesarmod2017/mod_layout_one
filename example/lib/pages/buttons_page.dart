import 'package:example/main.dart';
import 'package:flutter/material.dart';
import 'package:mod_layout_one/mod_layout_one.dart';

class ButtonsPage extends StatelessWidget {
  const ButtonsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomLayout(
      title: 'Buttons',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ModCard(
              header: const Text(
                "Basic Button Examples",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Simple Button:"),
                  ModButton(
                    title: 'Simple Button',
                    type: ModButtonType.custom,
                    backgroundColor: Colors.amber,
                    textColor: Colors.black,
                    onPressed: () async {},
                  ),
                  const Text("Button with Autosize Disabled:"),
                  ModButton(
                    title: 'Simple Button',
                    type: ModButtonType.primary,
                    autosize: false,
                    onPressed: () async {},
                  ),
                  const SizedBox(height: 16),
                  const Text("Button with Icons:"),
                  ModButton(
                    title: 'Click Me',
                    type: ModButtonType.success,
                    leftIcon: Icons.add,
                    rightIcon: Icons.arrow_forward,
                    onPressed: () async {},
                  ),
                  const SizedBox(height: 16),
                  const Text("Loading Button:"),
                  ModButton(
                    title: 'Submit',
                    type: ModButtonType.info,
                    leftIcon: Icons.save,
                    onPressed: () async {
                      await Future.delayed(const Duration(seconds: 2));
                    },
                    loadingText: 'Saving...',
                  ),
                  const Text("Border Radius Examples:"),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ModButton(
                        title: 'No Radius',
                        type: ModButtonType.primary,
                        borderRadius: 0,
                        onPressed: () async {},
                      ),
                      ModButton(
                        title: 'Small Radius',
                        type: ModButtonType.primary,
                        borderRadius: 8,
                        onPressed: () async {},
                      ),
                      ModButton(
                        title: 'Medium Radius',
                        type: ModButtonType.primary,
                        borderRadius: 16,
                        onPressed: () async {},
                      ),
                      ModButton(
                        title: 'Large Radius',
                        type: ModButtonType.primary,
                        borderRadius: 24,
                        onPressed: () async {},
                      ),
                      ModButton(
                        title: 'Pill Button',
                        type: ModButtonType.primary,
                        borderRadius: 50,
                        onPressed: () async {},
                      ),
                      SizedBox(
                        width: 250,
                        child: ModButton(
                          title: 'Pill Button',
                          leftIcon: Icons.add,
                          type: ModButtonType.primary,
                          size: ModButtonSize.xs,
                          borderRadius: 50,
                          onPressed: () async {},
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text("Different Button Types:"),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ModButton(
                        title: 'Primary',
                        type: ModButtonType.none,
                        onPressed: () async {},
                      ),
                      ModButton(
                        title: 'Primary',
                        type: ModButtonType.primary,
                        onPressed: () async {},
                      ),
                      ModButton(
                        title: 'Secondary',
                        type: ModButtonType.secondary,
                        onPressed: () async {},
                      ),
                      ModButton(
                        title: 'Success',
                        type: ModButtonType.success,
                        onPressed: () async {},
                      ),
                      ModButton(
                        title: 'Warning',
                        type: ModButtonType.warning,
                        onPressed: () async {},
                      ),
                      ModButton(
                        title: 'Danger',
                        type: ModButtonType.danger,
                        onPressed: () async {},
                      ),
                      ModButton(
                        title: 'Dark',
                        type: ModButtonType.dark,
                        onPressed: () async {},
                      ),
                      ModButton(
                        title: 'Default',
                        type: ModButtonType.defaultType,
                        textColor: Colors.black,
                        onPressed: () async {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text("Border Types:"),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ModButton(
                        title: 'Solid Border',
                        type: ModButtonType.primary,
                        borderType: ModBorderType.solid,
                        onPressed: () async {},
                      ),
                      ModButton(
                        title: 'No Border',
                        type: ModButtonType.primary,
                        borderType: ModBorderType.none,
                        onPressed: () async {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                      "Transparent Buttons with Different Border Colors:"),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ModButton(
                        title: 'Primary Border',
                        type: ModButtonType.none,
                        borderType: ModBorderType.solid,
                        borderColor: ModButtonType.primary,
                        textColor: Colors.blue,
                        onPressed: () async {},
                      ),
                      ModButton(
                        title: 'Success Border',
                        type: ModButtonType.none,
                        borderType: ModBorderType.solid,
                        borderColor: ModButtonType.success,
                        textColor: Colors.green,
                        onPressed: () async {},
                      ),
                      ModButton(
                        title: 'Warning Border',
                        type: ModButtonType.none,
                        borderType: ModBorderType.solid,
                        borderColor: ModButtonType.warning,
                        textColor: Colors.orange,
                        onPressed: () async {},
                      ),
                      ModButton(
                        title: 'Danger Border',
                        type: ModButtonType.none,
                        borderType: ModBorderType.solid,
                        borderColor: ModButtonType.danger,
                        textColor: Colors.red,
                        onPressed: () async {},
                      ),
                      ModButton(
                        title: 'Dark Border',
                        type: ModButtonType.none,
                        borderType: ModBorderType.solid,
                        borderColor: ModButtonType.dark,
                        textColor: Colors.black87,
                        onPressed: () async {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text("Disabled Buttons:"),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ModButton(
                        title: 'Disabled Primary',
                        type: ModButtonType.primary,
                        disabled: true,
                        onPressed: () async {},
                      ),
                      ModButton(
                        title: 'Disabled Success',
                        type: ModButtonType.success,
                        disabled: true,
                        onPressed: () async {},
                      ),
                      ModButton(
                        title: 'Disabled Warning',
                        type: ModButtonType.warning,
                        disabled: true,
                        onPressed: () async {},
                      ),
                      ModButton(
                        title: 'Disabled with Icons',
                        type: ModButtonType.info,
                        leftIcon: Icons.block,
                        rightIcon: Icons.warning,
                        disabled: true,
                        onPressed: () async {},
                      ),
                      ModButton(
                        title: 'Disabled Border',
                        type: ModButtonType.none,
                        borderType: ModBorderType.solid,
                        borderColor: ModButtonType.primary,
                        disabled: true,
                        onPressed: () async {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text("Button Sizes:"),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ModButton(
                        title: 'Large Button',
                        type: ModButtonType.primary,
                        size: ModButtonSize.lg,
                        onPressed: () async {},
                      ),
                      ModButton(
                        title: 'Medium Button',
                        type: ModButtonType.primary,
                        size: ModButtonSize.md,
                        onPressed: () async {},
                      ),
                      ModButton(
                        title: 'Small Button',
                        type: ModButtonType.primary,
                        size: ModButtonSize.sm,
                        onPressed: () async {},
                      ),
                      ModButton(
                        title: 'Extra Small',
                        type: ModButtonType.primary,
                        size: ModButtonSize.xs,
                        onPressed: () async {},
                      ),
                      ModButton(
                        title: 'Large with Icons',
                        type: ModButtonType.success,
                        size: ModButtonSize.lg,
                        leftIcon: Icons.add,
                        rightIcon: Icons.arrow_forward,
                        onPressed: () async {},
                      ),
                      ModButton(
                        title: 'Small with Icons',
                        type: ModButtonType.success,
                        size: ModButtonSize.sm,
                        leftIcon: Icons.add,
                        rightIcon: Icons.arrow_forward,
                        onPressed: () async {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
