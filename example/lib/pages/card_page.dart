import 'package:example/main.dart';
import 'package:flutter/material.dart';
import 'package:mod_layout_one/mod_layout_one.dart';

class CardPage extends StatelessWidget {
  const CardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const CustomLayout(
      title: 'Cards',
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            ModCard(
              header: Text("Basic Card Example"),
              content: Center(
                child:
                    Text("This is a simple card with just header and content"),
              ),
            ),
            SizedBox(height: 16),
            ModCard(
              header: Text("Card with Footer"),
              content: Center(
                child: Text(
                    "This card demonstrates the usage with a footer section"),
              ),
              footer: Text("Additional information in footer"),
            ),
            SizedBox(height: 16),
            ModCard(
              header: Text("Accordion Card"),
              content: Center(
                child: Text(
                    "This card can be collapsed and expanded. Click the header to toggle."),
              ),
              footer: Text("Footer is hidden when collapsed"),
              borderRadius: 16,
              isAccordion: true,
            ),
            SizedBox(height: 16),
            ModCard(
              header: Text("Accordion with Visible Footer"),
              content: Center(
                child: Text(
                    "This card shows the footer even when content is collapsed"),
              ),
              footer: Text("This footer stays visible when collapsed"),
              borderRadius: 16,
              isAccordion: true,
              showFooterWhenCollapsed: true,
            ),
          ],
        ),
      ),
    );
  }
}
