import 'dart:async';

import 'package:example/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mod_layout_one/mod_layout_one.dart' as mod;

class ProgressPage extends StatelessWidget {
  const ProgressPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomLayout(
      title: 'Progress',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildBasicProgressExample(),
            const SizedBox(height: 8),
            const mod.ModCodeExample(
              code: '''// Progress Básico
final controller = Get.showProgress(
  title: "Processing...",
  subtitle: "Please wait while we process your request",
  initialProgress: 0.0,
);

// Atualiza o progresso
for (int i = 0; i <= 100; i += 10) {
  await Future.delayed(const Duration(milliseconds: 300));
  controller.updateProgress(i / 100);
  controller.updateSubtitle("Completed \$i%");
}

// Completa e fecha
controller.complete(message: "Process completed successfully!");
await Future.delayed(const Duration(seconds: 1));
controller.close();''',
            ),
            const SizedBox(height: 16),
            _buildLinearProgressExample(),
            const SizedBox(height: 8),
            const mod.ModCodeExample(
              code: '''// Progress Linear
final controller = Get.showProgress(
  title: "Downloading file...",
  subtitle: "Starting download",
  initialProgress: 0.0,
  config: const ModProgressConfig(
    type: ModProgressType.linear,
    position: ModProgressPosition.topCenter,
    linearHeight: 8.0,
  ),
);

// Atualiza o progresso
for (int i = 0; i <= 100; i += 5) {
  await Future.delayed(const Duration(milliseconds: 150));
  controller.updateProgress(i / 100);
  controller.updateSubtitle("Downloaded \${i}MB of 100MB");
}

controller.complete(message: "Download complete!");
await Future.delayed(const Duration(seconds: 1));
controller.close();''',
            ),
            const SizedBox(height: 16),
            _buildCustomPositionsExample(),
            const SizedBox(height: 16),
            _buildCustomStylingExample(),
            const SizedBox(height: 16),
            _buildStreamUpdateExample(),
            const SizedBox(height: 16),
            _buildMultipleProgressExample(),
            const SizedBox(height: 8),
            const mod.ModCodeExample(
              code: '''// Múltiplos Progress Overlays
final controller1 = Get.showProgress(
  id: "progress_1",
  title: "Task 1",
  subtitle: "Processing first task",
  initialProgress: 0.0,
  config: const ModProgressConfig(
    position: ModProgressPosition.topLeft,
    progressColor: Colors.blue,
  ),
);

final controller2 = Get.showProgress(
  id: "progress_2",
  title: "Task 2",
  subtitle: "Processing second task",
  initialProgress: 0.0,
  config: const ModProgressConfig(
    position: ModProgressPosition.topRight,
    progressColor: Colors.green,
  ),
);

// Atualiza ambos
for (int i = 0; i <= 100; i += 10) {
  await Future.delayed(const Duration(milliseconds: 200));
  controller1.updateProgress(i / 100);
  controller2.updateProgress((100 - i) / 100);
}

controller1.complete(message: "Task 1 complete!");
controller2.complete(message: "Task 2 complete!");

await Future.delayed(const Duration(seconds: 1));
Get.closeAllProgress();

// Estado de Erro
controller.setError("Connection failed: Server unavailable");''',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBasicProgressExample() {
    return mod.ModCard(
      header: const Text(
        "Basic Progress Example",
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Center(
        child: mod.ModButton(
          title: "Show Basic Progress",
          type: mod.ModButtonType.none,
          borderType: mod.ModBorderType.solid,
          borderColor: mod.ModButtonType.primary,
          onPressed: () async {
            final controller = Get.showProgress(
              title: "Processing...",
              subtitle: "Please wait while we process your request",
              initialProgress: 0.0,
            );

            for (int i = 0; i <= 100; i += 10) {
              await Future.delayed(const Duration(milliseconds: 300));
              controller.updateProgress(i / 100);
              controller.updateSubtitle("Completed $i%");
            }

            controller.complete(message: "Process completed successfully!");
            await Future.delayed(const Duration(seconds: 1));
            controller.close();
          },
        ),
      ),
    );
  }

  Widget _buildLinearProgressExample() {
    return mod.ModCard(
      header: const Text(
        "Linear Progress Bar",
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Center(
        child: mod.ModButton(
          title: "Show Linear Progress",
          type: mod.ModButtonType.none,
          borderType: mod.ModBorderType.solid,
          borderColor: mod.ModButtonType.primary,
          onPressed: () async {
            final controller = Get.showProgress(
              title: "Downloading file...",
              subtitle: "Starting download",
              initialProgress: 0.0,
              config: const mod.ModProgressConfig(
                type: mod.ModProgressType.linear,
                position: mod.ModProgressPosition.topCenter,
                linearHeight: 8.0,
              ),
            );

            for (int i = 0; i <= 100; i += 5) {
              await Future.delayed(const Duration(milliseconds: 150));
              controller.updateProgress(i / 100);
              controller.updateSubtitle("Downloaded ${i}MB of 100MB");
            }

            controller.complete(message: "Download complete!");
            await Future.delayed(const Duration(seconds: 1));
            controller.close();
          },
        ),
      ),
    );
  }

  Widget _buildCustomPositionsExample() {
    return mod.ModCard(
      header: const Text(
        "Position Examples",
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Wrap(
        spacing: 8,
        runSpacing: 8,
        alignment: WrapAlignment.center,
        children: [
          _buildPositionButton("Top Left", mod.ModProgressPosition.topLeft),
          _buildPositionButton("Top Center", mod.ModProgressPosition.topCenter),
          _buildPositionButton("Top Right", mod.ModProgressPosition.topRight),
          _buildPositionButton(
              "Bottom Left", mod.ModProgressPosition.bottomLeft),
          _buildPositionButton(
              "Bottom Center", mod.ModProgressPosition.bottomCenter),
          _buildPositionButton(
              "Bottom Right", mod.ModProgressPosition.bottomRight),
        ],
      ),
    );
  }

  Widget _buildPositionButton(String label, mod.ModProgressPosition position) {
    return mod.ModButton(
      title: label,
      type: mod.ModButtonType.none,
      borderType: mod.ModBorderType.solid,
      borderColor: mod.ModButtonType.primary,
      onPressed: () async {
        final controller = Get.showProgress(
          title: "Position: $label",
          subtitle: "This progress appears at $label",
          config: mod.ModProgressConfig(
            position: position,
          ),
        );

        await Future.delayed(const Duration(seconds: 2));
        controller.close();
      },
    );
  }

  Widget _buildCustomStylingExample() {
    return mod.ModCard(
      header: const Text(
        "Custom Styling",
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Center(
        child: mod.ModButton(
          title: "Show Styled Progress",
          type: mod.ModButtonType.none,
          borderType: mod.ModBorderType.solid,
          borderColor: mod.ModButtonType.primary,
          onPressed: () async {
            final controller = Get.showProgress(
              title: "Custom Style Progress",
              subtitle: "With custom colors and border",
              initialProgress: 0.0,
              config: const mod.ModProgressConfig(
                position: mod.ModProgressPosition.topRight,
                type: mod.ModProgressType.circular,
                backgroundColor: Color(0xFF1E1E2E),
                borderColor: Colors.purple,
                borderWidth: 2.0,
                borderRadius: 16.0,
                progressColor: Colors.purple,
                titleColor: Colors.white,
                subtitleColor: Colors.white70,
                circularSize: 32.0,
                circularStrokeWidth: 4.0,
                icon: Icons.cloud_upload,
                iconColor: Colors.purple,
              ),
            );

            for (int i = 0; i <= 100; i += 10) {
              await Future.delayed(const Duration(milliseconds: 200));
              controller.updateProgress(i / 100);
            }

            controller.complete(message: "Upload complete!");
            await Future.delayed(const Duration(seconds: 1));
            controller.close();
          },
        ),
      ),
    );
  }

  Widget _buildStreamUpdateExample() {
    return mod.ModCard(
      header: const Text(
        "Stream Update Example",
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Column(
        children: [
          const Text(
            "This example demonstrates real-time progress updates using streams, "
            "useful for gRPC streaming or other async data sources.",
            style: TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 16),
          Center(
            child: mod.ModButton(
              title: "Show Stream Progress",
              type: mod.ModButtonType.none,
              borderType: mod.ModBorderType.solid,
              borderColor: mod.ModButtonType.primary,
              onPressed: () async {
                final stream = _simulateProgressStream();

                Get.showProgressWithStream(
                  stream: stream,
                  title: "Processing data...",
                  subtitle: "Connecting to server",
                  autoCloseOnComplete: true,
                  autoCloseDelay: const Duration(seconds: 2),
                  config: const mod.ModProgressConfig(
                      borderColor: Colors.red,
                      position: mod.ModProgressPosition.topRight,
                      type: mod.ModProgressType.linear,
                      linearHeight: 12.0,
                      barrierDismissible: false,
                      showCloseButton: false),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Stream<mod.ProgressUpdate> _simulateProgressStream() async* {
    final steps = [
      "Connecting to server...",
      "Authenticating...",
      "Fetching data...",
      "Processing records...",
      "Validating results...",
      "Finalizing...",
    ];

    for (int i = 0; i < steps.length; i++) {
      yield mod.ProgressUpdate(
        subtitle: steps[i],
        progress: (i + 1) / steps.length,
      );
      await Future.delayed(const Duration(milliseconds: 800));
    }

    yield mod.ProgressUpdate.complete(message: "All tasks completed!");
  }

  Widget _buildMultipleProgressExample() {
    return mod.ModCard(
      header: const Text(
        "Multiple Progress Overlays",
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Column(
        children: [
          const Text(
            "You can show multiple independent progress overlays at different positions.",
            style: TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 16),
          Center(
            child: mod.ModButton(
              title: "Show Multiple Progress",
              type: mod.ModButtonType.none,
              borderType: mod.ModBorderType.solid,
              borderColor: mod.ModButtonType.primary,
              onPressed: () async {
                final controller1 = Get.showProgress(
                  id: "progress_1",
                  title: "Task 1",
                  subtitle: "Processing first task",
                  initialProgress: 0.0,
                  config: const mod.ModProgressConfig(
                    position: mod.ModProgressPosition.topLeft,
                    progressColor: Colors.blue,
                  ),
                );

                final controller2 = Get.showProgress(
                  id: "progress_2",
                  title: "Task 2",
                  subtitle: "Processing second task",
                  initialProgress: 0.0,
                  config: const mod.ModProgressConfig(
                    position: mod.ModProgressPosition.topRight,
                    progressColor: Colors.green,
                  ),
                );

                for (int i = 0; i <= 100; i += 10) {
                  await Future.delayed(const Duration(milliseconds: 200));
                  controller1.updateProgress(i / 100);
                  controller2.updateProgress((100 - i) / 100);
                }

                controller1.complete(message: "Task 1 complete!");
                controller2.complete(message: "Task 2 complete!");

                await Future.delayed(const Duration(seconds: 1));
                Get.closeAllProgress();
              },
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: mod.ModButton(
              title: "Show Error State",
              type: mod.ModButtonType.none,
              borderType: mod.ModBorderType.solid,
              borderColor: mod.ModButtonType.danger,
              onPressed: () async {
                final controller = Get.showProgress(
                  title: "Processing...",
                  subtitle: "Attempting operation",
                  initialProgress: 0.0,
                );

                for (int i = 0; i <= 50; i += 10) {
                  await Future.delayed(const Duration(milliseconds: 200));
                  controller.updateProgress(i / 100);
                }

                controller.setError("Connection failed: Server unavailable");
                await Future.delayed(const Duration(seconds: 2));
                controller.close();
              },
            ),
          ),
        ],
      ),
    );
  }
}
