import 'package:example/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mod_layout_one/mod_layout_one.dart' as mod;

class ModalPage extends StatelessWidget {
  const ModalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomLayout(
      title: 'Modal',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            mod.ModCard(
              header: const Text(
                "Basic Modal Example",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Center(
                child: mod.ModButton(
                  title: "Open Basic Modal",
                  type: mod.ModButtonType.none,
                  borderType: mod.ModBorderType.solid,
                  borderColor: mod.ModButtonType.primary,
                  onPressed: () async {
                    await mod.ModModal.show(
                      context: context,
                      header: const Text('Basic Modal'),
                      height: mod.ModModalHeight.normal,
                      maxHeight: 300,
                      maxWidth: 400,
                      //height: mod.ModModalHeight.normal,
                      body: SizedBox(
                        height: 400,
                        child: mod.ModContainer(
                          child: mod.ModRow(
                            columns: [
                              mod.ModColumn(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                columnSizes: const {
                                  mod.ScreenSize.xs: mod.ColumnSize.col12,
                                  mod.ScreenSize.md: mod.ColumnSize.col8,
                                  mod.ScreenSize.lg: mod.ColumnSize.col8,
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 20),
                                  child: mod.ModContainer(
                                    child: mod.ModRow(
                                      columns: [
                                        mod.ModColumn(
                                          visible: false,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          columnSizes: const {
                                            mod.ScreenSize.xs:
                                                mod.ColumnSize.col12,
                                            mod.ScreenSize.md:
                                                mod.ColumnSize.col6,
                                          },
                                          child: mod.ModTextBox(
                                            label:
                                                'subscriptionsUsers_userId'.tr,
                                            hint:
                                                'subscriptionsUsers_enter_userId'
                                                    .tr,
                                            size: mod.ModTextBoxSize.sm,
                                            autovalidateMode:
                                                AutovalidateMode.disabled,
                                            borderRadius: 6,
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'userId_required'.tr;
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                        mod.ModColumn(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          columnSizes: const {
                                            mod.ScreenSize.xs:
                                                mod.ColumnSize.col12,
                                            mod.ScreenSize.md:
                                                mod.ColumnSize.col6,
                                          },
                                          child: mod.ModTextBox(
                                            label:
                                                'subscriptionsUsers_roleId'.tr,
                                            hint:
                                                'subscriptionsUsers_enter_roleId'
                                                    .tr,
                                            size: mod.ModTextBoxSize.sm,
                                            autovalidateMode:
                                                AutovalidateMode.disabled,
                                            borderRadius: 6,
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'roleId_required'.tr;
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                        mod.ModColumn(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          columnSizes: const {
                                            mod.ScreenSize.xs:
                                                mod.ColumnSize.col12,
                                          },
                                          child: Column(
                                            children: [
                                              const Divider(thickness: 2),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  mod.ModButton(
                                                    title: 'save'.tr,
                                                    onPressed: () async {},
                                                    borderType:
                                                        mod.ModBorderType.solid,
                                                    borderColor: mod
                                                        .ModButtonType.primary,
                                                    type:
                                                        mod.ModButtonType.none,
                                                    size: mod.ModButtonSize.md,
                                                    leftIcon: Icons.save,
                                                  ),
                                                  mod.ModButton(
                                                    title: 'cancel',
                                                    onPressed: () async =>
                                                        Get.back(),
                                                    borderType:
                                                        mod.ModBorderType.solid,
                                                    borderColor: mod
                                                        .ModButtonType
                                                        .secondary,
                                                    type:
                                                        mod.ModButtonType.none,
                                                    size: mod.ModButtonSize.md,
                                                    leftIcon: Icons.arrow_back,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // body: const Padding(
                      //   padding: EdgeInsets.all(16),
                      //   child: Text(
                      //       'This is a basic modal example with default styling.'),
                      // ),
                      footer: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          mod.ModButton(
                            title: 'Close',
                            type: mod.ModButtonType.none,
                            borderType: mod.ModBorderType.solid,
                            borderColor: mod.ModButtonType.primary,
                            onPressed: () async => Navigator.pop(context),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            mod.ModCard(
              header: const Text(
                "Positioned Modals",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  mod.ModButton(
                    title: "Top Modal",
                    type: mod.ModButtonType.none,
                    borderType: mod.ModBorderType.solid,
                    borderColor: mod.ModButtonType.primary,
                    onPressed: () async {
                      await mod.ModModal.show(
                        context: context,
                        position: mod.ModModalPosition.top,
                        header: const Text('Top Modal'),
                        body: const Text('This modal appears at the top'),
                        padding: const EdgeInsets.all(0),
                        footer: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            mod.ModButton(
                              title: 'Close',
                              type: mod.ModButtonType.none,
                              borderType: mod.ModBorderType.solid,
                              borderColor: mod.ModButtonType.primary,
                              onPressed: () async => Navigator.pop(context),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  mod.ModButton(
                    title: "Bottom Modal",
                    type: mod.ModButtonType.none,
                    borderType: mod.ModBorderType.solid,
                    borderColor: mod.ModButtonType.primary,
                    onPressed: () async {
                      await mod.ModModal.show(
                        context: context,
                        position: mod.ModModalPosition.bottom,
                        header: const Text('Bottom Modal'),
                        body: const Text('This modal appears at the bottom'),
                        footer: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            mod.ModButton(
                              title: 'Close',
                              type: mod.ModButtonType.none,
                              borderType: mod.ModBorderType.solid,
                              borderColor: mod.ModButtonType.primary,
                              onPressed: () async => Navigator.pop(context),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            mod.ModCard(
              header: const Text(
                "Styled Modal",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Center(
                child: mod.ModButton(
                  title: "Open Styled Modal",
                  type: mod.ModButtonType.none,
                  borderType: mod.ModBorderType.solid,
                  borderColor: mod.ModButtonType.primary,
                  onPressed: () async {
                    await mod.ModModal.show(
                      context: context,
                      headerColor: Colors.blue,
                      bodyColor: Colors.grey[100],
                      footerColor: Colors.white,
                      borderRadius: 16,
                      barrierDismissible: false,
                      header: const Text(
                        'Styled Modal',
                        style: TextStyle(color: Colors.white),
                      ),
                      body: const Padding(
                        padding: EdgeInsets.all(16),
                        child: Text(
                          'This modal has custom colors and cannot be dismissed by clicking outside.',
                        ),
                      ),
                      footer: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          mod.ModButton(
                            type: mod.ModButtonType.none,
                            borderType: mod.ModBorderType.solid,
                            borderColor: mod.ModButtonType.danger,
                            title: 'Cancel',
                            onPressed: () async => Navigator.pop(context),
                          ),
                          mod.ModButton(
                            type: mod.ModButtonType.none,
                            borderType: mod.ModBorderType.solid,
                            borderColor: mod.ModButtonType.primary,
                            title: 'Confirm',
                            onPressed: () async => Navigator.pop(context),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            mod.ModCard(
              header: const Text(
                "Modal Positions",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  mod.ModButton(
                    title: "Top Modal",
                    type: mod.ModButtonType.none,
                    borderType: mod.ModBorderType.solid,
                    borderColor: mod.ModButtonType.primary,
                    onPressed: () async {
                      await mod.ModModal.show(
                        context: context,
                        position: mod.ModModalPosition.top,
                        header: const Text('Top Modal'),
                        body: const Text(
                            'This modal appears at the top of the screen'),
                        footer: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            mod.ModButton(
                              title: 'Close',
                              type: mod.ModButtonType.none,
                              borderType: mod.ModBorderType.solid,
                              borderColor: mod.ModButtonType.primary,
                              onPressed: () async => Navigator.pop(context),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  mod.ModButton(
                    title: "Center Modal",
                    type: mod.ModButtonType.none,
                    borderType: mod.ModBorderType.solid,
                    borderColor: mod.ModButtonType.primary,
                    onPressed: () async {
                      await mod.ModModal.show(
                        context: context,
                        position: mod.ModModalPosition.center,
                        header: const Text('Center Modal'),
                        body: const Text(
                            'This modal appears at the center of the screen'),
                        footer: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            mod.ModButton(
                              title: 'Close',
                              type: mod.ModButtonType.none,
                              borderType: mod.ModBorderType.solid,
                              borderColor: mod.ModButtonType.primary,
                              onPressed: () async => Navigator.pop(context),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  mod.ModButton(
                    title: "Bottom Modal",
                    type: mod.ModButtonType.none,
                    borderType: mod.ModBorderType.solid,
                    borderColor: mod.ModButtonType.primary,
                    onPressed: () async {
                      await mod.ModModal.show(
                        context: context,
                        position: mod.ModModalPosition.bottom,
                        header: const Text('Bottom Modal'),
                        body: const Text(
                            'This modal appears at the bottom of the screen'),
                        footer: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            mod.ModButton(
                              title: 'Close',
                              type: mod.ModButtonType.none,
                              borderType: mod.ModBorderType.solid,
                              borderColor: mod.ModButtonType.primary,
                              onPressed: () async => Navigator.pop(context),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            mod.ModCard(
              header: const Text(
                "Modal Sizes",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  mod.ModButton(
                    title: "Extra Small Modal",
                    type: mod.ModButtonType.none,
                    borderType: mod.ModBorderType.solid,
                    borderColor: mod.ModButtonType.primary,
                    onPressed: () async {
                      await mod.ModModal.show(
                        context: context,
                        size: mod.ModModalSize.xs,
                        header: const Text('XS Modal'),
                        body: const Text('This is an extra small modal'),
                        footer: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            mod.ModButton(
                              title: 'Close',
                              type: mod.ModButtonType.none,
                              borderType: mod.ModBorderType.solid,
                              borderColor: mod.ModButtonType.primary,
                              onPressed: () async => Navigator.pop(context),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  mod.ModButton(
                    title: "Small Modal",
                    type: mod.ModButtonType.none,
                    borderType: mod.ModBorderType.solid,
                    borderColor: mod.ModButtonType.primary,
                    onPressed: () async {
                      await mod.ModModal.show(
                        context: context,
                        size: mod.ModModalSize.sm,
                        header: const Text('Small Modal'),
                        body: const Text('This is a small modal'),
                        footer: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            mod.ModButton(
                              title: 'Close',
                              type: mod.ModButtonType.none,
                              borderType: mod.ModBorderType.solid,
                              borderColor: mod.ModButtonType.primary,
                              onPressed: () async => Navigator.pop(context),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  mod.ModButton(
                    title: "Medium Modal",
                    type: mod.ModButtonType.none,
                    borderType: mod.ModBorderType.solid,
                    borderColor: mod.ModButtonType.primary,
                    onPressed: () async {
                      await mod.ModModal.show(
                        context: context,
                        size: mod.ModModalSize.md,
                        header: const Text('Medium Modal'),
                        body: const Text('This is a medium modal'),
                        footer: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            mod.ModButton(
                              title: 'Close',
                              type: mod.ModButtonType.none,
                              borderType: mod.ModBorderType.solid,
                              borderColor: mod.ModButtonType.primary,
                              onPressed: () async => Navigator.pop(context),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  mod.ModButton(
                    title: "Large Modal",
                    type: mod.ModButtonType.none,
                    borderType: mod.ModBorderType.solid,
                    borderColor: mod.ModButtonType.primary,
                    onPressed: () async {
                      await mod.ModModal.show(
                        context: context,
                        size: mod.ModModalSize.lg,
                        header: const Text('Large Modal'),
                        body: const Text('This is a large modal'),
                        footer: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            mod.ModButton(
                              title: 'Close',
                              type: mod.ModButtonType.none,
                              borderType: mod.ModBorderType.solid,
                              borderColor: mod.ModButtonType.primary,
                              onPressed: () async => Navigator.pop(context),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            mod.ModCard(
              header: const Text(
                "Modal Heights",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  mod.ModButton(
                    title: "Normal Height",
                    type: mod.ModButtonType.none,
                    borderType: mod.ModBorderType.solid,
                    borderColor: mod.ModButtonType.primary,
                    onPressed: () async {
                      await mod.ModModal.show(
                        context: context,
                        height: mod.ModModalHeight.normal,
                        header: const Text('Normal Height Modal'),
                        body: const Text('This modal has normal height'),
                        footer: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            mod.ModButton(
                              title: 'Close',
                              type: mod.ModButtonType.none,
                              borderType: mod.ModBorderType.solid,
                              borderColor: mod.ModButtonType.primary,
                              onPressed: () async => Navigator.pop(context),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  mod.ModButton(
                    title: "Full Height",
                    type: mod.ModButtonType.none,
                    borderType: mod.ModBorderType.solid,
                    borderColor: mod.ModButtonType.primary,
                    onPressed: () async {
                      await mod.ModModal.show(
                        context: context,
                        height: mod.ModModalHeight.full,
                        header: const Text('Full Height Modal'),
                        body: const Text('This modal takes up the full height'),
                        footer: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            mod.ModButton(
                              title: 'Close',
                              type: mod.ModButtonType.none,
                              borderType: mod.ModBorderType.solid,
                              borderColor: mod.ModButtonType.primary,
                              onPressed: () async => Navigator.pop(context),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  mod.ModButton(
                    title: "Full Screen",
                    type: mod.ModButtonType.none,
                    borderType: mod.ModBorderType.solid,
                    borderColor: mod.ModButtonType.primary,
                    onPressed: () async {
                      await mod.ModModal.show(
                        context: context,
                        fullScreen: true,
                        header: const Text('Full Screen Modal'),
                        body:
                            const Text('This modal takes up the entire screen'),
                        footer: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            mod.ModButton(
                              title: 'Close',
                              type: mod.ModButtonType.none,
                              borderType: mod.ModBorderType.solid,
                              borderColor: mod.ModButtonType.primary,
                              onPressed: () async => Navigator.pop(context),
                            ),
                          ],
                        ),
                      );
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
