import 'package:example/main.dart';
import 'package:flutter/material.dart';
import 'package:mod_layout_one/mod_layout_one.dart';

class TextCopyPage extends StatelessWidget {
  const TextCopyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomLayout(
      title: 'Text Copy',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ModCard(
              header: const Text(
                "Text Copy Examples",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Click on any text below to copy:"),
                  const SizedBox(height: 16),
                  const ModTextCopy(
                    textToCopy: "Hello World!",
                    child: Text(
                      "Hello World!",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const ModTextCopy(
                    textToCopy:
                        "This is a longer text that can be copied with a single click",
                    child: Text(
                      "This is a longer text that can be copied with a single click",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ModTextCopy(
                    textToCopy: "example@email.com",
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        "example@email.com",
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: "monospace",
                        ),
                      ),
                    ),
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
