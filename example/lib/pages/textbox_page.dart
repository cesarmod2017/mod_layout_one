import 'package:example/main.dart';
import 'package:flutter/material.dart';
import 'package:mod_layout_one/mod_layout_one.dart' as mod;

class TextBoxPage extends StatelessWidget {
  const TextBoxPage({super.key});

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
          ],
        ),
      ),
    );
  }
}
