import 'dart:developer';

import 'package:example/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mod_layout_one/mod_layout_one.dart' hide BorderStyle;
import 'package:mod_layout_one/widgets/datatable/datatable.dart' as datatable;

class TablesPage extends StatefulWidget {
  const TablesPage({super.key});

  @override
  State<TablesPage> createState() => _TablesPageState();
}

class _TablesPageState extends State<TablesPage> {
  final bool _sortAscending = true;
  final int _sortColumnIndex = 0;

  // State for performance test table
  int _perfColumns = 5;
  int _perfRows = 50;
  int _perfRowsPerPage = 20;
  int _perfCurrentPage = 0;
  double _perfRowHeight = 35;
  final Stopwatch _perfStopwatch = Stopwatch();
  String _perfBuildTime = '-';

  List<ModDataHeader> get _perfHeaders {
    return List.generate(_perfColumns, (i) => ModDataHeader(
      child: Text('Col ${i + 1}', style: const TextStyle(fontWeight: FontWeight.bold)),
      widthType: WidthType.fixed,
      width: 150,
      sortable: true,
      field: 'col_$i',
    ));
  }

  List<Map<String, dynamic>> get _perfData {
    return List.generate(_perfRows, (row) {
      final map = <String, dynamic>{};
      for (int col = 0; col < _perfColumns; col++) {
        map['col_$col'] = 'R${row + 1} C${col + 1}';
      }
      return map;
    });
  }

  // State for action bar example
  List<String>? _visibleColumns = ['name', 'city'];

  // State for EmptyView example
  List<Map<String, dynamic>> _emptyViewExampleData = [
    {'id': 1, 'product': 'Laptop', 'price': 1299.99, 'stock': 15},
    {'id': 2, 'product': 'Mouse', 'price': 29.99, 'stock': 150},
    {'id': 3, 'product': 'Keyboard', 'price': 79.99, 'stock': 85},
    {'id': 4, 'product': 'Monitor', 'price': 349.99, 'stock': 30},
    {'id': 5, 'product': 'Headset', 'price': 99.99, 'stock': 60},
  ];

  final List<Map<String, dynamic>> _data = [
    {'name': 'John Doe', 'age': 30, 'city': 'New York'},
    {'name': 'Jane Smith', 'age': 25, 'city': 'Los Angeles'},
    {'name': 'Bob Johnson', 'age': 35, 'city': 'Chicago'},
    {'name': 'Alice Brown', 'age': 28, 'city': 'Houston'},
    {'name': 'Charlie Wilson', 'age': 42, 'city': 'Phoenix'},
    {'name': 'David Lee', 'age': 33, 'city': 'Boston'},
    {'name': 'Emma Davis', 'age': 29, 'city': 'Seattle'},
    {'name': 'Frank Miller', 'age': 45, 'city': 'Miami'},
    {'name': 'Grace Taylor', 'age': 31, 'city': 'Denver'},
    {'name': 'Henry Wilson', 'age': 38, 'city': 'Austin'},
    {'name': 'Ivy Clark', 'age': 27, 'city': 'Portland'},
    {'name': 'Jack Adams', 'age': 36, 'city': 'Atlanta'},
    {'name': 'Kelly White', 'age': 34, 'city': 'Dallas'},
    {'name': 'Liam Moore', 'age': 41, 'city': 'San Diego'},
    {'name': 'Mia Garcia', 'age': 26, 'city': 'San Francisco'},
    {'name': 'Noah Martin', 'age': 39, 'city': 'Philadelphia'},
    {'name': 'Olivia Lopez', 'age': 32, 'city': 'Detroit'},
    {'name': 'Peter King', 'age': 44, 'city': 'Minneapolis'},
    {'name': 'Quinn Evans', 'age': 37, 'city': 'Baltimore'},
    {'name': 'Rachel Green', 'age': 29, 'city': 'Las Vegas'},
    {'name': 'Samuel Cooper', 'age': 43, 'city': 'Nashville'},
    {'name': 'Tara Murphy', 'age': 30, 'city': 'Cleveland'},
    {'name': 'Uma Patel', 'age': 35, 'city': 'Pittsburgh'},
    {'name': 'Victor Reed', 'age': 40, 'city': 'St. Louis'},
    {'name': 'Wendy Hill', 'age': 28, 'city': 'Kansas City'},
    {'name': 'Xavier Long', 'age': 46, 'city': 'Sacramento'},
    {'name': 'Yara Ross', 'age': 33, 'city': 'Orlando'},
    {'name': 'Zack Baker', 'age': 31, 'city': 'Charlotte'},
    {'name': 'Amy Chen', 'age': 36, 'city': 'Tampa'},
    {'name': 'Ben Wright', 'age': 42, 'city': 'Indianapolis'},
    {'name': 'Cara Young', 'age': 27, 'city': 'Columbus'},
    {'name': 'Dan Hall', 'age': 39, 'city': 'Cincinnati'},
    {'name': 'Eva Wood', 'age': 34, 'city': 'Milwaukee'},
    {'name': 'Fred Cox', 'age': 45, 'city': 'Memphis'},
    {'name': 'Gina Park', 'age': 29, 'city': 'Louisville'},
    {'name': 'Hans Berg', 'age': 41, 'city': 'Buffalo'},
    {'name': 'Ida Shaw', 'age': 32, 'city': 'Richmond'},
    {'name': 'Jay Cole', 'age': 38, 'city': 'Jacksonville'},
    {'name': 'Kim Lee', 'age': 30, 'city': 'Salt Lake City'},
    {'name': 'Leo Fox', 'age': 37, 'city': 'Oklahoma City'}
  ];

