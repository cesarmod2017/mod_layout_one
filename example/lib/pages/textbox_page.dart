import 'dart:developer';

import 'package:example/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mod_layout_one/mod_layout_one.dart' as mod;
import 'package:mod_layout_one/mod_layout_one.dart';

class TextBoxPage extends StatefulWidget {
  const TextBoxPage({super.key});

  @override
  State<TextBoxPage> createState() => _TextBoxPageState();
}

class _TextBoxPageState extends State<TextBoxPage> {
  late String? selectedCountry = 'USA';

  List<String> countries = ['USA', 'Canada', 'Mexico', 'Brazil'];

  @override
  Widget build(BuildContext context) {
    return CustomLayout(
      title: 'TextBox Examples',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            mod.ModCard(
              header: const Text(
                "Basic TextBox Example",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  mod.ModTextBox(
                    label: "Name",
                    hint: "Enter your name",
                    controller: TextEditingController(),
                    enableEnterAction: true,
                    enterOnPressed: () async {
                      log('Enter disparado');
                    },
                    onChange: (text) {
                      // This ensures the text is updated in the TextBox
                      log("Name: $text");
                    },
                  ),
                  const SizedBox(height: 16),
                  const mod.ModCodeExample(
                    code: '''ModTextBox(
  label: "Name",
  hint: "Enter your name",
  controller: TextEditingController(),
  enableEnterAction: true,
  enterOnPressed: () async {
    // Ação ao pressionar Enter
  },
  onChange: (text) {
    print("Name: \$text");
  },
),''',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            mod.ModCard(
              header: const Text(
                "Password TextBox Example",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  mod.ModTextBox(
                    label: "Password",
                    hint: "Enter your password",
                    isPassword: true,
                    controller: TextEditingController(text: "dada"),
                    onChange: (text) {
                      // This ensures the text is updated in the TextBox
                      log("Password: $text");
                    },
                  ),
                  const SizedBox(height: 16),
                  const mod.ModCodeExample(
                    code: '''ModTextBox(
  label: "Password",
  hint: "Enter your password",
  isPassword: true,
  controller: TextEditingController(),
  onChange: (text) {
    print("Password: \$text");
  },
),''',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            mod.ModCard(
              header: const Text(
                "TextBox with Custom Style",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  mod.ModTextBox(
                    label: "Email",
                    hint: "Enter your email",
                    style: const TextStyle(color: Colors.green),
                    borderRadius: 16.0,
                    keyboardType: TextInputType.emailAddress,
                    readOnly: false,
                    controller: TextEditingController(),
                    onChange: (text) {
                      log("Email: $text");
                    },
                  ),
                  const SizedBox(height: 16),
                  const mod.ModCodeExample(
                    code: '''ModTextBox(
  label: "Email",
  hint: "Enter your email",
  style: const TextStyle(color: Colors.green),
  borderRadius: 16.0,
  keyboardType: TextInputType.emailAddress,
  readOnly: false,
  controller: TextEditingController(),
  onChange: (text) {
    print("Email: \$text");
  },
),''',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            mod.ModCard(
              header: const Text(
                "TextBox Size Examples",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Column(
                children: [
                  mod.ModTextBox(
                    label: "Large TextBox",
                    hint: "Enter text",
                    size: ModTextBoxSize.lg,
                    controller: TextEditingController(),
                    onChange: (text) {
                      log("Large TextBox: $text");
                    },
                  ),
                  const SizedBox(height: 16),
                  mod.ModTextBox(
                    label: "Medium TextBox",
                    hint: "Enter text",
                    size: ModTextBoxSize.md,
                    controller: TextEditingController(),
                    onChange: (text) {
                      log("Medium TextBox: $text");
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        child: mod.ModTextBox(
                          label: "Small TextBox",
                          hint: "Enter text",
                          size: ModTextBoxSize.xs,
                          floatingLabel: true,
                          controller: TextEditingController(),
                          onChange: (text) {
                            log("Small TextBox: $text");
                          },
                          suffixButton: ModButton(
                            title: 'Large Button',
                            type: ModButtonType.danger,
                            borderRadius: 16,
                            size: ModButtonSize.xs,
                            onPressed: () async {},
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      ModButton(
                        title: 'Large Button',
                        type: ModButtonType.primary,
                        size: ModButtonSize.lg,
                        onPressed: () async {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        child: mod.ModDropDown<String>(
                          //floatingLabel: true,
                          //floatingLabelBackgroundColor: Colors.transparent,
                          label: 'Select Country',
                          hint: 'Choose a country',
                          value: selectedCountry,
                          // isSearch: true,
                          items: countries
                              .map(
                                (country) => DropdownMenuItem(
                                  value: country,
                                  child: Text(country),
                                ),
                              )
                              .toList(),
                          onChanged: (value) =>
                              setState(() => selectedCountry = value),
                          size: mod.ModDropDownSize.sm,
                          borderRadius: 6,
                          validator: (value) =>
                              value == null ? 'Please select a country' : null,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Flexible(
                        child: mod.ModTextBox(
                          label: "Extra Small TextBox",
                          hint: "Enter text",
                          size: ModTextBoxSize.sm,
                          autoHeight: true,
                          controller: TextEditingController(),
                          //backgroundColor: Colors.red,
                          //floatingLabel: true,

                          onChange: (text) {
                            log("Extra Small TextBox: $text");
                          },
                          keyboardType: TextInputType.emailAddress,
                          inputFormatters: [
                            FilteringTextInputFormatter.deny(
                                RegExp(r'[^a-zA-Z0-9@.]'))
                          ],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'email_required';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Flexible(
                        child: mod.ModDropdownSearch<String>(
                          // fontSize: 10,
                          floatingLabel: false,
                          //floatingLabelBackgroundColor: Colors.red,
                          value: 'Alice',
                          searchEnabled: false,
                          items: const [
                            mod.ModDropdownSearchMenuItem(
                                value: '(Geral) - Relatório Bipagens',
                                icon: Icons.face,
                                child: Text('(Geral) - Relatório Bipagens')),
                            mod.ModDropdownSearchMenuItem(
                                value: 'Programação - Projeto y Planejamento',
                                icon: Icons.code,
                                child: Text(
                                    'Programação - Projeto y Planejamento')),
                            mod.ModDropdownSearchMenuItem(
                                value: 'Qualidade - Testing y Debugging',
                                icon: Icons.bug_report,
                                child: Text('Qualidade - Testing y Debugging')),
                            mod.ModDropdownSearchMenuItem(
                                value: 'Bob',
                                icon: Icons.sports_basketball,
                                child: Text('Bob')),
                            mod.ModDropdownSearchMenuItem(
                                value: 'Carol',
                                icon: Icons.music_note,
                                child: Text('Carol')),
                            mod.ModDropdownSearchMenuItem(
                                value: 'David',
                                icon: Icons.computer,
                                child: Text('David')),
                            mod.ModDropdownSearchMenuItem(
                                value: 'Emma',
                                icon: Icons.brush,
                                child: Text('Emma')),
                            mod.ModDropdownSearchMenuItem(
                                value: 'Frank',
                                icon: Icons.restaurant,
                                child: Text('Frank')),
                            mod.ModDropdownSearchMenuItem(
                                value: 'Grace',
                                icon: Icons.pets,
                                child: Text('Grace')),
                            mod.ModDropdownSearchMenuItem(
                                value: 'Henry',
                                icon: Icons.sports_soccer,
                                child: Text('Henry')),
                            mod.ModDropdownSearchMenuItem(
                                value: 'Iris',
                                icon: Icons.camera_alt,
                                child: Text('Iris')),
                            mod.ModDropdownSearchMenuItem(
                                value: 'Jack',
                                icon: Icons.directions_bike,
                                child: Text('Jack')),
                          ],
                          multiSelect: false,
                          hint: 'Selecione um item',
                          label: 'Items',

                          size: mod.ModDropdownSearchSize.sm,
                          onChanged: (value) => log(value.toString()),
                          searchHint: "Pesquise por um item",
                          // dropdownBackgroundColor:Theme.of(context).appBarTheme.backgroundColor,
                          searchBoxPadding: const EdgeInsets.all(16),
                          //borderRadius: 16,
                          //backgroundColor: Colors.transparent,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const mod.ModCodeExample(
                    code: '''// Diferentes tamanhos de TextBox
ModTextBox(
  label: "Large TextBox",
  hint: "Enter text",
  size: ModTextBoxSize.lg,
  controller: TextEditingController(),
),

ModTextBox(
  label: "Medium TextBox",
  hint: "Enter text",
  size: ModTextBoxSize.md,
  controller: TextEditingController(),
),

ModTextBox(
  label: "Small TextBox",
  hint: "Enter text",
  size: ModTextBoxSize.sm,
  controller: TextEditingController(),
),

ModTextBox(
  label: "Extra Small TextBox",
  hint: "Enter text",
  size: ModTextBoxSize.xs,
  controller: TextEditingController(),
),

// TextBox com botão suffix
ModTextBox(
  label: "With Suffix Button",
  hint: "Enter text",
  size: ModTextBoxSize.sm,
  controller: TextEditingController(),
  suffixButton: ModButton(
    title: 'Action',
    type: ModButtonType.danger,
    size: ModButtonSize.xs,
    onPressed: () async {},
  ),
),''',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            mod.ModCard(
              header: const Text(
                "Simple TextBox Example",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  mod.ModTextBox(
                    label: "Input",
                    hint: "Enter text here",
                    multiline: true,
                    autoHeight: true,
                    controller: TextEditingController(),
                    onChange: (text) {
                      log("Input: $text");
                    },
                  ),
                  const SizedBox(height: 16),
                  const mod.ModCodeExample(
                    code: '''// TextBox multiline com altura automática
ModTextBox(
  label: "Input",
  hint: "Enter text here",
  multiline: true,
  autoHeight: true,
  controller: TextEditingController(),
  onChange: (text) {
    print("Input: \$text");
  },
),''',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            mod.ModCard(
              header: const Text(
                "Floating Label Examples",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Column(
                children: [
                  mod.ModTextBox(
                    label: "Floating Label (true)",
                    hint: "Digite aqui...",
                    floatingLabel: true,
                    controller: TextEditingController(),
                    onChange: (text) {
                      log("Floating Label: $text");
                    },
                  ),
                  const SizedBox(height: 16),
                  mod.ModTextBox(
                    label: "Label Fixo (false)",
                    hint: "Digite aqui...",
                    floatingLabel: false,
                    controller: TextEditingController(),
                    onChange: (text) {
                      log("Label Fixo: $text");
                    },
                  ),
                  const SizedBox(height: 16),
                  const mod.ModCodeExample(
                    code: '''// Floating Label ativo
ModTextBox(
  label: "Floating Label (true)",
  hint: "Digite aqui...",
  floatingLabel: true,
  controller: TextEditingController(),
),

// Floating Label desativado
ModTextBox(
  label: "Label Fixo (false)",
  hint: "Digite aqui...",
  floatingLabel: false,
  controller: TextEditingController(),
),''',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            mod.ModCard(
              header: const Text(
                "Floating Label Examples para DropDown",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: mod.ModDropDown<String>(
                          label: "Floating Label (true)",
                          hint: "Choose an option...",
                          floatingLabel: true,
                          value: selectedCountry,
                          items: countries
                              .map(
                                (country) => DropdownMenuItem(
                                  value: country,
                                  child: Text(country),
                                ),
                              )
                              .toList(),
                          onChanged: (value) =>
                              setState(() => selectedCountry = value),
                          size: mod.ModDropDownSize.md,
                          borderRadius: 8,
                          hasBorder: true,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: mod.ModDropDown<String>(
                          label: "Label Fixo (false)",
                          hint: "Choose an option...",
                          floatingLabel: false,
                          value: selectedCountry,
                          items: countries
                              .map(
                                (country) => DropdownMenuItem(
                                  value: country,
                                  child: Text(country),
                                ),
                              )
                              .toList(),
                          onChanged: (value) =>
                              setState(() => selectedCountry = value),
                          size: mod.ModDropDownSize.md,
                          borderRadius: 8,
                          hasBorder: true,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Floating Label: Quando ativo (floatingLabel: true), o label flutua para cima quando há um valor selecionado ou quando o campo tem foco. Quando inativo (floatingLabel: false), o label permanece fixo no topo.",
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  const mod.ModCodeExample(
                    code: '''// DropDown com Floating Label ativo
ModDropDown<String>(
  label: "Floating Label (true)",
  hint: "Choose an option...",
  floatingLabel: true,
  value: selectedValue,
  items: options.map((opt) => DropdownMenuItem(
    value: opt,
    child: Text(opt),
  )).toList(),
  onChanged: (value) => setState(() => selectedValue = value),
  size: ModDropDownSize.md,
  borderRadius: 8,
  hasBorder: true,
),

// DropDown com Floating Label desativado
ModDropDown<String>(
  label: "Label Fixo (false)",
  hint: "Choose an option...",
  floatingLabel: false,
  value: selectedValue,
  items: options.map((opt) => DropdownMenuItem(
    value: opt,
    child: Text(opt),
  )).toList(),
  onChanged: (value) => setState(() => selectedValue = value),
  size: ModDropDownSize.md,
  borderRadius: 8,
  hasBorder: true,
),''',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Exemplo de TextBox Number com botões à esquerda e direita
            mod.ModCard(
              header: const Text(
                "TextBox Number - Botões Esquerda/Direita",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "TextBox numérico com botões de incremento/decremento posicionados à esquerda e direita do campo.",
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  // Exemplo básico
                  mod.ModTextBox(
                    label: "Quantidade",
                    hint: "0",
                    value: "10",
                    numberMode: true,
                    numberButtonPosition: ModTextBoxNumberButtonPosition.leftRight,
                    minValue: 0,
                    maxValue: 100,
                    step: 1,
                    controller: TextEditingController(text: "10"),
                    onChange: (text) {
                      log("Quantidade: $text");
                    },
                  ),
                  const SizedBox(height: 16),
                  // Exemplo com decimais
                  mod.ModTextBox(
                    label: "Preço",
                    hint: "0.00",
                    value: "25.50",
                    numberMode: true,
                    numberButtonPosition: ModTextBoxNumberButtonPosition.leftRight,
                    minValue: 0.0,
                    maxValue: 1000.0,
                    step: 0.5,
                    decimalPlaces: 2,
                    controller: TextEditingController(text: "25.50"),
                    onChange: (text) {
                      log("Preço: $text");
                    },
                  ),
                  const SizedBox(height: 16),
                  // Exemplo com ícones customizados
                  mod.ModTextBox(
                    label: "Com Ícones Customizados",
                    hint: "0",
                    value: "5",
                    numberMode: true,
                    numberButtonPosition: ModTextBoxNumberButtonPosition.leftRight,
                    minValue: 0,
                    maxValue: 50,
                    step: 5,
                    incrementIcon: Icons.arrow_forward,
                    decrementIcon: Icons.arrow_back,
                    numberButtonColor: Colors.green,
                    controller: TextEditingController(text: "5"),
                    onChange: (text) {
                      log("Valor: $text");
                    },
                  ),
                  const SizedBox(height: 16),
                  const mod.ModCodeExample(
                    code: '''// TextBox numérico básico (inteiros)
ModTextBox(
  label: "Quantidade",
  hint: "0",
  value: "10",
  numberMode: true,
  numberButtonPosition: ModTextBoxNumberButtonPosition.leftRight,
  minValue: 0,
  maxValue: 100,
  step: 1,
  controller: TextEditingController(text: "10"),
  onChange: (text) {
    print("Quantidade: \$text");
  },
),

// TextBox numérico com decimais
ModTextBox(
  label: "Preço",
  hint: "0.00",
  value: "25.50",
  numberMode: true,
  numberButtonPosition: ModTextBoxNumberButtonPosition.leftRight,
  minValue: 0.0,
  maxValue: 1000.0,
  step: 0.5,
  decimalPlaces: 2,
  controller: TextEditingController(text: "25.50"),
),

// Com ícones customizados
ModTextBox(
  label: "Com Ícones Customizados",
  numberMode: true,
  numberButtonPosition: ModTextBoxNumberButtonPosition.leftRight,
  incrementIcon: Icons.arrow_forward,
  decrementIcon: Icons.arrow_back,
  numberButtonColor: Colors.green,
),''',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Exemplo de TextBox Number com botões acima e abaixo
            mod.ModCard(
              header: const Text(
                "TextBox Number - Botões Acima/Abaixo",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "TextBox numérico com botões de incremento/decremento posicionados acima e abaixo do campo.",
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Exemplo básico vertical
                      Expanded(
                        child: mod.ModTextBox(
                          label: "Idade",
                          hint: "0",
                          value: "25",
                          numberMode: true,
                          numberButtonPosition: ModTextBoxNumberButtonPosition.topBottom,
                          minValue: 0,
                          maxValue: 120,
                          step: 1,
                          controller: TextEditingController(text: "25"),
                          onChange: (text) {
                            log("Idade: $text");
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Exemplo com ícones customizados vertical
                      Expanded(
                        child: mod.ModTextBox(
                          label: "Nível",
                          hint: "0",
                          value: "3",
                          numberMode: true,
                          numberButtonPosition: ModTextBoxNumberButtonPosition.topBottom,
                          minValue: 1,
                          maxValue: 10,
                          step: 1,
                          incrementIcon: Icons.expand_less,
                          decrementIcon: Icons.expand_more,
                          numberButtonColor: Colors.orange,
                          numberButtonBackgroundColor: Colors.orange.withValues(alpha: 0.1),
                          controller: TextEditingController(text: "3"),
                          onChange: (text) {
                            log("Nível: $text");
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Exemplo com tamanho pequeno
                      Expanded(
                        child: mod.ModTextBox(
                          label: "Score",
                          hint: "0",
                          value: "100",
                          numberMode: true,
                          numberButtonPosition: ModTextBoxNumberButtonPosition.topBottom,
                          minValue: 0,
                          maxValue: 999,
                          step: 10,
                          size: ModTextBoxSize.sm,
                          controller: TextEditingController(text: "100"),
                          onChange: (text) {
                            log("Score: $text");
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const mod.ModCodeExample(
                    code: '''// TextBox numérico com botões acima/abaixo
ModTextBox(
  label: "Idade",
  hint: "0",
  value: "25",
  numberMode: true,
  numberButtonPosition: ModTextBoxNumberButtonPosition.topBottom,
  minValue: 0,
  maxValue: 120,
  step: 1,
  controller: TextEditingController(text: "25"),
),

// Com cores customizadas
ModTextBox(
  label: "Nível",
  numberMode: true,
  numberButtonPosition: ModTextBoxNumberButtonPosition.topBottom,
  minValue: 1,
  maxValue: 10,
  incrementIcon: Icons.expand_less,
  decrementIcon: Icons.expand_more,
  numberButtonColor: Colors.orange,
  numberButtonBackgroundColor: Colors.orange.withOpacity(0.1),
),

// Tamanho pequeno
ModTextBox(
  label: "Score",
  numberMode: true,
  numberButtonPosition: ModTextBoxNumberButtonPosition.topBottom,
  step: 10,
  size: ModTextBoxSize.sm,
),''',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Exemplo de diferentes tamanhos do TextBox Number
            mod.ModCard(
              header: const Text(
                "TextBox Number - Diferentes Tamanhos",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "TextBox numérico em diferentes tamanhos: lg, md, sm, xs.",
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  mod.ModTextBox(
                    label: "Tamanho LG",
                    numberMode: true,
                    size: ModTextBoxSize.lg,
                    value: "100",
                    controller: TextEditingController(text: "100"),
                    onChange: (text) => log("LG: $text"),
                  ),
                  const SizedBox(height: 12),
                  mod.ModTextBox(
                    label: "Tamanho MD",
                    numberMode: true,
                    size: ModTextBoxSize.md,
                    value: "50",
                    controller: TextEditingController(text: "50"),
                    onChange: (text) => log("MD: $text"),
                  ),
                  const SizedBox(height: 12),
                  mod.ModTextBox(
                    label: "Tamanho SM",
                    numberMode: true,
                    size: ModTextBoxSize.sm,
                    value: "25",
                    controller: TextEditingController(text: "25"),
                    onChange: (text) => log("SM: $text"),
                  ),
                  const SizedBox(height: 12),
                  mod.ModTextBox(
                    label: "Tamanho XS",
                    numberMode: true,
                    size: ModTextBoxSize.xs,
                    value: "10",
                    controller: TextEditingController(text: "10"),
                    onChange: (text) => log("XS: $text"),
                  ),
                  const SizedBox(height: 16),
                  const mod.ModCodeExample(
                    code: '''// Diferentes tamanhos de TextBox Number
ModTextBox(
  label: "Tamanho LG",
  numberMode: true,
  size: ModTextBoxSize.lg,
),

ModTextBox(
  label: "Tamanho MD",
  numberMode: true,
  size: ModTextBoxSize.md,
),

ModTextBox(
  label: "Tamanho SM",
  numberMode: true,
  size: ModTextBoxSize.sm,
),

ModTextBox(
  label: "Tamanho XS",
  numberMode: true,
  size: ModTextBoxSize.xs,
),''',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
