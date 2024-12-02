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
              content: mod.ModTextBox(
                label: "Name",
                hint: "Enter your name",
                controller: TextEditingController(),
                onChange: (text) {
                  // This ensures the text is updated in the TextBox
                  print("Name: $text");
                },
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
              content: mod.ModTextBox(
                label: "Password",
                hint: "Enter your password",
                isPassword: true,
                controller: TextEditingController(text: "dada"),
                onChange: (text) {
                  // This ensures the text is updated in the TextBox
                  print("Password: $text");
                },
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
              content: mod.ModTextBox(
                label: "Email",
                hint: "Enter your email",
                style: const TextStyle(color: Colors.green),
                borderRadius: 16.0,
                keyboardType: TextInputType.emailAddress,
                readOnly: false,
                controller: TextEditingController(),
                onChange: (text) {
                  print("Email: $text");
                },
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
                      print("Large TextBox: $text");
                    },
                  ),
                  const SizedBox(height: 16),
                  mod.ModTextBox(
                    label: "Medium TextBox",
                    hint: "Enter text",
                    size: ModTextBoxSize.md,
                    controller: TextEditingController(),
                    onChange: (text) {
                      print("Medium TextBox: $text");
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        child: mod.ModTextBox(
                          //label: "Small TextBox",
                          hint: "Enter text",
                          size: ModTextBoxSize.xs,
                          controller: TextEditingController(),
                          onChange: (text) {
                            print("Small TextBox: $text");
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
                        child: mod.ModTextBox(
                          label: "Extra Small TextBox",
                          hint: "Enter text",
                          size: ModTextBoxSize.sm,
                          controller: TextEditingController(),
                          onChange: (text) {
                            print("Extra Small TextBox: $text");
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
                        child: ModDropDown<String>(
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
                        child: mod.ModDropdownSearch<String>(
                          items: const [
                            mod.ModDropdownSearchMenuItem(
                                value: 'Alice',
                                icon: Icons.face,
                                child: Text('Alice')),
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
                          onChanged: (value) => print(value),
                          dropdownBackgroundColor:
                              Theme.of(context).appBarTheme.backgroundColor,
                          searchBoxPadding: const EdgeInsets.all(16),
                          borderRadius: 16,
                          backgroundColor: Colors.transparent,
                        ),
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
