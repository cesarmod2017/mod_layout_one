import 'dart:developer';

import 'package:example/main.dart';
import 'package:flutter/material.dart';
import 'package:mod_layout_one/mod_layout_one.dart' as mod;

class DropdownPage extends StatefulWidget {
  const DropdownPage({super.key});

  @override
  State<DropdownPage> createState() => _DropdownPageState();
}

class _DropdownPageState extends State<DropdownPage> {
  // Estado para ModDropDown
  String? selectedCountry = 'USA';
  String? selectedSize;
  String? selectedWithBorder = 'Brazil';
  String? selectedFloating;

  // Estado para ModDropdownSearch
  String? selectedUser;
  String? selectedCategory;
  List<String> selectedMultiple = [];

  // Dados de exemplo
  List<String> countries = ['USA', 'Canada', 'Mexico', 'Brazil', 'Argentina'];
  List<String> sizes = ['Small', 'Medium', 'Large', 'Extra Large'];
  List<String> categories = [
    'Technology',
    'Business',
    'Design',
    'Marketing',
    'Sales'
  ];

  @override
  Widget build(BuildContext context) {
    return CustomLayout(
      title: 'Dropdown Examples',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Seção: ModDropDown
            const Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: Text(
                'ModDropDown Examples',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // Exemplo 1: Basic ModDropDown
            mod.ModCard(
              header: const Text(
                "Basic DropDown",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  mod.ModDropDown<String>(
                    label: 'Select Country',
                    hint: 'Choose a country',
                    value: selectedCountry,
                    items: countries
                        .map((country) => DropdownMenuItem(
                              value: country,
                              child: Text(country),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() => selectedCountry = value);
                      log('Selected country: $value');
                    },
                    size: mod.ModDropDownSize.md,
                    borderRadius: 8,
                  ),
                  const SizedBox(height: 16),
                  const mod.ModCodeExample(
                    code: '''ModDropDown<String>(
  label: 'Select Country',
  hint: 'Choose a country',
  value: selectedCountry,
  items: countries.map((country) => DropdownMenuItem(
    value: country,
    child: Text(country),
  )).toList(),
  onChanged: (value) {
    setState(() => selectedCountry = value);
  },
  size: ModDropDownSize.md,
  borderRadius: 8,
),''',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Exemplo 2: ModDropDown with Border
            mod.ModCard(
              header: const Text(
                "DropDown with Border",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  mod.ModDropDown<String>(
                    label: 'Select Country',
                    hint: 'Choose a country',
                    value: selectedWithBorder,
                    items: countries
                        .map((country) => DropdownMenuItem(
                              value: country,
                              child: Text(country),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() => selectedWithBorder = value);
                      log('Selected country with border: $value');
                    },
                    size: mod.ModDropDownSize.md,
                    borderRadius: 8,
                    hasBorder: true,
                    borderWidth: 1.5,
                  ),
                  const SizedBox(height: 16),
                  const mod.ModCodeExample(
                    code: '''ModDropDown<String>(
  label: 'Select Country',
  hint: 'Choose a country',
  value: selectedValue,
  items: countries.map((country) => DropdownMenuItem(
    value: country,
    child: Text(country),
  )).toList(),
  onChanged: (value) => setState(() => selectedValue = value),
  size: ModDropDownSize.md,
  borderRadius: 8,
  hasBorder: true,
  borderWidth: 1.5,
),''',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Exemplo 3: ModDropDown Sizes
            mod.ModCard(
              header: const Text(
                "DropDown Sizes",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Column(
                children: [
                  mod.ModDropDown<String>(
                    label: 'Large Size (lg)',
                    hint: 'Choose a size',
                    value: null,
                    items: sizes
                        .map((size) => DropdownMenuItem(
                              value: size,
                              child: Text(size),
                            ))
                        .toList(),
                    onChanged: (value) => log('Large: $value'),
                    size: mod.ModDropDownSize.lg,
                    hasBorder: true,
                  ),
                  const SizedBox(height: 12),
                  mod.ModDropDown<String>(
                    label: 'Medium Size (md)',
                    hint: 'Choose a size',
                    value: null,
                    items: sizes
                        .map((size) => DropdownMenuItem(
                              value: size,
                              child: Text(size),
                            ))
                        .toList(),
                    onChanged: (value) => log('Medium: $value'),
                    size: mod.ModDropDownSize.md,
                    hasBorder: true,
                  ),
                  const SizedBox(height: 12),
                  mod.ModDropDown<String>(
                    label: 'Small Size (sm)',
                    hint: 'Choose a size',
                    value: null,
                    items: sizes
                        .map((size) => DropdownMenuItem(
                              value: size,
                              child: Text(size),
                            ))
                        .toList(),
                    onChanged: (value) => log('Small: $value'),
                    size: mod.ModDropDownSize.sm,
                    hasBorder: true,
                  ),
                  const SizedBox(height: 12),
                  mod.ModDropDown<String>(
                    label: 'Extra Small Size (xs)',
                    hint: 'Choose',
                    value: null,
                    items: sizes
                        .map((size) => DropdownMenuItem(
                              value: size,
                              child: Text(size),
                            ))
                        .toList(),
                    onChanged: (value) => log('Extra Small: $value'),
                    size: mod.ModDropDownSize.xs,
                    hasBorder: true,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Exemplo 4: ModDropDown Floating Label
            mod.ModCard(
              header: const Text(
                "DropDown Floating Label",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Row(
                children: [
                  Expanded(
                    child: mod.ModDropDown<String>(
                      label: 'Floating Label (true)',
                      hint: 'Select...',
                      floatingLabel: true,
                      value: selectedFloating,
                      items: countries
                          .map((country) => DropdownMenuItem(
                                value: country,
                                child: Text(country),
                              ))
                          .toList(),
                      onChanged: (value) =>
                          setState(() => selectedFloating = value),
                      size: mod.ModDropDownSize.md,
                      borderRadius: 8,
                      hasBorder: true,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: mod.ModDropDown<String>(
                      label: 'Fixed Label (false)',
                      hint: 'Select...',
                      floatingLabel: false,
                      value: selectedCountry,
                      items: countries
                          .map((country) => DropdownMenuItem(
                                value: country,
                                child: Text(country),
                              ))
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
            ),

            const SizedBox(height: 16),

            // Exemplo 5: ModDropDown with Prefix Icon
            mod.ModCard(
              header: const Text(
                "DropDown with Prefix Icon",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: mod.ModDropDown<String>(
                label: 'Select Country',
                hint: 'Choose a country',
                value: selectedCountry,
                prefixIcon: const Icon(Icons.flag),
                items: countries
                    .map((country) => DropdownMenuItem(
                          value: country,
                          child: Text(country),
                        ))
                    .toList(),
                onChanged: (value) => setState(() => selectedCountry = value),
                size: mod.ModDropDownSize.md,
                borderRadius: 8,
                hasBorder: true,
              ),
            ),

            const SizedBox(height: 32),

            // Seção: ModDropdownSearch
            const Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: Text(
                'ModDropdownSearch Examples',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // Exemplo 6: Basic ModDropdownSearch
            mod.ModCard(
              header: const Text(
                "Basic DropdownSearch",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  mod.ModDropdownSearch<String>(
                    label: 'Select User',
                    hint: 'Choose a user',
                    searchHint: 'Search users...',
                    backgroundHover: Colors.blueGrey,
                    value: selectedUser,
                    items: const [
                      mod.ModDropdownSearchMenuItem(
                        value: 'Alice',
                        icon: Icons.person,
                        child: Text('Alice'),
                      ),
                      mod.ModDropdownSearchMenuItem(
                        value: 'Bob',
                        icon: Icons.person,
                        child: Text('Bob'),
                      ),
                      mod.ModDropdownSearchMenuItem(
                        value: 'Carol',
                        icon: Icons.person,
                        child: Text('Carol'),
                      ),
                      mod.ModDropdownSearchMenuItem(
                        value: 'David',
                        icon: Icons.person,
                        child: Text('David'),
                      ),
                      mod.ModDropdownSearchMenuItem(
                        value: 'Emma',
                        icon: Icons.person,
                        child: Text('Emma'),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() => selectedUser = value);
                      log('Selected user: $value');
                    },
                    size: mod.ModDropdownSearchSize.md,
                    borderRadius: 8,
                    hasBorder: true,
                  ),
                  const SizedBox(height: 16),
                  const mod.ModCodeExample(
                    code: '''ModDropdownSearch<String>(
  label: 'Select User',
  hint: 'Choose a user',
  searchHint: 'Search users...',
  backgroundHover: Colors.blueGrey,
  value: selectedUser,
  items: const [
    ModDropdownSearchMenuItem(
      value: 'Alice',
      icon: Icons.person,
      child: Text('Alice'),
    ),
    ModDropdownSearchMenuItem(
      value: 'Bob',
      icon: Icons.person,
      child: Text('Bob'),
    ),
    // ... more items
  ],
  onChanged: (value) {
    setState(() => selectedUser = value);
  },
  size: ModDropdownSearchSize.md,
  borderRadius: 8,
  hasBorder: true,
),''',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Exemplo 7: ModDropdownSearch with Icons
            mod.ModCard(
              header: const Text(
                "DropdownSearch with Different Icons",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: mod.ModDropdownSearch<String>(
                label: 'Select Category',
                hint: 'Choose a category',
                searchHint: 'Search categories...',
                value: selectedCategory,
                items: const [
                  mod.ModDropdownSearchMenuItem(
                    value: 'Technology',
                    icon: Icons.computer,
                    child: Text('Technology'),
                  ),
                  mod.ModDropdownSearchMenuItem(
                    value: 'Business',
                    icon: Icons.business,
                    child: Text('Business'),
                  ),
                  mod.ModDropdownSearchMenuItem(
                    value: 'Design',
                    icon: Icons.brush,
                    child: Text('Design'),
                  ),
                  mod.ModDropdownSearchMenuItem(
                    value: 'Marketing',
                    icon: Icons.campaign,
                    child: Text('Marketing'),
                  ),
                  mod.ModDropdownSearchMenuItem(
                    value: 'Sales',
                    icon: Icons.attach_money,
                    child: Text('Sales'),
                  ),
                ],
                onChanged: (value) {
                  setState(() => selectedCategory = value);
                  log('Selected category: $value');
                },
                size: mod.ModDropdownSearchSize.md,
                borderRadius: 8,
                hasBorder: true,
              ),
            ),

            const SizedBox(height: 16),

            // Exemplo 8: ModDropdownSearch Sizes
            mod.ModCard(
              header: const Text(
                "DropdownSearch Sizes",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Column(
                children: [
                  mod.ModDropdownSearch<String>(
                    label: 'Large Size (lg)',
                    hint: 'Select...',
                    items: const [
                      mod.ModDropdownSearchMenuItem(
                        value: 'Option 1',
                        child: Text('Option 1'),
                      ),
                      mod.ModDropdownSearchMenuItem(
                        value: 'Option 2',
                        child: Text('Option 2'),
                      ),
                    ],
                    onChanged: (value) => log('Large: $value'),
                    size: mod.ModDropdownSearchSize.lg,
                    hasBorder: true,
                  ),
                  const SizedBox(height: 12),
                  mod.ModDropdownSearch<String>(
                    label: 'Medium Size (md)',
                    hint: 'Select...',
                    items: const [
                      mod.ModDropdownSearchMenuItem(
                        value: 'Option 1',
                        child: Text('Option 1'),
                      ),
                      mod.ModDropdownSearchMenuItem(
                        value: 'Option 2',
                        child: Text('Option 2'),
                      ),
                    ],
                    onChanged: (value) => log('Medium: $value'),
                    size: mod.ModDropdownSearchSize.md,
                    hasBorder: true,
                  ),
                  const SizedBox(height: 12),
                  mod.ModDropdownSearch<String>(
                    label: 'Small Size (sm)',
                    hint: 'Select...',
                    items: const [
                      mod.ModDropdownSearchMenuItem(
                        value: 'Option 1',
                        child: Text('Option 1'),
                      ),
                      mod.ModDropdownSearchMenuItem(
                        value: 'Option 2',
                        child: Text('Option 2'),
                      ),
                    ],
                    onChanged: (value) => log('Small: $value'),
                    size: mod.ModDropdownSearchSize.sm,
                    hasBorder: true,
                  ),
                  const SizedBox(height: 12),
                  mod.ModDropdownSearch<String>(
                    label: 'Extra Small Size (xs)',
                    hint: 'Select...',
                    items: const [
                      mod.ModDropdownSearchMenuItem(
                        value: 'Option 1',
                        child: Text('Option 1'),
                      ),
                      mod.ModDropdownSearchMenuItem(
                        value: 'Option 2',
                        child: Text('Option 2'),
                      ),
                    ],
                    onChanged: (value) => log('Extra Small: $value'),
                    size: mod.ModDropdownSearchSize.xs,
                    hasBorder: true,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Exemplo 9: ModDropdownSearch Floating Label
            mod.ModCard(
              header: const Text(
                "DropdownSearch Floating Label",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Row(
                children: [
                  Expanded(
                    child: mod.ModDropdownSearch<String>(
                      label: 'Floating Label',
                      hint: 'Select...',
                      floatingLabel: true,
                      items: const [
                        mod.ModDropdownSearchMenuItem(
                          value: 'Alice',
                          icon: Icons.person,
                          child: Text('Alice'),
                        ),
                        mod.ModDropdownSearchMenuItem(
                          value: 'Bob',
                          icon: Icons.person,
                          child: Text('Bob'),
                        ),
                        mod.ModDropdownSearchMenuItem(
                          value: 'Carol',
                          icon: Icons.person,
                          child: Text('Carol'),
                        ),
                      ],
                      onChanged: (value) => log('Floating: $value'),
                      size: mod.ModDropdownSearchSize.md,
                      hasBorder: true,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: mod.ModDropdownSearch<String>(
                      label: 'Fixed Label',
                      hint: 'Select...',
                      floatingLabel: false,
                      items: const [
                        mod.ModDropdownSearchMenuItem(
                          value: 'Alice',
                          icon: Icons.person,
                          child: Text('Alice'),
                        ),
                        mod.ModDropdownSearchMenuItem(
                          value: 'Bob',
                          icon: Icons.person,
                          child: Text('Bob'),
                        ),
                        mod.ModDropdownSearchMenuItem(
                          value: 'Carol',
                          icon: Icons.person,
                          child: Text('Carol'),
                        ),
                      ],
                      onChanged: (value) => log('Fixed: $value'),
                      size: mod.ModDropdownSearchSize.md,
                      hasBorder: true,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Exemplo 10: ModDropdownSearch without Search
            mod.ModCard(
              header: const Text(
                "DropdownSearch without Search Box",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: mod.ModDropdownSearch<String>(
                label: 'Select Item',
                hint: 'Choose an item',
                searchEnabled: false,
                items: const [
                  mod.ModDropdownSearchMenuItem(
                    value: 'Item 1',
                    icon: Icons.star,
                    child: Text('Item 1'),
                  ),
                  mod.ModDropdownSearchMenuItem(
                    value: 'Item 2',
                    icon: Icons.star,
                    child: Text('Item 2'),
                  ),
                  mod.ModDropdownSearchMenuItem(
                    value: 'Item 3',
                    icon: Icons.star,
                    child: Text('Item 3'),
                  ),
                ],
                onChanged: (value) => log('Selected: $value'),
                size: mod.ModDropdownSearchSize.md,
                hasBorder: true,
              ),
            ),

            const SizedBox(height: 16),

            // Exemplo 11: Keyboard Navigation and Auto-Focus
            mod.ModCard(
              header: const Text(
                "Keyboard Navigation & Auto-Focus",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Click to open dropdown. Search bar auto-focuses for immediate typing.\n'
                    'Use Arrow Up/Down to navigate items, Enter to select, Escape to close.',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 12),
                  mod.ModDropdownSearch<String>(
                    label: 'Select User (Keyboard Navigation)',
                    hint: 'Click and use arrow keys...',
                    searchHint: 'Type to search...',
                    items: const [
                      mod.ModDropdownSearchMenuItem(
                        value: 'Alice Johnson',
                        icon: Icons.person,
                        child: Text('Alice Johnson'),
                      ),
                      mod.ModDropdownSearchMenuItem(
                        value: 'Bob Smith',
                        icon: Icons.person,
                        child: Text('Bob Smith'),
                      ),
                      mod.ModDropdownSearchMenuItem(
                        value: 'Carol Williams',
                        icon: Icons.person,
                        child: Text('Carol Williams'),
                      ),
                      mod.ModDropdownSearchMenuItem(
                        value: 'David Brown',
                        icon: Icons.person,
                        child: Text('David Brown'),
                      ),
                      mod.ModDropdownSearchMenuItem(
                        value: 'Emma Davis',
                        icon: Icons.person,
                        child: Text('Emma Davis'),
                      ),
                    ],
                    onChanged: (value) => log('Keyboard selected: $value'),
                    size: mod.ModDropdownSearchSize.md,
                    hasBorder: true,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Exemplo 12: Custom Background Hover Color
            mod.ModCard(
              header: const Text(
                "Custom Background Hover Color",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Use backgroundHover property to customize the highlight color during keyboard navigation.',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 12),
                  mod.ModDropdownSearch<String>(
                    label: 'Select with Custom Hover',
                    hint: 'Navigate with arrow keys...',
                    searchHint: 'Search...',
                    backgroundHover: Colors.blue.withValues(alpha: 0.2),
                    items: const [
                      mod.ModDropdownSearchMenuItem(
                        value: 'Option A',
                        icon: Icons.star,
                        child: Text('Option A'),
                      ),
                      mod.ModDropdownSearchMenuItem(
                        value: 'Option B',
                        icon: Icons.star,
                        child: Text('Option B'),
                      ),
                      mod.ModDropdownSearchMenuItem(
                        value: 'Option C',
                        icon: Icons.star,
                        child: Text('Option C'),
                      ),
                    ],
                    onChanged: (value) => log('Custom hover selected: $value'),
                    size: mod.ModDropdownSearchSize.md,
                    hasBorder: true,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Exemplo 13: ModDropdownSearch with Prefix Icon
            mod.ModCard(
              header: const Text(
                "DropdownSearch with Prefix Icon",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: mod.ModDropdownSearch<String>(
                label: 'Select User',
                hint: 'Choose a user',
                searchHint: 'Search users...',
                prefixIcon: const Icon(Icons.group),
                items: const [
                  mod.ModDropdownSearchMenuItem(
                    value: 'Alice',
                    icon: Icons.person,
                    child: Text('Alice'),
                  ),
                  mod.ModDropdownSearchMenuItem(
                    value: 'Bob',
                    icon: Icons.person,
                    child: Text('Bob'),
                  ),
                  mod.ModDropdownSearchMenuItem(
                    value: 'Carol',
                    icon: Icons.person,
                    child: Text('Carol'),
                  ),
                ],
                onChanged: (value) => log('Selected with prefix: $value'),
                size: mod.ModDropdownSearchSize.md,
                hasBorder: true,
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
