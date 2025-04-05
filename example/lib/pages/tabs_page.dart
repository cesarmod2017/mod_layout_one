import 'package:example/controllers/app_controller.dart';
import 'package:example/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mod_layout_one/mod_layout_one.dart' as mod;

class TabsPage extends StatefulWidget {
  const TabsPage({super.key});

  @override
  State<TabsPage> createState() => _TabsPageState();
}

class _TabsPageState extends State<TabsPage> {
  List<mod.ModTab> tabs = <mod.ModTab>[
    const mod.ModTab(text: 'main.dart', closeable: true),
    const mod.ModTab(text: 'styles.css', closeable: true),
    const mod.ModTab(text: 'index_teste_teste.html', closeable: true),
    const mod.ModTab(text: 'New Tab', closeable: true),
  ];

  List<Widget> children = <Widget>[
    Container(
      padding: const EdgeInsets.all(16),
      child: const Text('Dart source code content'),
    ),
    Container(
      padding: const EdgeInsets.all(16),
      child: const Text('CSS styles content'),
    ),
    Container(
      padding: const EdgeInsets.all(16),
      child: const Text('HTML markup content'),
    ),
    Container(
      padding: const EdgeInsets.all(16),
      child: const Text('New Tab Content'),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppController>(builder: (controller) {
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
                  borderType: mod.TabBorderType.all,
                  orientation: mod.TabOrientation.horizontalTop,
                  tabs: const [
                    mod.ModTab(text: 'Tab 1'),
                    mod.ModTab(text: 'Tab 2'),
                    mod.ModTab(text: 'Tab 3'),
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
                    mod.ModTab(text: 'Tab 1'),
                    mod.ModTab(text: 'Tab 2'),
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
                      mod.ModTab(text: 'Tab 1'),
                      mod.ModTab(text: 'Tab 2'),
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
                    mod.ModTab(
                      text: 'Home',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    mod.ModTab(
                      text: 'Settings',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
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
                    minTabWidth: 200,
                    shrinkToFit: true,
                    tabs: const [
                      mod.ModTab(text: 'Tab 1', closeable: true),
                      mod.ModTab(text: 'Tab 2', closeable: true),
                      mod.ModTab(text: 'Tab 3', closeable: true),
                      mod.ModTab(text: 'Tab 4', closeable: true),
                      mod.ModTab(text: 'Tab 5', closeable: true),
                      mod.ModTab(text: 'Tab 6', closeable: true),
                      mod.ModTab(text: 'Tab 7', closeable: true),
                      mod.ModTab(text: 'Tab 8'),
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
                        child: const Text('Custom Content 3'),
                      ),
                      Container(
                        padding: const EdgeInsets.all(16),
                        child: const Text('Custom Content 4'),
                      ),
                      Container(
                        padding: const EdgeInsets.all(16),
                        child: const Text('Custom Content 5'),
                      ),
                      Container(
                        padding: const EdgeInsets.all(16),
                        child: const Text('Custom Content 6'),
                      ),
                      Container(
                        padding: const EdgeInsets.all(16),
                        child: const Text('Custom Content 7'),
                      ),
                      Container(
                        padding: const EdgeInsets.all(16),
                        child: const Text('Custom Content 8'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              mod.ModCard(
                header: const Text(
                  "Expandable Tabs",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                content: mod.ModTabs(
                  shrinkToFit: true,
                  tabs: const [
                    mod.ModTab(text: 'Short Tab'),
                    mod.ModTab(text: 'A Much Longer Tab Title'),
                    mod.ModTab(text: 'Another Long Tab Title Here'),
                  ],
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      child: const Text('Short tab content'),
                    ),
                    Container(
                      padding: const EdgeInsets.all(16),
                      child: const Text('Longer tab content here'),
                    ),
                    Container(
                      padding: const EdgeInsets.all(16),
                      child: const Text('Even more content in this tab'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              mod.ModCard(
                header: const Text(
                  "Source Code Tabs",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                content: mod.ModTabs(
                  emptyWidget: Center(
                      child: Column(
                    children: [
                      const Text('No tabs available'),
                      IconButton(
                          onPressed: () => controller.addTab(),
                          icon: Icon(Icons.add))
                    ],
                  )),
                  enableNewTab: true,
                  selectedTextColor: Colors.yellow,
                  onNewTab: () {
                    controller.addTab();
                  },
                  onTabSelected: (index, tab) {
                    final tabData = tab.data as TabData;
                    print('onTabSelected: $index, ${tabData.content}');
                  },
                  tabs: controller.contentTabs,
                  children: controller.contentChildren,
                  onTabClose: (index, tab) {
                    controller.removeTab(index);
                  },
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
