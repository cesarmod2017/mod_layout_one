import 'package:example/main.dart';
import 'package:flutter/material.dart';
import 'package:mod_layout_one/mod_layout_one.dart' as mod;

class TabsPage extends StatelessWidget {
  const TabsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomLayout(
      title: 'Tabs Examples',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            mod.ModCard(
              header: const Text(
                "Basic Tabs",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: mod.ModTabs(
                tabs: const [
                  Text('Tab 1'),
                  Text('Tab 2'),
                  Text('Tab 3'),
                ],
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: const Text(
                      'Content 1',
                      style: TextStyle(
                        color: Color(0xffa09f9f),
                        fontFamily: 'Segoe UI',
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.3,
                        height: 1.4,
                        decoration: TextDecoration.none,
                      ),
                      textAlign: TextAlign.start,
                      textDirection: TextDirection.ltr,
                      softWrap: true,
                      overflow: TextOverflow.clip,
                      locale: Locale('en', 'US'),
                      maxLines: null,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: const Text('Content 2'),
                  ),
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: const Text('Content 3'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            mod.ModCard(
              header: const Text(
                "Bottom Tabs",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: mod.ModTabs(
                orientation: mod.TabOrientation.horizontalBottom,
                tabs: const [
                  Text('Tab 1'),
                  Text('Tab 2'),
                ],
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: const Text('Content 1'),
                  ),
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: const Text('Content 2'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            mod.ModCard(
              header: const Text(
                "Vertical Left Tabs",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: SizedBox(
                height: 200,
                child: mod.ModTabs(
                  orientation: mod.TabOrientation.verticalLeft,
                  tabs: const [
                    Text('Tab 1'),
                    Text('Tab 2'),
                  ],
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      child: const Text('Content 1'),
                    ),
                    Container(
                      padding: const EdgeInsets.all(16),
                      child: const Text('Content 2'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            mod.ModCard(
              header: const Text(
                "Tabs with Icons",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: mod.ModTabs(
                tabs: const [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.home),
                      SizedBox(width: 8),
                      Text('Home'),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.settings),
                      SizedBox(width: 8),
                      Text('Settings'),
                    ],
                  ),
                ],
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: const Text('Home Content'),
                  ),
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: const Text('Settings Content'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            mod.ModCard(
              header: const Text(
                "Custom Styled Tabs",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: SizedBox(
                width: double.infinity,
                child: mod.ModTabs(
                  selectedTabColor: Colors.red,
                  unselectedTabColor: Colors.transparent,
                  selectedTextColor: Colors.red,
                  unselectedTextColor: Colors.grey,
                  selectedBackgroundColor: Colors.black45,
                  alignment: mod.TabAlignment.justify,
                  orientation: mod.TabOrientation.horizontalTop,
                  minWidthTabs: 200,
                  tabs: const [
                    Text('Tab 1'),
                    Text('Tab 2'),
                    Text('Tab 3'),
                    Text('Tab 4'),
                    Text('Tab 5'),
                    Text('Tab 6'),
                    Text('Tab 7'),
                    Text('Tab 8'),
                  ],
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      child: const Text('Custom Content 1'),
                    ),
                    Container(
                      padding: const EdgeInsets.all(16),
                      child: const Text('Custom Content 2'),
                    ),
                    Container(
                      padding: const EdgeInsets.all(16),
                      child: const Text('Custom Content 1'),
                    ),
                    Container(
                      padding: const EdgeInsets.all(16),
                      child: const Text('Custom Content 2'),
                    ),
                    Container(
                      padding: const EdgeInsets.all(16),
                      child: const Text('Custom Content 1'),
                    ),
                    Container(
                      padding: const EdgeInsets.all(16),
                      child: const Text('Custom Content 2'),
                    ),
                    Container(
                      padding: const EdgeInsets.all(16),
                      child: const Text('Custom Content 1'),
                    ),
                    Container(
                      padding: const EdgeInsets.all(16),
                      child: const Text('Custom Content 2'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
