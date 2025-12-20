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
                    centerIcon: Icons.add,
                    iconCenterAlign: ModIconCenterAlign.top,
                    fontSize: 10,
                    textColor: Colors.black,
                    onPressed: () async {},
                  ),
                  const Text("Button with Autosize Disabled:"),
                  ModButton(
                    title: 'Change Base Layout',
                    type: ModButtonType.primary,
                    autosize: false,
                    onPressed: () async {
                      controllerBaseLayout.updateModuleMenuGroups([
                        ModuleMenu(
                          name: 'Testandoooo',
                          icon: Icons.description,
                          description: 'Gestão de documentos',
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                          iconSize: 28.0,
                          onSelect: (module) async {
                            // Ação a ser executada quando o módulo for selecionado

                            // Removed Get.offAllNamed('/home') to avoid navigation issues
                          },
                          menuGroups: [
                            const MenuGroup(
                              title: Text('Components 1'),
                              fontSize: 14.0,
                              fontWeight: FontWeight.w500,
                              iconSize: 22.0,
                              claimName: 'module:documentos',
                              items: [
                                MenuItem(
                                  title: 'Corporate 1',
                                  icon: Icons.business,
                                  fontSize: 13.0,
                                  fontWeight: FontWeight.w400,
                                  iconSize: 20.0,
                                  //route: '/avatars',
                                  type: 'menu',
                                  value: 'avatars',
                                  subItems: [
                                    MenuItem(
                                      title: 'avatars',
                                      icon: Icons.telegram,
                                      fontSize: 12.0,
                                      iconSize: 18.0,
                                      type: 'menu',
                                      value: 'avatars',
                                      subItems: [
                                        MenuItem(
                                          title: 'avatars',
                                          icon: Icons.account_circle,
                                          route: '/avatars',
                                          type: 'menu',
                                          value: 'avatars',
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                MenuItem(
                                  title: 'textCopy',
                                  icon: Icons.text_decrease,
                                  route: '/textCopy',
                                  type: 'menu',
                                  value: 'textCopy',
                                  reloadOnNavigate: true,
                                ),
                              ],
                            ),
                          ],
                        ),
                        ModuleMenu(
                          name: 'Testandoooo 222',
                          icon: Icons.description,
                          description: 'Gestão de documentos',
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                          iconSize: 28.0,
                          onSelect: (module) async {
                            // Ação a ser executada quando o módulo for selecionado

                            // Removed Get.offAllNamed('/home') to avoid navigation issues
                          },
                          menuGroups: [
                            const MenuGroup(
                              title: Text('Components 1'),
                              fontSize: 14.0,
                              fontWeight: FontWeight.w500,
                              iconSize: 22.0,
                              claimName: 'module:documentos',
                              items: [
                                MenuItem(
                                  title: 'Corporate 1',
                                  icon: Icons.business,
                                  fontSize: 13.0,
                                  fontWeight: FontWeight.w400,
                                  iconSize: 20.0,
                                  //route: '/avatars',
                                  type: 'menu',
                                  value: 'avatars',
                                  subItems: [
                                    MenuItem(
                                      title: 'avatars',
                                      icon: Icons.telegram,
                                      fontSize: 12.0,
                                      iconSize: 18.0,
                                      type: 'menu',
                                      value: 'avatars',
                                      subItems: [
                                        MenuItem(
                                          title: 'avatars',
                                          icon: Icons.account_circle,
                                          route: '/avatars',
                                          type: 'menu',
                                          value: 'avatars',
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                MenuItem(
                                  title: 'textCopy',
                                  icon: Icons.text_decrease,
                                  route: '/textCopy',
                                  type: 'menu',
                                  value: 'textCopy',
                                  reloadOnNavigate: true,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ]);
                    },
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
                  ModPopupButton<String>(
                    title: 'Popup Button',
                    items: [
                      ModPopupMenuItem(value: 'Item 1', text: 'Item 1'),
                      ModPopupMenuItem(value: 'Item 2', text: 'Item 2'),
                      ModPopupMenuItem(value: 'Item 3', text: 'Item 3'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const ModCodeExample(
                    code: '''// Botão Simples
ModButton(
  title: 'Simple Button',
  type: ModButtonType.primary,
  onPressed: () async {},
),

// Botão com Ícones
ModButton(
  title: 'Click Me',
  type: ModButtonType.success,
  leftIcon: Icons.add,
  rightIcon: Icons.arrow_forward,
  onPressed: () async {},
),

// Botão com Loading
ModButton(
  title: 'Submit',
  type: ModButtonType.info,
  leftIcon: Icons.save,
  onPressed: () async {
    await Future.delayed(const Duration(seconds: 2));
  },
  loadingText: 'Saving...',
),

// Tipos de Botão
ModButton(
  title: 'Primary',
  type: ModButtonType.primary,
  onPressed: () async {},
),

// Tamanhos de Botão
ModButton(
  title: 'Large Button',
  type: ModButtonType.primary,
  size: ModButtonSize.lg,
  onPressed: () async {},
),

// Botão Desabilitado
ModButton(
  title: 'Disabled',
  type: ModButtonType.primary,
  disabled: true,
  onPressed: () async {},
),''',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            ModCard(
              header: const Text(
                "Popup Button Examples",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Basic Popup Button:"),
                  const SizedBox(height: 8),
                  ModPopupButton<String>(
                    title: 'Ações',
                    leftIcon: Icons.menu,
                    popupIcon: Icons.arrow_drop_down,
                    type: ModButtonType.primary,
                    items: [
                      ModPopupMenuItem<String>(
                        value: 'edit',
                        text: 'Editar',
                        icon: Icons.edit,
                      ),
                      ModPopupMenuItem<String>(
                        value: 'delete',
                        text: 'Excluir',
                        icon: Icons.delete,
                      ),
                      ModPopupMenuItem<String>(
                        value: 'share',
                        text: 'Compartilhar',
                        icon: Icons.share,
                      ),
                    ],
                    onSelected: (value) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Selecionado: $value')),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  const Text("Icon Only Popup Button:"),
                  const SizedBox(height: 8),
                  ModPopupButton<String>(
                    popupIcon: Icons.more_vert,
                    type: ModButtonType.secondary,
                    size: ModButtonSize.sm,
                    items: [
                      ModPopupMenuItem<String>(
                        value: 'option1',
                        text: 'Opção 1',
                        icon: Icons.star,
                      ),
                      ModPopupMenuItem<String>(
                        value: 'option2',
                        text: 'Opção 2',
                        icon: Icons.favorite,
                      ),
                      ModPopupMenuItem<String>(
                        value: 'option3',
                        text: 'Opção 3',
                        icon: Icons.bookmark,
                      ),
                    ],
                    onSelected: (value) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Selecionado: $value')),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  const Text("Different Types and Colors:"),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ModPopupButton<String>(
                        title: 'Success',
                        popupIcon: Icons.keyboard_arrow_down,
                        type: ModButtonType.success,
                        size: ModButtonSize.sm,
                        items: [
                          ModPopupMenuItem<String>(
                            value: 'approve',
                            text: 'Aprovar',
                            icon: Icons.check_circle,
                          ),
                          ModPopupMenuItem<String>(
                            value: 'complete',
                            text: 'Concluir',
                            icon: Icons.done,
                          ),
                        ],
                        onSelected: (value) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Ação: $value')),
                          );
                        },
                      ),
                      ModPopupButton<String>(
                        title: 'Warning',
                        popupIcon: Icons.keyboard_arrow_down,
                        type: ModButtonType.warning,
                        size: ModButtonSize.sm,
                        items: [
                          ModPopupMenuItem<String>(
                            value: 'caution',
                            text: 'Atenção',
                            icon: Icons.warning,
                          ),
                          ModPopupMenuItem<String>(
                            value: 'review',
                            text: 'Revisar',
                            icon: Icons.visibility,
                          ),
                        ],
                        onSelected: (value) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Ação: $value')),
                          );
                        },
                      ),
                      ModPopupButton<String>(
                        title: 'Danger',
                        popupIcon: Icons.keyboard_arrow_down,
                        type: ModButtonType.danger,
                        size: ModButtonSize.sm,
                        items: [
                          ModPopupMenuItem<String>(
                            value: 'delete',
                            text: 'Excluir',
                            icon: Icons.delete,
                          ),
                          ModPopupMenuItem<String>(
                            value: 'remove',
                            text: 'Remover',
                            icon: Icons.remove_circle,
                          ),
                        ],
                        onSelected: (value) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Ação: $value')),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text("Custom Colors and Styling:"),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ModPopupButton<String>(
                        title: 'Custom',
                        leftIcon: Icons.palette,
                        popupIcon: Icons.expand_more,
                        type: ModButtonType.custom,
                        backgroundColor: Colors.purple,
                        textColor: Colors.white,
                        borderRadius: 12.0,
                        items: [
                          ModPopupMenuItem<String>(
                            value: 'theme1',
                            text: 'Tema 1',
                            icon: Icons.color_lens,
                            iconColor: Colors.purple,
                          ),
                          ModPopupMenuItem<String>(
                            value: 'theme2',
                            text: 'Tema 2',
                            icon: Icons.color_lens,
                            iconColor: Colors.blue,
                          ),
                          ModPopupMenuItem<String>(
                            value: 'theme3',
                            text: 'Tema 3',
                            icon: Icons.color_lens,
                            iconColor: Colors.green,
                          ),
                        ],
                        onSelected: (value) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Tema selecionado: $value')),
                          );
                        },
                      ),
                      ModPopupButton<String>(
                        title: 'Gradient',
                        popupIcon: Icons.gradient,
                        type: ModButtonType.custom,
                        backgroundColor: Colors.orange.shade400,
                        textColor: Colors.white,
                        borderRadius: 20.0,
                        size: ModButtonSize.lg,
                        items: [
                          ModPopupMenuItem<String>(
                            value: 'gradient1',
                            text: 'Gradiente 1',
                            icon: Icons.gradient,
                          ),
                          ModPopupMenuItem<String>(
                            value: 'gradient2',
                            text: 'Gradiente 2',
                            icon: Icons.gradient,
                          ),
                        ],
                        onSelected: (value) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Gradiente: $value')),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text("Different Sizes:"),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ModPopupButton<String>(
                        title: 'Large',
                        popupIcon: Icons.arrow_drop_down,
                        type: ModButtonType.info,
                        size: ModButtonSize.lg,
                        items: [
                          ModPopupMenuItem<String>(
                            value: 'item1',
                            text: 'Item 1',
                            icon: Icons.looks_one,
                          ),
                          ModPopupMenuItem<String>(
                            value: 'item2',
                            text: 'Item 2',
                            icon: Icons.looks_two,
                          ),
                        ],
                        onSelected: (value) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Item: $value')),
                          );
                        },
                      ),
                      ModPopupButton<String>(
                        title: 'Medium',
                        popupIcon: Icons.arrow_drop_down,
                        type: ModButtonType.info,
                        size: ModButtonSize.md,
                        items: [
                          ModPopupMenuItem<String>(
                            value: 'item1',
                            text: 'Item 1',
                            icon: Icons.looks_one,
                          ),
                          ModPopupMenuItem<String>(
                            value: 'item2',
                            text: 'Item 2',
                            icon: Icons.looks_two,
                          ),
                        ],
                        onSelected: (value) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Item: $value')),
                          );
                        },
                      ),
                      ModPopupButton<String>(
                        title: 'Small',
                        popupIcon: Icons.arrow_drop_down,
                        type: ModButtonType.info,
                        size: ModButtonSize.sm,
                        items: [
                          ModPopupMenuItem<String>(
                            value: 'item1',
                            text: 'Item 1',
                            icon: Icons.looks_one,
                          ),
                          ModPopupMenuItem<String>(
                            value: 'item2',
                            text: 'Item 2',
                            icon: Icons.looks_two,
                          ),
                        ],
                        onSelected: (value) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Item: $value')),
                          );
                        },
                      ),
                      ModPopupButton<String>(
                        title: 'XS',
                        popupIcon: Icons.arrow_drop_down,
                        type: ModButtonType.info,
                        size: ModButtonSize.xs,
                        items: [
                          ModPopupMenuItem<String>(
                            value: 'item1',
                            text: 'Item 1',
                            icon: Icons.looks_one,
                          ),
                          ModPopupMenuItem<String>(
                            value: 'item2',
                            text: 'Item 2',
                            icon: Icons.looks_two,
                          ),
                        ],
                        onSelected: (value) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Item: $value')),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text("With Disabled Items:"),
                  const SizedBox(height: 8),
                  ModPopupButton<String>(
                    title: 'Status',
                    leftIcon: Icons.settings,
                    popupIcon: Icons.keyboard_arrow_down,
                    type: ModButtonType.dark,
                    items: [
                      ModPopupMenuItem<String>(
                        value: 'active',
                        text: 'Ativo',
                        icon: Icons.check_circle,
                        iconColor: Colors.green,
                        textColor: Colors.green,
                      ),
                      ModPopupMenuItem<String>(
                        value: 'inactive',
                        text: 'Inativo',
                        icon: Icons.pause_circle,
                        iconColor: Colors.orange,
                        textColor: Colors.orange,
                      ),
                      ModPopupMenuItem<String>(
                        value: 'disabled',
                        text: 'Desabilitado',
                        icon: Icons.block,
                        enabled: false,
                      ),
                      ModPopupMenuItem<String>(
                        value: 'pending',
                        text: 'Pendente',
                        icon: Icons.hourglass_empty,
                        iconColor: Colors.blue,
                        textColor: Colors.blue,
                      ),
                    ],
                    onSelected: (value) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Status: $value')),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  const Text("Custom Widget Items:"),
                  const SizedBox(height: 8),
                  ModPopupButton<int>(
                    title: 'Advanced',
                    leftIcon: Icons.auto_awesome,
                    popupIcon: Icons.expand_more,
                    type: ModButtonType.secondary,
                    borderRadius: 8.0,
                    items: [
                      ModPopupMenuItem<int>(
                        value: 1,
                        child: Row(
                          children: [
                            Icon(Icons.favorite, color: Colors.red, size: 18),
                            const SizedBox(width: 8),
                            const Text('Favorito'),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Text(
                                'NEW',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      ModPopupMenuItem<int>(
                        value: 2,
                        child: Row(
                          children: [
                            Icon(Icons.star_rate,
                                color: Colors.amber, size: 18),
                            const SizedBox(width: 8),
                            const Text('5 Estrelas'),
                            const Spacer(),
                            Icon(Icons.arrow_forward_ios,
                                size: 14, color: Colors.grey),
                          ],
                        ),
                      ),
                      ModPopupMenuItem<int>(
                        value: 3,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              Container(
                                width: 12,
                                height: 12,
                                decoration: const BoxDecoration(
                                  color: Colors.green,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Text('Online'),
                              const Spacer(),
                              const Text(
                                '•••',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                    onSelected: (value) {
                      String message = '';
                      switch (value) {
                        case 1:
                          message = 'Favorito selecionado';
                          break;
                        case 2:
                          message = '5 Estrelas selecionado';
                          break;
                        case 3:
                          message = 'Status Online';
                          break;
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(message)),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  const Text("Popup Buttons with Submenus:"),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ModPopupButton<String>(
                        title: 'Configurações',
                        leftIcon: Icons.settings,
                        popupIcon: Icons.arrow_drop_down,
                        type: ModButtonType.secondary,
                        menuFontSize: 15,
                        submenuFontSize: 14,
                        menuItemPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        submenuItemPadding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 10),
                        iconTextSpacing: 10,
                        submenuOffset: 2,
                        items: [
                          ModPopupMenuItem<String>(
                            value: 'perfil',
                            text: 'Perfil',
                            icon: Icons.person,
                            submenu: [
                              ModPopupMenuItem<String>(
                                value: 'edit_profile',
                                text: 'Editar Perfil',
                                icon: Icons.edit,
                              ),
                              ModPopupMenuItem<String>(
                                value: 'change_password',
                                text: 'Alterar Senha',
                                icon: Icons.lock,
                              ),
                              ModPopupMenuItem<String>(
                                value: 'privacy',
                                text: 'Privacidade',
                                icon: Icons.privacy_tip,
                              ),
                            ],
                          ),
                          ModPopupMenuItem<String>(
                            value: 'tema',
                            text: 'Tema',
                            icon: Icons.palette,
                            submenu: [
                              ModPopupMenuItem<String>(
                                value: 'light_theme',
                                text: 'Tema Claro',
                                icon: Icons.light_mode,
                              ),
                              ModPopupMenuItem<String>(
                                value: 'dark_theme',
                                text: 'Tema Escuro',
                                icon: Icons.dark_mode,
                              ),
                              ModPopupMenuItem<String>(
                                value: 'auto_theme',
                                text: 'Automático',
                                icon: Icons.auto_mode,
                              ),
                            ],
                          ),
                          ModPopupMenuItem<String>(
                            value: 'idioma',
                            text: 'Idioma',
                            icon: Icons.language,
                            submenu: [
                              ModPopupMenuItem<String>(
                                value: 'pt_br',
                                text: 'Português',
                                icon: Icons.flag,
                              ),
                              ModPopupMenuItem<String>(
                                value: 'en_us',
                                text: 'English',
                                icon: Icons.flag,
                              ),
                              ModPopupMenuItem<String>(
                                value: 'es_es',
                                text: 'Español',
                                icon: Icons.flag,
                              ),
                            ],
                          ),
                          ModPopupMenuItem<String>(
                            value: 'logout',
                            text: 'Sair',
                            icon: Icons.logout,
                            textColor: Colors.red,
                            iconColor: Colors.red,
                          ),
                        ],
                        onSelected: (value) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Configuração: $value')),
                          );
                        },
                      ),
                      ModPopupButton<String>(
                        title: 'Arquivo',
                        leftIcon: Icons.folder,
                        popupIcon: Icons.keyboard_arrow_down,
                        type: ModButtonType.info,
                        size: ModButtonSize.sm,
                        items: [
                          ModPopupMenuItem<String>(
                            value: 'new',
                            text: 'Novo',
                            icon: Icons.add,
                            submenu: [
                              ModPopupMenuItem<String>(
                                value: 'new_document',
                                text: 'Documento',
                                icon: Icons.description,
                              ),
                              ModPopupMenuItem<String>(
                                value: 'new_folder',
                                text: 'Pasta',
                                icon: Icons.folder,
                              ),
                              ModPopupMenuItem<String>(
                                value: 'new_spreadsheet',
                                text: 'Planilha',
                                icon: Icons.table_chart,
                              ),
                            ],
                          ),
                          ModPopupMenuItem<String>(
                            value: 'open',
                            text: 'Abrir',
                            icon: Icons.folder_open,
                          ),
                          ModPopupMenuItem<String>(
                            value: 'export',
                            text: 'Exportar',
                            icon: Icons.file_upload,
                            submenu: [
                              ModPopupMenuItem<String>(
                                value: 'export_pdf',
                                text: 'PDF',
                                icon: Icons.picture_as_pdf,
                              ),
                              ModPopupMenuItem<String>(
                                value: 'export_excel',
                                text: 'Excel',
                                icon: Icons.table_view,
                              ),
                              ModPopupMenuItem<String>(
                                value: 'export_image',
                                text: 'Imagem',
                                icon: Icons.image,
                              ),
                            ],
                          ),
                        ],
                        onSelected: (value) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Arquivo: $value')),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text("Customização Avançada de Fontes e Espaçamentos:"),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ModPopupButton<String>(
                        title: 'Fontes Pequenas',
                        leftIcon: Icons.text_fields,
                        popupIcon: Icons.keyboard_arrow_down,
                        type: ModButtonType.info,
                        size: ModButtonSize.sm,
                        menuFontSize: 12,
                        submenuFontSize: 11,
                        menuItemPadding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 6),
                        submenuItemPadding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 6),
                        iconTextSpacing: 6,
                        submenuOffset: 1,
                        items: [
                          ModPopupMenuItem<String>(
                            value: 'formato',
                            text: 'Formatação',
                            icon: Icons.format_paint,
                            submenu: [
                              ModPopupMenuItem<String>(
                                value: 'bold',
                                text: 'Negrito',
                                icon: Icons.format_bold,
                              ),
                              ModPopupMenuItem<String>(
                                value: 'italic',
                                text: 'Itálico',
                                icon: Icons.format_italic,
                              ),
                              ModPopupMenuItem<String>(
                                value: 'underline',
                                text: 'Sublinhado',
                                icon: Icons.format_underlined,
                              ),
                            ],
                          ),
                          ModPopupMenuItem<String>(
                            value: 'align',
                            text: 'Alinhamento',
                            icon: Icons.format_align_left,
                            submenu: [
                              ModPopupMenuItem<String>(
                                value: 'left',
                                text: 'Esquerda',
                                icon: Icons.format_align_left,
                              ),
                              ModPopupMenuItem<String>(
                                value: 'center',
                                text: 'Centro',
                                icon: Icons.format_align_center,
                              ),
                              ModPopupMenuItem<String>(
                                value: 'right',
                                text: 'Direita',
                                icon: Icons.format_align_right,
                              ),
                            ],
                          ),
                        ],
                        onSelected: (value) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Formatação: $value')),
                          );
                        },
                      ),
                      ModPopupButton<String>(
                        title: 'Fontes Grandes',
                        leftIcon: Icons.text_increase,
                        popupIcon: Icons.expand_more,
                        type: ModButtonType.warning,
                        size: ModButtonSize.lg,
                        menuFontSize: 18,
                        submenuFontSize: 16,
                        menuItemPadding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 16),
                        submenuItemPadding: const EdgeInsets.symmetric(
                            horizontal: 18, vertical: 14),
                        iconTextSpacing: 12,
                        submenuOffset: 6,
                        items: [
                          ModPopupMenuItem<String>(
                            value: 'media',
                            text: 'Mídia',
                            icon: Icons.perm_media,
                            submenu: [
                              ModPopupMenuItem<String>(
                                value: 'photo',
                                text: 'Inserir Foto',
                                icon: Icons.photo,
                              ),
                              ModPopupMenuItem<String>(
                                value: 'video',
                                text: 'Inserir Vídeo',
                                icon: Icons.videocam,
                              ),
                              ModPopupMenuItem<String>(
                                value: 'audio',
                                text: 'Inserir Áudio',
                                icon: Icons.audiotrack,
                              ),
                            ],
                          ),
                          ModPopupMenuItem<String>(
                            value: 'help',
                            text: 'Ajuda',
                            icon: Icons.help_outline,
                          ),
                        ],
                        onSelected: (value) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Mídia: $value')),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text("Disabled Popup Button:"),
                  const SizedBox(height: 8),
                  ModPopupButton<String>(
                    title: 'Disabled',
                    leftIcon: Icons.block,
                    popupIcon: Icons.arrow_drop_down,
                    type: ModButtonType.primary,
                    disabled: true,
                    items: [
                      ModPopupMenuItem<String>(
                        value: 'item1',
                        text: 'Item 1',
                        icon: Icons.looks_one,
                      ),
                    ],
                    onSelected: (value) {},
                  ),
                  const SizedBox(height: 16),
                  const ModCodeExample(
                    code: '''// Popup Button Básico
ModPopupButton<String>(
  title: 'Ações',
  leftIcon: Icons.menu,
  popupIcon: Icons.arrow_drop_down,
  type: ModButtonType.primary,
  items: [
    ModPopupMenuItem<String>(
      value: 'edit',
      text: 'Editar',
      icon: Icons.edit,
    ),
    ModPopupMenuItem<String>(
      value: 'delete',
      text: 'Excluir',
      icon: Icons.delete,
    ),
  ],
  onSelected: (value) {
    // Handle selection
  },
),

// Popup Button com Submenu
ModPopupButton<String>(
  title: 'Configurações',
  leftIcon: Icons.settings,
  popupIcon: Icons.arrow_drop_down,
  type: ModButtonType.secondary,
  items: [
    ModPopupMenuItem<String>(
      value: 'perfil',
      text: 'Perfil',
      icon: Icons.person,
      submenu: [
        ModPopupMenuItem<String>(
          value: 'edit_profile',
          text: 'Editar Perfil',
          icon: Icons.edit,
        ),
        ModPopupMenuItem<String>(
          value: 'change_password',
          text: 'Alterar Senha',
          icon: Icons.lock,
        ),
      ],
    ),
  ],
  onSelected: (value) {
    // Handle selection
  },
),

// Popup Button com Widget Customizado
ModPopupButton<int>(
  title: 'Advanced',
  leftIcon: Icons.auto_awesome,
  popupIcon: Icons.expand_more,
  type: ModButtonType.secondary,
  items: [
    ModPopupMenuItem<int>(
      value: 1,
      child: Row(
        children: [
          Icon(Icons.favorite, color: Colors.red),
          const SizedBox(width: 8),
          const Text('Favorito'),
        ],
      ),
    ),
  ],
  onSelected: (value) {
    // Handle selection
  },
),''',
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
