import 'package:example/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mod_layout_one/mod_layout_one.dart';

class DialogsPage extends StatelessWidget {
  const DialogsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomLayout(
      title: 'Dialogs',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ModCard(
              header: const Text(
                "Dialog Examples",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Basic Dialog:"),
                  ModButton(
                    title: 'Show Basic Dialog',
                    type: ModButtonType.primary,
                    onPressed: () async {
                      showDialog(
                        context: context,
                        builder: (context) => ModDialog(
                          title: 'Confirmation',
                          maxWidth: 400,
                          minWidth: 150,
                          content:
                              const Text('Are you sure you want to proceed?'),
                          buttons: [
                            ModButton(
                              title: 'Cancel',
                              onPressed: () async => Get.back(),
                            ),
                            ModButton(
                              title: 'Confirm',
                              type: ModButtonType.primary,
                              onPressed: () async => Get.back(),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  const Text("Dialog with Dismissible Options:"),
                  Row(
                    children: [
                      ModButton(
                        title: 'Dismissible Dialog',
                        type: ModButtonType.warning,
                        onPressed: () async {
                          showDialog(
                            context: context,
                            builder: (context) => ModDialog(
                              title: 'Warning',
                              dismissible: true,
                              content: const Text(
                                  'This dialog can be dismissed by clicking outside or pressing ESC'),
                              buttons: [
                                ModButton(
                                  title: 'OK',
                                  type: ModButtonType.warning,
                                  onPressed: () async => Get.back(),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 16),
                      ModButton(
                        title: 'Non-dismissible Dialog',
                        type: ModButtonType.danger,
                        onPressed: () async {
                          showDialog(
                            context: context,
                            builder: (context) => ModDialog(
                              title: 'Important Notice',
                              dismissible: false,
                              content: const Text(
                                  'This dialog can only be closed using the button below'),
                              buttons: [
                                ModButton(
                                  title: 'I Understand',
                                  type: ModButtonType.warning,
                                  onPressed: () async => Get.back(),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text("Dialog with Icons:"),
                  Row(
                    children: [
                      ModButton(
                        title: 'Warning Dialog',
                        type: ModButtonType.warning,
                        onPressed: () async {
                          showDialog(
                            context: context,
                            builder: (context) => ModDialog(
                              title: 'Warning',
                              icon: Icons.warning_amber_rounded,
                              content: const Text(
                                  'This is a warning message with an icon'),
                              buttons: [
                                ModButton(
                                  title: 'OK',
                                  type: ModButtonType.warning,
                                  onPressed: () async => Get.back(),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 16),
                      ModButton(
                        title: 'Success Dialog',
                        type: ModButtonType.success,
                        onPressed: () async {
                          showDialog(
                            context: context,
                            builder: (context) => ModDialog(
                              title: 'Success',
                              icon: Icons.check_circle_outline,
                              content: const Text(
                                  'Operation completed successfully'),
                              buttons: [
                                ModButton(
                                  title: 'Close',
                                  type: ModButtonType.success,
                                  onPressed: () async => Get.back(),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 16),
                      ModButton(
                        title: 'Error Dialog',
                        type: ModButtonType.danger,
                        onPressed: () async {
                          showDialog(
                            context: context,
                            builder: (context) => ModDialog(
                              title: 'Error',
                              icon: Icons.error_outline,
                              content: const Text(
                                  'An error occurred during the operation'),
                              buttons: [
                                ModButton(
                                  title: 'Close',
                                  type: ModButtonType.danger,
                                  onPressed: () async => Get.back(),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text("Dialog with Left Aligned Buttons:"),
                  ModButton(
                    title: 'Show Settings Dialog',
                    type: ModButtonType.success,
                    onPressed: () async {
                      showDialog(
                        context: context,
                        builder: (context) => ModDialog(
                          title: 'Settings',
                          buttonAlignment: ButtonAlignment.left,
                          content: const Text('Configure your preferences'),
                          buttons: [
                            ModButton(
                              title: 'Save',
                              type: ModButtonType.success,
                              onPressed: () async => Get.back(),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  const Text("Dialog with Centered Buttons:"),
                  ModButton(
                    title: 'Show Dialog with Centered Buttons',
                    type: ModButtonType.primary,
                    onPressed: () async {
                      showDialog(
                        context: context,
                        builder: (context) => ModDialog(
                          title: 'Centered Buttons',
                          buttonAlignment: ButtonAlignment.center,
                          content: const Text(
                              'Dialog with buttons aligned at center'),
                          buttons: [
                            ModButton(
                              title: 'Cancel',
                              type: ModButtonType.secondary,
                              onPressed: () async => Get.back(),
                            ),
                            ModButton(
                              title: 'Confirm',
                              type: ModButtonType.primary,
                              onPressed: () async => Get.back(),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  const Text("Dialog with Custom Border Radius:"),
                  ModButton(
                    title: 'Show Dialog with Border Radius',
                    type: ModButtonType.primary,
                    onPressed: () async {
                      showDialog(
                        context: context,
                        builder: (context) => ModDialog(
                          title: 'Custom Border Radius',
                          content: const Text(
                              'This dialog has custom border radius and colors'),
                          borderRadius: 50,
                          buttons: [
                            ModButton(
                              title: 'Close',
                              type: ModButtonType.secondary,
                              onPressed: () async => Get.back(),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  const Text("Complex Dialog with Close Callback:"),
                  ModButton(
                    title: 'Show Info Dialog',
                    type: ModButtonType.info,
                    onPressed: () async {
                      showDialog(
                        context: context,
                        builder: (context) => ModDialog(
                          title: 'Information',
                          onClose: () {
                            //debugPrint('Dialog was closed');
                          },
                          content: const Column(
                            children: [
                              Text('This is a more complex dialog example'),
                              SizedBox(height: 8),
                              Icon(Icons.info),
                            ],
                          ),
                          buttons: [
                            ModButton(
                              title: 'Got it',
                              type: ModButtonType.info,
                              onPressed: () async => Get.back(),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  const Text("Dialog with All Parameters:"),
                  ModButton(
                    title: 'Show Full Featured Dialog',
                    type: ModButtonType.warning,
                    onPressed: () async {
                      showDialog(
                        context: context,
                        builder: (context) => ModDialog(
                          title: 'Full Featured Dialog',
                          content: const Column(
                            children: [
                              Text(
                                  'This dialog demonstrates all available parameters'),
                              SizedBox(height: 8),
                              Icon(Icons.star),
                            ],
                          ),
                          buttons: [
                            ModButton(
                              title: 'Cancel',
                              type: ModButtonType.secondary,
                              onPressed: () async => Get.back(),
                            ),
                            ModButton(
                              title: 'OK',
                              type: ModButtonType.warning,
                              onPressed: () async => Get.back(),
                            ),
                          ],
                          buttonAlignment: ButtonAlignment.center,
                          dismissible: false,
                          onClose: () {
                            debugPrint('Full featured dialog was closed');
                          },
                          size: DialogSize.lg,
                          position: DialogPosition.topCenter,
                          headerColor: Colors.amber[100],
                          contentColor: Colors.amber[50],
                          footerColor: Colors.amber[100],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  const Text("Small Dialog in Bottom Right:"),
                  ModButton(
                    title: 'Show Small Dialog',
                    type: ModButtonType.secondary,
                    onPressed: () async {
                      showDialog(
                        context: context,
                        builder: (context) => ModDialog(
                          title: 'Small Dialog',
                          content:
                              const Text('A compact dialog in bottom right'),
                          buttons: [
                            ModButton(
                              title: 'Close',
                              type: ModButtonType.secondary,
                              onPressed: () async => Get.back(),
                            ),
                          ],
                          size: DialogSize.sm,
                          position: DialogPosition.bottomRight,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  const ModCodeExample(
                    code: '''// Dialog Básico
showDialog(
  context: context,
  builder: (context) => ModDialog(
    title: 'Confirmation',
    maxWidth: 400,
    minWidth: 150,
    content: const Text('Are you sure you want to proceed?'),
    buttons: [
      ModButton(
        title: 'Cancel',
        onPressed: () async => Get.back(),
      ),
      ModButton(
        title: 'Confirm',
        type: ModButtonType.primary,
        onPressed: () async => Get.back(),
      ),
    ],
  ),
);

// Dialog com Ícone
showDialog(
  context: context,
  builder: (context) => ModDialog(
    title: 'Warning',
    icon: Icons.warning_amber_rounded,
    content: const Text('This is a warning message'),
    buttons: [
      ModButton(
        title: 'OK',
        type: ModButtonType.warning,
        onPressed: () async => Get.back(),
      ),
    ],
  ),
);

// Dialog Personalizado
showDialog(
  context: context,
  builder: (context) => ModDialog(
    title: 'Full Featured Dialog',
    content: const Text('Custom styled dialog'),
    buttons: [...],
    buttonAlignment: ButtonAlignment.center,
    dismissible: false,
    size: DialogSize.lg,
    position: DialogPosition.topCenter,
    headerColor: Colors.amber[100],
    contentColor: Colors.amber[50],
    footerColor: Colors.amber[100],
    borderRadius: 50,
  ),
);''',
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