  List<Map<String, dynamic>> get _sortedData {
    final data = List<Map<String, dynamic>>.from(_data);
    final key = _sortColumnIndex == 0
        ? 'name'
        : _sortColumnIndex == 1
            ? 'age'
            : 'city';

    data.sort((a, b) {
      final aValue = a[key];
      final bValue = b[key];
      return _sortAscending
          ? Comparable.compare(aValue, bValue)
          : Comparable.compare(bValue, aValue);
    });
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return CustomLayout(
      title: 'Tables',
      footer: Text('footer'.tr),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Basic DataTable with sorting

            // Styled DataTable with pagination

            ModCard(
              header: Row(
                children: [
                  const Text(
                    "Performance Test",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      'Build: $_perfBuildTime',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      'Widgets: ~${_perfRowsPerPage * _perfColumns} cells',
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.onSecondaryContainer,
                      ),
                    ),
                  ),
                ],
              ),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Controls
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                    child: Wrap(
                      spacing: 24,
                      runSpacing: 12,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        // Columns control
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('Columns: ', style: TextStyle(fontWeight: FontWeight.w600)),
                            SizedBox(
                              width: 200,
                              child: Slider(
                                value: _perfColumns.toDouble(),
                                min: 1,
                                max: 30,
                                divisions: 29,
                                label: '$_perfColumns',
                                onChanged: (v) => setState(() {
                                  _perfColumns = v.toInt();
                                  _perfCurrentPage = 0;
                                }),
                              ),
                            ),
                            Text('$_perfColumns', style: const TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                        // Total rows control
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('Total rows: ', style: TextStyle(fontWeight: FontWeight.w600)),
                            SizedBox(
                              width: 200,
                              child: Slider(
                                value: _perfRows.toDouble(),
                                min: 1,
                                max: 5000,
                                divisions: 100,
                                label: '$_perfRows',
                                onChanged: (v) => setState(() {
                                  _perfRows = v.toInt();
                                  _perfCurrentPage = 0;
                                }),
                              ),
                            ),
                            Text('$_perfRows', style: const TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                        // Row height control
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('Row height: ', style: TextStyle(fontWeight: FontWeight.w600)),
                            SizedBox(
                              width: 150,
                              child: Slider(
                                value: _perfRowHeight,
                                min: 20,
                                max: 80,
                                divisions: 12,
                                label: '${_perfRowHeight.toInt()}',
                                onChanged: (v) => setState(() {
                                  _perfRowHeight = v;
                                }),
                              ),
                            ),
                            Text('${_perfRowHeight.toInt()}px', style: const TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  // The DataTable
                  Builder(
                    builder: (context) {
                      _perfStopwatch.reset();
                      _perfStopwatch.start();

                      final data = _perfData;
                      final headers = _perfHeaders;

                      final table = ModDataTable(
                        paginationBorderRadius: 1,
                        headerBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
                        footerBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
                        oddRowColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                        evenRowColor: Theme.of(context).scaffoldBackgroundColor,
                        fixedHeader: true,
                        showHorizontalScrollbar: true,
                        enableColumnResize: true,
                        headers: headers,
                        data: data,
                        source: _DynamicDataSource(data, _perfColumns),
                        currentPage: _perfCurrentPage,
                        rowsPerPage: _perfRowsPerPage,
                        totalRecords: data.length,
                        onPageChanged: (page) {
                          setState(() => _perfCurrentPage = page);
                        },
                        onSort: (field, direction) {
                          log('Sorting by $field in $direction direction');
                        },
                        rowHeight: _perfRowHeight,
                        paginationText: 'of',
                        rowsPerPageText: 'Rows/page',
                        onRowsPerPageChanged: (rowsPerPage) {
                          setState(() {
                            _perfRowsPerPage = rowsPerPage;
                            _perfCurrentPage = 0;
                          });
                        },
                        availableRowsPerPage: const [5, 10, 20, 50, 100, 200, 500],
                      );

                      _perfStopwatch.stop();
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (mounted) {
                          final time = _perfStopwatch.elapsedMilliseconds;
                          if (_perfBuildTime != '${time}ms') {
                            setState(() => _perfBuildTime = '${time}ms');
                          }
                        }
                      });

                      return table;
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ModCard(
              header: const Text(
                "Wide Table with Horizontal Scroll",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: ModDataTable(
                fixedHeader: true,
                showHorizontalScrollbar: true,
                headers: [
                  ModDataHeader(
                    child: const SelectableText('ID'),
                    widthType: WidthType.fixed,
                    width: 80,
                    sortable: true,
                    field: 'id',
                  ),
                  ModDataHeader(
                    child: const SelectableText('Name'),
                    widthType: WidthType.fixed,
                    width: 150,
                    sortable: true,
                    field: 'name',
                  ),
                  ModDataHeader(
                    child: const SelectableText('Department'),
                    widthType: WidthType.fixed,
                    width: 150,
                    sortable: true,
                    field: 'department',
                  ),
                  ModDataHeader(
                    child: const SelectableText('Position'),
                    widthType: WidthType.fixed,
                    width: 150,
                    sortable: true,
                    field: 'position',
                  ),
                  ModDataHeader(
                    child: const SelectableText('Salary'),
                    widthType: WidthType.fixed,
                    width: 120,
                    sortable: true,
                    field: 'salary',
                  ),
                  ModDataHeader(
                    child: const SelectableText('Start Date'),
                    widthType: WidthType.fixed,
                    width: 120,
                    sortable: true,
                    field: 'startDate',
                  ),
                  ModDataHeader(
                    child: const SelectableText('Location'),
                    widthType: WidthType.fixed,
                    width: 150,
                    sortable: true,
                    field: 'location',
                  ),
                  ModDataHeader(
                    child: const SelectableText('Email'),
                    widthType: WidthType.fixed,
                    width: 200,
                    sortable: true,
                    field: 'email',
                  ),
                  ModDataHeader(
                    child: const SelectableText('Phone'),
                    widthType: WidthType.fixed,
                    width: 150,
                    sortable: true,
                    field: 'phone',
                  ),
                  ModDataHeader(
                    child: const SelectableText('Status'),
                    widthType: WidthType.fixed,
                    width: 120,
                    sortable: true,
                    field: 'status',
                  ),
                  ModDataHeader(
                    child: const SelectableText('Projects'),
                    widthType: WidthType.fixed,
                    width: 550,
                    sortable: true,
                    field: 'projects',
                  ),
                  ModDataHeader(
                    child: const SelectableText('Performance'),
                    widthType: WidthType.fixed,
                    width: 550,
                    sortable: true,
                    field: 'performance',
                  ),
                  ModDataHeader(
                    child: const SelectableText('Training'),
                    widthType: WidthType.fixed,
                    width: 550,
                    sortable: true,
                    field: 'training',
                  ),
                  ModDataHeader(
                    child: const SelectableText('Certifications'),
                    widthType: WidthType.fixed,
                    width: 550,
                    sortable: true,
                    field: 'certifications',
                  ),
                  ModDataHeader(
                    child: const SelectableText('Notes'),
                    widthType: WidthType.fixed,
                    width: 200,
                    sortable: true,
                    field: 'notes',
                  ),
                ],
                data: const [
                  {
                    'id': 'EMP001',
                    'name': 'John Smith',
                    'department': 'Engineering',
                    'position': 'Senior Developer',
                    'salary': '\$95,000',
                    'startDate': '2020-01-15',
                    'location': 'New York',
                    'email': 'john.smith@company.com',
                    'phone': '(555) 123-4567',
                    'status': 'Active',
                    'projects': 'Project A, B',
                    'performance': 'Excellent',
                    'training': 'Completed',
                    'certifications': 'AWS, Azure',
                    'notes': 'Team lead for Project X'
                  },
                  {
                    'id': 'EMP002',
                    'name': 'Sarah Johnson',
                    'department': 'Marketing',
                    'position': 'Marketing Manager',
                    'salary': '\$85,000',
                    'startDate': '2019-06-20',
                    'location': 'Chicago',
                    'email': 'sarah.j@company.com',
                    'phone': '(555) 234-5678',
                    'status': 'Active',
                    'projects': 'Campaign Y',
                    'performance': 'Good',
                    'training': 'In Progress',
                    'certifications': 'Google Ads',
                    'notes': 'Leading Q4 campaign'
                  },
                  {
                    'id': 'EMP003',
                    'name': 'Michael Chen',
                    'department': 'Finance',
                    'position': 'Financial Analyst',
                    'salary': '\$78,000',
                    'startDate': '2021-03-10',
                    'location': 'Boston',
                    'email': 'm.chen@company.com',
                    'phone': '(555) 345-6789',
                    'status': 'Active',
                    'projects': 'Budget 2023',
                    'performance': 'Very Good',
                    'training': 'Completed',
                    'certifications': 'CFA Level 2',
                    'notes': 'Q2 analysis pending'
                  },
                ],
                source: _WideDataSource(const [
                  {
                    'id': 'EMP001',
                    'name': 'John Smith',
                    'department': 'Engineering',
                    'position': 'Senior Developer',
                    'salary': '\$95,000',
                    'startDate': '2020-01-15',
                    'location': 'New York',
                    'email': 'john.smith@company.com',
                    'phone': '(555) 123-4567',
                    'status': 'Active',
                    'projects': 'Project A, B',
                    'performance': 'Excellent',
                    'training': 'Completed',
                    'certifications': 'AWS, Azure',
                    'notes': 'Team lead for Project X'
                  },
                  {
                    'id': 'EMP002',
                    'name': 'Sarah Johnson',
                    'department': 'Marketing',
                    'position': 'Marketing Manager',
                    'salary': '\$85,000',
                    'startDate': '2019-06-20',
                    'location': 'Chicago',
                    'email': 'sarah.j@company.com',
                    'phone': '(555) 234-5678',
                    'status': 'Active',
                    'projects': 'Campaign Y',
                    'performance': 'Good',
                    'training': 'In Progress',
                    'certifications': 'Google Ads',
                    'notes': 'Leading Q4 campaign'
                  },
                  {
                    'id': 'EMP003',
                    'name': 'Michael Chen',
                    'department': 'Finance',
                    'position': 'Financial Analyst',
                    'salary': '\$78,000',
                    'startDate': '2021-03-10',
                    'location': 'Boston',
                    'email': 'm.chen@company.com',
                    'phone': '(555) 345-6789',
                    'status': 'Active',
                    'projects': 'Budget 2023',
                    'performance': 'Very Good',
                    'training': 'Completed',
                    'certifications': 'CFA Level 2',
                    'notes': 'Q2 analysis pending'
                  },
                ]),
                currentPage: 0,
                rowsPerPage: 5,
                totalRecords: 0,
                onColumnWidthChanged: (field, width) {
                  log('Column width changed: $field to $width');
                },
                enableSimplePagination: true,
                oddRowColor:
                    Theme.of(context).colorScheme.surfaceContainerHighest,
                evenRowColor: Theme.of(context).colorScheme.surfaceContainer,
                onPageChanged: (page) {
                  log('Page changed: $page');
                },
                onSort: (field, direction) {
                  log('Sorting by $field in $direction direction');
                },
                rowHeight: 50,
                paginationText: 'of',
                rowsPerPageText: 'Rows per page',
                footerBackgroundColor: Theme.of(context).colorScheme.surface,
                headerBackgroundColor: Theme.of(context).colorScheme.surface,
                onRowsPerPageChanged: (rowsPerPage) {
                  log('Rows per page changed: $rowsPerPage');
                },
                availableRowsPerPage: const [1, 5, 10, 15, 20],
              ),
            ),
            const SizedBox(height: 8),
            const ModCodeExample(
              code: '''// Wide Table with Horizontal Scroll
ModDataTable(
  fixedHeader: true,
  showHorizontalScrollbar: true,
  headers: [
    ModDataHeader(
      child: const SelectableText('ID'),
      widthType: WidthType.fixed,
      width: 80,
      sortable: true,
      field: 'id',
    ),
    ModDataHeader(
      child: const SelectableText('Name'),
      widthType: WidthType.fixed,
      width: 150,
      sortable: true,
      field: 'name',
    ),
    // ... more headers
  ],
  data: employeeData,
  source: _WideDataSource(employeeData),
  currentPage: 0,
  rowsPerPage: 5,
  totalRecords: 0,
  enableSimplePagination: true,
  oddRowColor: Theme.of(context).colorScheme.surfaceContainerHighest,
  evenRowColor: Theme.of(context).colorScheme.surfaceContainer,
  onPageChanged: (page) {
    log('Page changed: \$page');
  },
  onSort: (field, direction) {
    log('Sorting by \$field in \$direction direction');
  },
),''',
            ),
            const SizedBox(height: 20),
            ModCard(
              header: const Text(
                "Demonstração do Scroll Horizontal",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Esta tabela demonstra o scroll horizontal:",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        const Text("• Scrollbar horizontal CUSTOMIZADO"),
                        const Text(
                            "• Clique em qualquer lugar da trilha para ir direto"),
                        const Text("• ARRASTO CONTÍNUO garantido no Windows"),
                        const Text("• Implementação 100% personalizada"),
                        const Text(
                            "• Use showHorizontalScrollbar: true para ativar"),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                  ModDataTable(
                    showHorizontalScrollbar: true,
                    borderStyle: datatable.BorderStyle.topLeftRightBottom,
                    headers: [
                      ModDataHeader(
                        child: const Text('Col 1'),
                        widthType: WidthType.fixed,
                        width: 200,
                        field: 'col1',
                      ),
                      ModDataHeader(
                        child: const Text('Col 2'),
                        widthType: WidthType.fixed,
                        width: 200,
                        field: 'col2',
                      ),
                      ModDataHeader(
                        child: const Text('Col 3'),
                        widthType: WidthType.fixed,
                        width: 200,
                        field: 'col3',
                      ),
                      ModDataHeader(
                        child: const Text('Col 4'),
                        widthType: WidthType.fixed,
                        width: 200,
                        field: 'col4',
                      ),
                      ModDataHeader(
                        child: const Text('Col 5'),
                        widthType: WidthType.fixed,
                        width: 200,
                        field: 'col5',
                      ),
                      ModDataHeader(
                        child: const Text('Col 6'),
                        widthType: WidthType.fixed,
                        width: 200,
                        field: 'col6',
                      ),
                      ModDataHeader(
                        child: const Text('Col 7'),
                        widthType: WidthType.fixed,
                        width: 200,
                        field: 'col7',
                      ),
                      ModDataHeader(
                        child: const Text('Col 8'),
                        widthType: WidthType.fixed,
                        width: 200,
                        field: 'col8',
                      ),
                    ],
                    data: const [
                      {
                        'col1': 'Dados 1',
                        'col2': 'Dados 2',
                        'col3': 'Dados 3',
                        'col4': 'Dados 4',
                        'col5': 'Dados 5',
                        'col6': 'Dados 6',
                        'col7': 'Dados 7',
                        'col8': 'Dados 8',
                      },
                      {
                        'col1': 'Info A',
                        'col2': 'Info B',
                        'col3': 'Info C',
                        'col4': 'Info D',
                        'col5': 'Info E',
                        'col6': 'Info F',
                        'col7': 'Info G',
                        'col8': 'Info H',
                      },
                    ],
                    source: _ScrollDemoDataSource(const [
                      {
                        'col1': 'Dados 1',
                        'col2': 'Dados 2',
                        'col3': 'Dados 3',
                        'col4': 'Dados 4',
                        'col5': 'Dados 5',
                        'col6': 'Dados 6',
                        'col7': 'Dados 7',
                        'col8': 'Dados 8',
                      },
                      {
                        'col1': 'Info A',
                        'col2': 'Info B',
                        'col3': 'Info C',
                        'col4': 'Info D',
                        'col5': 'Info E',
                        'col6': 'Info F',
                        'col7': 'Info G',
                        'col8': 'Info H',
                      },
                    ]),
                    currentPage: 0,
                    rowsPerPage: 2,
                    totalRecords: 2,
                    onPageChanged: (page) {
                      log('Page changed: $page');
                    },
                    oddRowColor:
                        Theme.of(context).colorScheme.surfaceContainerHighest,
                    evenRowColor:
                        Theme.of(context).colorScheme.surfaceContainer,
                    headerBackgroundColor:
                        Theme.of(context).colorScheme.surfaceContainer,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            const ModCodeExample(
              code: '''// DataTable com Action Bar - Dynamic Actions
ModDataTable(
  fixedHeader: true,
  showHorizontalScrollbar: true,
  columnsShow: visibleColumns,
  actionBarConfig: ModDataTableActionBarConfig(
    // Add any widgets to the actions list
    actions: [
      IconButton(
        icon: Icon(Icons.picture_as_pdf, color: Colors.red),
        tooltip: 'Export to PDF',
        onPressed: () => exportToPdf(),
      ),
      IconButton(
        icon: Icon(Icons.table_chart, color: Colors.green),
        tooltip: 'Export to Excel',
        onPressed: () => exportToExcel(),
      ),
      IconButton(
        icon: Icon(Icons.refresh),
        tooltip: 'Refresh',
        onPressed: () => refreshData(),
      ),
    ],
    // Settings button is always positioned last
    enableSettings: true,
    settingsIcon: const Icon(Icons.settings, color: Colors.blue),
    settingsTooltip: 'Configure columns',
    settingsModalTitle: 'Select visible columns',
    settingsOnChange: (selectedColumns) {
      setState(() {
        visibleColumns = selectedColumns;
      });
    },
    background: Theme.of(context).scaffoldBackgroundColor,
    borderRadius: BorderRadius.circular(8),
  ),
  headers: [...],
  data: dataList,
  source: _DataSource(dataList),
  ...
),''',
            ),
            const SizedBox(height: 20),
            ModCard(
              header: const Text(
                "DataTable with Action Bar",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Action Bar Features:",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        const Text("• PDF export button"),
                        const Text("• XLS export button"),
                        const Text(
                            "• Settings button to configure visible columns"),
                        const Text(
                            "• columnsShow parameter for column filtering"),
                        const SizedBox(height: 8),
                        Text(
                          "Visible columns: ${_visibleColumns?.join(', ') ?? 'All columns'}",
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  ModDataTable(
                    fixedHeader: true,
                    showHorizontalScrollbar: true,
                    columnsShow: _visibleColumns,
                    actionBarConfig: ModDataTableActionBarConfig(
                      actionsModColumn: [
                        ModColumn(
                          columnSizes: const {
                            ScreenSize.xs: ColumnSize.col12,
                            ScreenSize.sm: ColumnSize.col6,
                            ScreenSize.md: ColumnSize.col6,
                            ScreenSize.lg: ColumnSize.col6,
                          },
                          child: IconButton(
                            icon: const Icon(Icons.picture_as_pdf_outlined,
                                color: Colors.red, size: 20),
                            tooltip: 'Export to PDF',
                            onPressed: () async {
                              log('[ModDataTable]: PDF export clicked');
                              await Future.delayed(const Duration(seconds: 5));
                              log('[ModDataTable]: PDF export completed');
                            },
                          ),
                        ),
                        ModColumn(
                          columnSizes: const {
                            ScreenSize.xs: ColumnSize.col12,
                            ScreenSize.sm: ColumnSize.col6,
                            ScreenSize.md: ColumnSize.col6,
                            ScreenSize.lg: ColumnSize.col6,
                          },
                          child: IconButton(
                            icon: const Icon(Icons.picture_as_pdf_outlined,
                                color: Colors.red, size: 20),
                            tooltip: 'Export to PDF',
                            onPressed: () async {
                              log('[ModDataTable]: PDF export clicked');
                              await Future.delayed(const Duration(seconds: 5));
                              log('[ModDataTable]: PDF export completed');
                            },
                          ),
                        )
                      ],
                      actions: [
                        // PDF export button
                        IconButton(
                          icon: const Icon(Icons.picture_as_pdf_outlined,
                              color: Colors.red, size: 20),
                          tooltip: 'Export to PDF',
                          onPressed: () async {
                            log('[ModDataTable]: PDF export clicked');
                            await Future.delayed(const Duration(seconds: 5));
                            log('[ModDataTable]: PDF export completed');
                          },
                        ),
                        Spacer(),
                        // PDF export button
                        IconButton(
                          icon: const Icon(Icons.picture_as_pdf_outlined,
                              color: Colors.red, size: 20),
                          tooltip: 'Export to PDF',
                          onPressed: () async {
                            log('[ModDataTable]: PDF export clicked');
                            await Future.delayed(const Duration(seconds: 5));
                            log('[ModDataTable]: PDF export completed');
                          },
                        ),
                        // XLS export button
                        IconButton(
                          icon: const Icon(Icons.table_chart,
                              color: Colors.green, size: 20),
                          tooltip: 'Export to Excel',
                          onPressed: () async {
                            log('[ModDataTable]: XLS export clicked');
                            await Future.delayed(const Duration(seconds: 5));
                            log('[ModDataTable]: XLS export completed');
                          },
                        ),
                        // Custom refresh button
                        IconButton(
                          icon: const Icon(Icons.refresh, size: 20),
                          tooltip: 'Refresh data',
                          onPressed: () {
                            log('[ModDataTable]: Refresh clicked');
                          },
                        ),
                      ],
                      enableSettings: true,
                      settingsIcon: const Icon(Icons.settings,
                          color: Colors.blue, size: 20),
                      settingsTooltip: 'Configure columns',
                      settingsModalTitle: 'Selecione as colunas visiveis',
                      settingsModalConfirmText: 'Aplicar',
                      settingsModalCancelText: 'Cancelar',
                      settingsOnChange: (selectedColumns) {
                        setState(() {
                          _visibleColumns = selectedColumns;
                        });
                        log('[ModDataTable]: Selected columns: $selectedColumns');
                      },
                      background: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    headers: [
                      ModDataHeader(
                        child: const SelectableText('Name'),
                        widthType: WidthType.fixed,
                        width: 150,
                        sortable: true,
                        field: 'name',
                      ),
                      ModDataHeader(
                        child: const SelectableText('Age'),
                        widthType: WidthType.fixed,
                        width: 100,
                        sortable: true,
                        field: 'age',
                      ),
                      ModDataHeader(
                        child: const SelectableText('City'),
                        widthType: WidthType.fixed,
                        width: 150,
                        sortable: true,
                        field: 'city',
                      ),
                    ],
                    data: _sortedData.take(10).toList(),
                    source: _DataSource(_sortedData.take(10).toList()),
                    currentPage: 0,
                    rowsPerPage: 10,
                    totalRecords: 10,
                    onPageChanged: (page) {
                      log('[ModDataTable]: Page changed: $page');
                    },
                    onSort: (field, direction) {
                      log('[ModDataTable]: Sorting by $field in $direction direction');
                    },
                    rowHeight: 35,
                    oddRowColor:
                        Theme.of(context).colorScheme.surfaceContainerHighest,
                    evenRowColor:
                        Theme.of(context).colorScheme.surfaceContainer,
                    headerBackgroundColor:
                        Theme.of(context).colorScheme.surfaceContainer,
                    footerBackgroundColor:
                        Theme.of(context).colorScheme.surface,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ModCard(
              header: const Text(
                "DataTable with EmptyView Widget",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "EmptyView Features:",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        const Text("• Custom widget shown when data is empty"),
                        const Text("• Action bar remains visible when empty"),
                        const Text("• Click the trash icon to clear data and see the empty view"),
                        const Text("• Click the refresh icon to restore data"),
                        const SizedBox(height: 8),
                        Text(
                          "Current items: ${_emptyViewExampleData.length}",
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ModDataTable(
                    fixedHeader: true,
                    showHorizontalScrollbar: true,
                    emptyViewWidget: Container(
                      padding: const EdgeInsets.all(48),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.inbox_outlined,
                              size: 64,
                              color: Theme.of(context).colorScheme.outline,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No data available',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: Theme.of(context).colorScheme.outline,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Click the refresh button to reload the data',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Theme.of(context).colorScheme.outline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    actionBarConfig: ModDataTableActionBarConfig(
                      actions: [
                        // Clear data button (trash icon)
                        IconButton(
                          icon: Icon(
                            Icons.delete_outline,
                            color: Colors.red.shade400,
                            size: 20,
                          ),
                          tooltip: 'Clear all data',
                          onPressed: () {
                            setState(() {
                              _emptyViewExampleData = [];
                            });
                            log('[EmptyView Example]: Data cleared');
                          },
                        ),
                        // Restore data button (refresh icon)
                        IconButton(
                          icon: Icon(
                            Icons.refresh,
                            color: Colors.green.shade400,
                            size: 20,
                          ),
                          tooltip: 'Restore data',
                          onPressed: () {
                            setState(() {
                              _emptyViewExampleData = [
                                {'id': 1, 'product': 'Laptop', 'price': 1299.99, 'stock': 15},
                                {'id': 2, 'product': 'Mouse', 'price': 29.99, 'stock': 150},
                                {'id': 3, 'product': 'Keyboard', 'price': 79.99, 'stock': 85},
                                {'id': 4, 'product': 'Monitor', 'price': 349.99, 'stock': 30},
                                {'id': 5, 'product': 'Headset', 'price': 99.99, 'stock': 60},
                              ];
                            });
                            log('[EmptyView Example]: Data restored');
                          },
                        ),
                      ],
                      background: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    headers: [
                      ModDataHeader(
                        child: const SelectableText('ID'),
                        widthType: WidthType.fixed,
                        width: 80,
                        sortable: true,
                        field: 'id',
                      ),
                      ModDataHeader(
                        child: const SelectableText('Product'),
                        widthType: WidthType.fixed,
                        width: 200,
                        sortable: true,
                        field: 'product',
                      ),
                      ModDataHeader(
                        child: const SelectableText('Price'),
                        widthType: WidthType.fixed,
                        width: 120,
                        sortable: true,
                        field: 'price',
                      ),
                      ModDataHeader(
                        child: const SelectableText('Stock'),
                        widthType: WidthType.fixed,
                        width: 100,
                        sortable: true,
                        field: 'stock',
                      ),
                    ],
                    data: _emptyViewExampleData,
                    source: _EmptyViewDataSource(_emptyViewExampleData),
                    currentPage: 0,
                    rowsPerPage: 5,
                    totalRecords: _emptyViewExampleData.length,
                    onPageChanged: (page) {
                      log('[EmptyView Example]: Page changed: $page');
                    },
                    onSort: (field, direction) {
                      log('[EmptyView Example]: Sorting by $field in $direction direction');
                    },
                    rowHeight: 40,
                    oddRowColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                    evenRowColor: Theme.of(context).colorScheme.surfaceContainer,
                    headerBackgroundColor: Theme.of(context).colorScheme.surfaceContainer,
                    footerBackgroundColor: Theme.of(context).colorScheme.surface,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            const ModCodeExample(
              code: '''// DataTable with EmptyView Widget
ModDataTable(
  // Custom widget displayed when data is empty
  emptyViewWidget: Container(
    padding: const EdgeInsets.all(48),
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox_outlined, size: 64),
          const SizedBox(height: 16),
          Text('No data available'),
          const SizedBox(height: 8),
          Text('Click refresh to reload'),
        ],
      ),
    ),
  ),
  // Action bar with clear/restore buttons
  actionBarConfig: ModDataTableActionBarConfig(
    actions: [
      IconButton(
        icon: Icon(Icons.delete_outline, color: Colors.red),
        tooltip: 'Clear all data',
        onPressed: () {
          setState(() {
            _data = [];  // Triggers emptyViewWidget display
          });
        },
      ),
      IconButton(
        icon: Icon(Icons.refresh, color: Colors.green),
        tooltip: 'Restore data',
        onPressed: () {
          setState(() {
            _data = originalData;  // Restores data
          });
        },
      ),
    ],
  ),
  headers: [...],
  data: _data,
  source: _DataSource(_data),
  ...
),''',
            ),
            const SizedBox(height: 8),
            const ModCodeExample(
              code: '''// DataTable Modal
ModDataTableModal.show<Map<String, dynamic>, void>(
  context: context,
  header: const Text('Employee Data'),
  size: ModModalSize.lg,
  height: ModModalHeight.auto,
  maxHeight: MediaQuery.of(context).size.height * 0.8,
  modalHeaderColor: Theme.of(context).colorScheme.surfaceContainerHighest,
  headers: [
    ModDataHeader(
      child: const SelectableText('Name'),
      widthType: WidthType.fixed,
      width: 200,
      sortable: true,
      field: 'name',
    ),
    // ... more headers
  ],
  data: employeeData,
  source: _DataSource(employeeData),
  currentPage: 0,
  rowsPerPage: 5,
  totalRecords: employeeData.length,
  fixedHeader: true,
  showHorizontalScrollbar: true,
  footerConfig: ModDataTableModalFooterConfig(
    showCloseButton: true,
    closeButtonText: 'Close',
    buttons: [
      ElevatedButton(
        onPressed: () { /* action */ },
        child: const Text('Export Selected'),
      ),
    ],
  ),
  onClose: () {
    log('Modal closed');
  },
);''',
            ),
            const SizedBox(height: 20),
            ModCard(
              header: const Text(
                "DataTable Modal Example",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "DataTableModal Features:",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        const Text("• Combines ModDataTable with ModModal"),
                        const Text(
                            "• Pagination controls positioned on the left of the footer"),
                        const Text(
                            "• Action buttons positioned on the right of the footer"),
                        const Text(
                            "• Supports all ModDataTable features (sorting, column resize, etc.)"),
                        const Text(
                            "• Configurable modal size, position, and appearance"),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton.icon(
                      onPressed: () => _showDataTableModal(context),
                      icon: const Icon(Icons.table_chart),
                      label: const Text('Open DataTable Modal'),
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

  void _showDataTableModal(BuildContext context) {
    ModDataTableModal.show<Map<String, dynamic>, void>(
      context: context,
      // Modal properties
      header: const Text(
        'Employee Data',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      size: ModModalSize.lg,
      height: ModModalHeight.auto,
      maxHeight: MediaQuery.of(context).size.height * 0.8,
      modalHeaderColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      modalBodyColor: Theme.of(context).colorScheme.surface,
      modalFooterColor: Theme.of(context).colorScheme.surfaceContainerHighest,

      // DataTable properties
      headers: [
        ModDataHeader(
          child: const SelectableText('Name'),
          widthType: WidthType.fixed,
          width: 200,
          sortable: true,
          field: 'name',
        ),
        ModDataHeader(
          child: const SelectableText('Age'),
          widthType: WidthType.fixed,
          width: 100,
          sortable: true,
          field: 'age',
        ),
        ModDataHeader(
          child: const SelectableText('City'),
          widthType: WidthType.fixed,
          width: 200,
          sortable: true,
          field: 'city',
        ),
      ],
      // Pass ALL data - the modal handles pagination internally
      data: _data,
      source: _DataSource(_data),
      currentPage: 0,
      rowsPerPage: 5,
      totalRecords: _data.length,
      onPageChanged: (page) {
        log('[DataTableModal]: Page changed to $page');
      },
      onRowsPerPageChanged: (rows) {
        log('[DataTableModal]: Rows per page changed to $rows');
      },
      onSort: (field, direction) {
        log('[DataTableModal]: Sorting by $field in $direction direction');
      },
      rowHeight: 40,
      fixedHeader: true,
      showHorizontalScrollbar: true,
      oddRowColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      evenRowColor: Theme.of(context).colorScheme.surfaceContainer,
      headerBackgroundColor: Theme.of(context).colorScheme.surfaceContainer,
      paginationText: 'of',
      rowsPerPageText: 'Rows',
      availableRowsPerPage: const [5, 10, 15, 20],
      // Action bar configuration with dynamic actions
      actionBarConfig: ModDataTableActionBarConfig(
        actions: [
          // PDF export button
          IconButton(
            icon: const Icon(Icons.picture_as_pdf, color: Colors.red, size: 20),
            tooltip: 'Export to PDF',
            onPressed: () {
              log('[DataTableModal]: PDF export clicked');
            },
          ),
          // XLS export button
          IconButton(
            icon: const Icon(Icons.table_chart, color: Colors.green, size: 20),
            tooltip: 'Export to Excel',
            onPressed: () {
              log('[DataTableModal]: XLS export clicked');
            },
          ),
        ],
        enableSettings: true,
        settingsOnChange: (columns) {
          log('[DataTableModal]: Settings changed - visible columns: $columns');
        },
        background: Theme.of(context).colorScheme.surface,
      ),
      // Footer configuration
      footerConfig: ModDataTableModalFooterConfig(
        showCloseButton: true,
        closeButtonText: 'Close',
        buttons: [
          ElevatedButton(
            onPressed: () {
              log('[DataTableModal]: Custom action button clicked');
            },
            child: const Text('Export Selected'),
          ),
        ],
      ),
      onClose: () {
        log('[DataTableModal]: Modal closed');
      },
    );
  }
}

class _DataSource extends DataTableSource {
  final List<Map<String, dynamic>> _data;

  _DataSource(this._data);

  @override
  DataRow getRow(int index) {
    return DataRow(
      cells: [
        DataCell(SelectableText(_data[index]['name'].toString())),
        DataCell(SelectableText(_data[index]['age'].toString())),
        DataCell(SelectableText(_data[index]['city'].toString())),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _data.length;

  @override
  int get selectedRowCount => 0;
}

class _WideDataSource extends DataTableSource {
  final List<Map<String, dynamic>> _data;

  _WideDataSource(this._data);

  @override
  DataRow getRow(int index) {
    final row = _data[index];
    return DataRow(
      cells: [
        DataCell(SelectableText(row['id']?.toString() ?? '')),
        DataCell(SelectableText(row['name']?.toString() ?? '')),
        DataCell(SelectableText(row['department']?.toString() ?? '')),
        DataCell(SelectableText(row['position']?.toString() ?? '')),
        DataCell(SelectableText(row['salary']?.toString() ?? '')),
        DataCell(SelectableText(row['startDate']?.toString() ?? '')),
        DataCell(SelectableText(row['location']?.toString() ?? '')),
        DataCell(SelectableText(row['email']?.toString() ?? '')),
        DataCell(SelectableText(row['phone']?.toString() ?? '')),
        DataCell(SelectableText(row['status']?.toString() ?? '')),
        DataCell(SelectableText(row['projects']?.toString() ?? '')),
        DataCell(SelectableText(row['performance']?.toString() ?? '')),
        DataCell(SelectableText(row['training']?.toString() ?? '')),
        DataCell(SelectableText(row['certifications']?.toString() ?? '')),
        DataCell(SelectableText(row['notes']?.toString() ?? '')),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _data.length;

  @override
  int get selectedRowCount => 0;
}

class _ScrollDemoDataSource extends DataTableSource {
  final List<Map<String, dynamic>> _data;

  _ScrollDemoDataSource(this._data);

  @override
  DataRow getRow(int index) {
    final row = _data[index];
    return DataRow(
      cells: [
        DataCell(Text(row['col1']?.toString() ?? '')),
        DataCell(Text(row['col2']?.toString() ?? '')),
        DataCell(Text(row['col3']?.toString() ?? '')),
        DataCell(Text(row['col4']?.toString() ?? '')),
        DataCell(Text(row['col5']?.toString() ?? '')),
        DataCell(Text(row['col6']?.toString() ?? '')),
        DataCell(Text(row['col7']?.toString() ?? '')),
        DataCell(Text(row['col8']?.toString() ?? '')),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _data.length;

  @override
  int get selectedRowCount => 0;
}

class _DynamicDataSource extends DataTableSource {
  final List<Map<String, dynamic>> _data;
  final int _columnCount;

  _DynamicDataSource(this._data, this._columnCount);

  @override
  DataRow getRow(int index) {
    if (index >= _data.length) return const DataRow(cells: []);
    final row = _data[index];
    return DataRow(
      cells: List.generate(_columnCount, (col) =>
        DataCell(Text(row['col_$col']?.toString() ?? '')),
      ),
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _data.length;

  @override
  int get selectedRowCount => 0;
}

class _EmptyViewDataSource extends DataTableSource {
  final List<Map<String, dynamic>> _data;

  _EmptyViewDataSource(this._data);

  @override
  DataRow getRow(int index) {
    if (index >= _data.length) {
      return const DataRow(cells: []);
    }
    final row = _data[index];
    return DataRow(
      cells: [
        DataCell(SelectableText(row['id']?.toString() ?? '')),
        DataCell(SelectableText(row['product']?.toString() ?? '')),
        DataCell(SelectableText('\$${row['price']?.toStringAsFixed(2) ?? '0.00'}')),
        DataCell(SelectableText(row['stock']?.toString() ?? '')),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _data.length;

  @override
  int get selectedRowCount => 0;
}
