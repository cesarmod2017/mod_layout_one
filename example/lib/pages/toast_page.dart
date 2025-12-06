import 'package:example/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mod_layout_one/mod_layout_one.dart';

class ToastPage extends StatelessWidget {
  const ToastPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomLayout(
      title: 'Toast',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ModCard(
              header: const Text(
                "Basic Toast Examples",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Predefined Toast Types:"),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ModButton(
                        title: 'Success Toast',
                        type: ModButtonType.success,
                        size: ModButtonSize.sm,
                        onPressed: () async {
                          ToastManager.success(
                            context: context,
                            title: 'Success!',
                            message: 'Operation completed successfully.',
                          );
                        },
                      ),
                      ModButton(
                        title: 'Error Toast',
                        type: ModButtonType.danger,
                        size: ModButtonSize.sm,
                        onPressed: () async {
                          ToastManager.error(
                            context: context,
                            title: 'Error!',
                            message: 'Something went wrong. Please try again.',
                          );
                        },
                      ),
                      ModButton(
                        title: 'Warning Toast',
                        type: ModButtonType.warning,
                        size: ModButtonSize.sm,
                        onPressed: () async {
                          ToastManager.warning(
                            context: context,
                            title: 'Warning!',
                            message: 'Please check your input data.',
                          );
                        },
                      ),
                      ModButton(
                        title: 'Info Toast',
                        type: ModButtonType.info,
                        size: ModButtonSize.sm,
                        onPressed: () async {
                          ToastManager.info(
                            context: context,
                            title: 'Information',
                            message: 'Here is some useful information.',
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text("Toast without Title:"),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ModButton(
                        title: 'Success (No Title)',
                        type: ModButtonType.success,
                        size: ModButtonSize.sm,
                        onPressed: () async {
                          ToastManager.success(
                            context: context,
                            message: 'Operation completed successfully!',
                          );
                        },
                      ),
                      ModButton(
                        title: 'Error (No Title)',
                        type: ModButtonType.danger,
                        size: ModButtonSize.sm,
                        onPressed: () async {
                          ToastManager.error(
                            context: context,
                            message: 'Something went wrong!',
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text("Different Durations:"),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ModButton(
                        title: '2 Seconds',
                        type: ModButtonType.info,
                        size: ModButtonSize.sm,
                        onPressed: () async {
                          ToastManager.info(
                            context: context,
                            title: 'Quick Info',
                            message: 'This toast will disappear in 2 seconds.',
                            duration: const Duration(seconds: 2),
                          );
                        },
                      ),
                      ModButton(
                        title: '5 Seconds',
                        type: ModButtonType.info,
                        size: ModButtonSize.sm,
                        onPressed: () async {
                          ToastManager.info(
                            context: context,
                            title: 'Longer Info',
                            message: 'This toast will stay for 5 seconds.',
                            duration: const Duration(seconds: 5),
                          );
                        },
                      ),
                      ModButton(
                        title: '10 Seconds',
                        type: ModButtonType.info,
                        size: ModButtonSize.sm,
                        onPressed: () async {
                          ToastManager.info(
                            context: context,
                            title: 'Long Info',
                            message: 'This toast will stay for 10 seconds.',
                            duration: const Duration(seconds: 10),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            const ModCodeExample(
              code: '''// Toast de Sucesso
ToastManager.success(
  context: context,
  title: 'Success!',
  message: 'Operation completed successfully.',
);

// Toast de Erro
ToastManager.error(
  context: context,
  title: 'Error!',
  message: 'Something went wrong. Please try again.',
);

// Toast de Warning
ToastManager.warning(
  context: context,
  title: 'Warning!',
  message: 'Please check your input data.',
);

// Toast de Info
ToastManager.info(
  context: context,
  title: 'Information',
  message: 'Here is some useful information.',
);

// Toast com Duração Personalizada
ToastManager.info(
  context: context,
  title: 'Quick Info',
  message: 'This toast will disappear in 2 seconds.',
  duration: const Duration(seconds: 2),
);''',
            ),
            const SizedBox(height: 24),
            ModCard(
              header: const Text(
                "Toast Positions",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Top Positions:"),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ModButton(
                        title: 'Top Left',
                        type: ModButtonType.primary,
                        size: ModButtonSize.sm,
                        onPressed: () async {
                          ToastManager.info(
                            context: context,
                            message: 'Toast at top left position',
                            position: ToastPosition.topLeft,
                          );
                        },
                      ),
                      ModButton(
                        title: 'Top Center',
                        type: ModButtonType.primary,
                        size: ModButtonSize.sm,
                        onPressed: () async {
                          ToastManager.info(
                            context: context,
                            message: 'Toast at top center position',
                            position: ToastPosition.topCenter,
                          );
                        },
                      ),
                      ModButton(
                        title: 'Top Right',
                        type: ModButtonType.primary,
                        size: ModButtonSize.sm,
                        onPressed: () async {
                          ToastManager.info(
                            context: context,
                            message: 'Toast at top right position',
                            position: ToastPosition.topRight,
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text("Center Positions:"),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ModButton(
                        title: 'Left Center',
                        type: ModButtonType.secondary,
                        size: ModButtonSize.sm,
                        onPressed: () async {
                          ToastManager.warning(
                            context: context,
                            message: 'Toast at left center position',
                            position: ToastPosition.leftCenter,
                          );
                        },
                      ),
                      ModButton(
                        title: 'Center',
                        type: ModButtonType.secondary,
                        size: ModButtonSize.sm,
                        onPressed: () async {
                          ToastManager.warning(
                            context: context,
                            message: 'Toast at center position',
                            position: ToastPosition.center,
                          );
                        },
                      ),
                      ModButton(
                        title: 'Right Center',
                        type: ModButtonType.secondary,
                        size: ModButtonSize.sm,
                        onPressed: () async {
                          ToastManager.warning(
                            context: context,
                            message: 'Toast at right center position',
                            position: ToastPosition.rightCenter,
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text("Bottom Positions:"),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ModButton(
                        title: 'Bottom Left',
                        type: ModButtonType.success,
                        size: ModButtonSize.sm,
                        onPressed: () async {
                          ToastManager.success(
                            context: context,
                            message: 'Toast at bottom left position',
                            position: ToastPosition.bottomLeft,
                          );
                        },
                      ),
                      ModButton(
                        title: 'Bottom Center',
                        type: ModButtonType.success,
                        size: ModButtonSize.sm,
                        onPressed: () async {
                          ToastManager.success(
                            context: context,
                            message: 'Toast at bottom center position',
                            position: ToastPosition.bottomCenter,
                          );
                        },
                      ),
                      ModButton(
                        title: 'Bottom Right',
                        type: ModButtonType.success,
                        size: ModButtonSize.sm,
                        onPressed: () async {
                          ToastManager.success(
                            context: context,
                            message: 'Toast at bottom right position',
                            position: ToastPosition.bottomRight,
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            const ModCodeExample(
              code: '''// Toast em diferentes posições
ToastManager.info(
  context: context,
  message: 'Toast at top left position',
  position: ToastPosition.topLeft,
);

ToastManager.info(
  context: context,
  message: 'Toast at center position',
  position: ToastPosition.center,
);

ToastManager.success(
  context: context,
  message: 'Toast at bottom right position',
  position: ToastPosition.bottomRight,
);''',
            ),
            const SizedBox(height: 24),
            ModCard(
              header: const Text(
                "Custom Toast Examples",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Custom Colors and Icons:"),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ModButton(
                        title: 'Purple Custom',
                        type: ModButtonType.custom,
                        backgroundColor: Colors.purple,
                        textColor: Colors.white,
                        size: ModButtonSize.sm,
                        onPressed: () async {
                          ToastManager.custom(
                            context: context,
                            title: 'Custom Purple',
                            message: 'This is a custom purple toast.',
                            icon: Icons.star,
                            backgroundColor: Colors.purple,
                            textColor: Colors.white,
                          );
                        },
                      ),
                      ModButton(
                        title: 'Pink Custom',
                        type: ModButtonType.custom,
                        backgroundColor: Colors.pink,
                        textColor: Colors.white,
                        size: ModButtonSize.sm,
                        onPressed: () async {
                          ToastManager.custom(
                            context: context,
                            title: 'Custom Pink',
                            message:
                                'This is a custom pink toast with heart icon.',
                            icon: Icons.favorite,
                            backgroundColor: Colors.pink,
                            textColor: Colors.white,
                          );
                        },
                      ),
                      ModButton(
                        title: 'Teal Custom',
                        type: ModButtonType.custom,
                        backgroundColor: Colors.teal,
                        textColor: Colors.white,
                        size: ModButtonSize.sm,
                        onPressed: () async {
                          ToastManager.custom(
                            context: context,
                            title: 'Custom Teal',
                            message:
                                'This is a custom teal toast with settings icon.',
                            icon: Icons.settings,
                            backgroundColor: Colors.teal,
                            textColor: Colors.white,
                            borderRadius: 12.0,
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text("Without Close Button:"),
                  const SizedBox(height: 12),
                  ModButton(
                    title: 'No Close Button',
                    type: ModButtonType.info,
                    size: ModButtonSize.sm,
                    onPressed: () async {
                      ToastManager.custom(
                        context: context,
                        title: 'Auto Close',
                        message:
                            'This toast has no close button and will auto-dismiss.',
                        showCloseButton: false,
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  const Text("Different Sizes:"),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ModButton(
                        title: 'Fixed Width',
                        type: ModButtonType.warning,
                        size: ModButtonSize.sm,
                        onPressed: () async {
                          ToastManager.warning(
                            context: context,
                            title: 'Fixed Width',
                            message: 'This toast has a fixed width of 300px.',
                          );
                        },
                      ),
                      ModButton(
                        title: 'Long Message',
                        type: ModButtonType.info,
                        size: ModButtonSize.sm,
                        onPressed: () async {
                          ToastManager.info(
                            context: context,
                            title: 'Long Message Example',
                            message:
                                'This is a very long toast message that demonstrates how the toast handles longer text content. The text should wrap properly and the toast should adjust its height accordingly to accommodate all the content.',
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text("Max Width Examples (Useful for Web/Desktop):"),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ModButton(
                        title: 'Default Width',
                        type: ModButtonType.primary,
                        size: ModButtonSize.sm,
                        onPressed: () async {
                          ToastManager.custom(
                              context: context,
                              message: "message",
                              backgroundColor: Get.theme.colorScheme.onSurface,
                              textColor: Colors.black,
                              maxWidth: 500,
                              position: ToastPosition.topRight,
                              icon: Icons.percent);
                          // ToastManager.info(
                          //   context: context,
                          //   title: 'Default Width',
                          //   message:
                          //       'This toast uses the default width (90% of screen).',
                          // );
                        },
                      ),
                      ModButton(
                        title: 'Max Width 400px',
                        type: ModButtonType.success,
                        size: ModButtonSize.sm,
                        onPressed: () async {
                          ToastManager.success(
                            context: context,
                            title: 'Constrained Width',
                            message:
                                'This toast has a maximum width of 400px, perfect for desktop/web applications.',
                            maxWidth: 400,
                          );
                        },
                      ),
                      ModButton(
                        title: 'Max Width 300px',
                        type: ModButtonType.warning,
                        size: ModButtonSize.sm,
                        onPressed: () async {
                          ToastManager.warning(
                            context: context,
                            title: 'Narrow Width',
                            message:
                                'This toast has a maximum width of 300px, suitable for compact notifications.',
                            maxWidth: 300,
                            position: ToastPosition.topRight,
                          );
                        },
                      ),
                      ModButton(
                        title: 'Max Width 600px',
                        type: ModButtonType.custom,
                        backgroundColor: Colors.purple,
                        textColor: Colors.white,
                        size: ModButtonSize.sm,
                        onPressed: () async {
                          ToastManager.custom(
                            context: context,
                            title: 'Wide Width',
                            message:
                                'This toast has a maximum width of 600px, suitable for detailed messages with more content to display.',
                            icon: Icons.info,
                            backgroundColor: Colors.purple,
                            textColor: Colors.white,
                            maxWidth: 600,
                            position: ToastPosition.bottomCenter,
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            const ModCodeExample(
              code: '''// Toast Customizado
ToastManager.custom(
  context: context,
  title: 'Custom Purple',
  message: 'This is a custom purple toast.',
  icon: Icons.star,
  backgroundColor: Colors.purple,
  textColor: Colors.white,
);

// Toast sem botão de fechar
ToastManager.custom(
  context: context,
  title: 'Auto Close',
  message: 'This toast has no close button.',
  showCloseButton: false,
);

// Toast com largura máxima
ToastManager.success(
  context: context,
  title: 'Constrained Width',
  message: 'This toast has a maximum width of 400px.',
  maxWidth: 400,
);

// Limpar todos os toasts
ToastManager().clearAll();''',
            ),
            const SizedBox(height: 24),
            ModCard(
              header: const Text(
                "Navigation Tests",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Test Toast with Navigation:"),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ModButton(
                        title: 'Toast + Open Modal',
                        type: ModButtonType.primary,
                        size: ModButtonSize.sm,
                        onPressed: () async {
                          // Show toast first
                          ToastManager.info(
                            context: context,
                            title: 'Toast Before Modal',
                            message:
                                'This toast was shown before opening the modal.',
                            duration: const Duration(seconds: 6),
                          );

                          // Wait a bit then open modal
                          await Future.delayed(
                              const Duration(milliseconds: 500));

                          // Open a modal dialog
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Test Modal'),
                              content: const Text(
                                  'This modal was opened after showing the toast. The toast should remain visible.'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: const Text('Close'),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      ModButton(
                        title: 'Toast + Navigate Back',
                        type: ModButtonType.secondary,
                        size: ModButtonSize.sm,
                        onPressed: () async {
                          // Show toast
                          ToastManager.success(
                            context: context,
                            title: 'Navigation Test',
                            message:
                                'This toast should not interfere with navigation.',
                            duration: const Duration(seconds: 5),
                          );

                          // Wait then navigate back (if possible)
                          await Future.delayed(
                              const Duration(milliseconds: 1000));

                          // Note: In this case, we're not actually navigating back
                          // because we want to stay on the test page, but this
                          // demonstrates that the toast won't interfere
                          if (Navigator.of(context).canPop()) {
                            // Get.back(); // Commented out to stay on test page

                            // Show another toast to confirm navigation didn't interfere
                            ToastManager.info(
                              context: context,
                              message:
                                  'Navigation test completed - toast is independent!',
                            );
                          }
                        },
                      ),
                      ModButton(
                        title: 'Multiple Toasts',
                        type: ModButtonType.warning,
                        size: ModButtonSize.sm,
                        onPressed: () async {
                          // Show multiple toasts with slight delays
                          ToastManager.success(
                            context: context,
                            title: 'Toast 1',
                            message: 'First toast message',
                          );

                          await Future.delayed(
                              const Duration(milliseconds: 200));

                          ToastManager.info(
                            context: context,
                            title: 'Toast 2',
                            message: 'Second toast message',
                          );

                          await Future.delayed(
                              const Duration(milliseconds: 200));

                          ToastManager.warning(
                            context: context,
                            title: 'Toast 3',
                            message: 'Third toast message',
                          );

                          await Future.delayed(
                              const Duration(milliseconds: 200));

                          ToastManager.error(
                            context: context,
                            title: 'Toast 4',
                            message:
                                'Fourth toast message (oldest should be replaced)',
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ModButton(
                    title: 'Clear All Toasts',
                    type: ModButtonType.danger,
                    leftIcon: Icons.clear_all,
                    size: ModButtonSize.sm,
                    onPressed: () async {
                      ToastManager().clearAll();
                    },
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
