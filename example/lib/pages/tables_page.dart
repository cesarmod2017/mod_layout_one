import 'dart:developer';

import 'package:example/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mod_layout_one/mod_layout_one.dart';

class TablesPage extends StatefulWidget {
  const TablesPage({super.key});

  @override
  State<TablesPage> createState() => _TablesPageState();
}

class _TablesPageState extends State<TablesPage> {
  final bool _sortAscending = true;
  final int _sortColumnIndex = 0;
  final int _rowsPerPage = 5;

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
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Basic DataTable with sorting

            // Styled DataTable with pagination

            ModCard(
              header: const Text(
                "Custom ModDataTable Example",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: ModDataTable(
                paginationBorderRadius: 50,
                fixedHeader: true,
                onColumnWidthChanged: (field, width) {
                  log('Column width changed: $field to $width');
                },
                enableColumnResize: true,
                headers: [
                  ModDataHeader(
                    child: SelectableText(
                      'Name',
                      style: Theme.of(Get.context!).textTheme.titleSmall,
                    ),
                    widthType: WidthType.fixed,
                    width: 150,
                    sortable: true,
                    field: 'name', // Adicione o campo correspondente
                  ),
                  ModDataHeader(
                    child: SelectableText(
                      'Age',
                      style: Theme.of(Get.context!).textTheme.titleSmall,
                    ),
                    widthType: WidthType.fixed,
                    width: 950,
                    sortable: true,
                    field: 'age', // Adicione o campo correspondente
                  ),
                  ModDataHeader(
                    child: const SelectableText('City'),
                    widthType: WidthType.fixed,
                    width: 150,
                    sortable: true,
                    field: 'city', // Adicione o campo correspondente
                  ),
                ],
                data: _sortedData,
                source: _DataSource(_sortedData),
                currentPage: 0,
                rowsPerPage: 20,
                totalRecords: _sortedData.length,
                oddRowColor:
                    Theme.of(context).colorScheme.surfaceContainerHighest,
                evenRowColor: Theme.of(context).colorScheme.surfaceContainer,
                onPageChanged: (page) {
                  // Handle page change
                  log('Page changed: $page');
                },
                onSort: (field, direction) {
                  // Handle sorting
                  log('Sorting by $field in $direction direction');
                },
                rowHeight: 10,
                paginationText: 'of', // Adicione se necessário
                rowsPerPageText: 'Linhas por página',
                paginationBackgroundColor:
                    Theme.of(context).colorScheme.surface,
                headerColor: Theme.of(context).colorScheme.surface,
                onRowsPerPageChanged: (rowsPerPage) {
                  // Handle rows per page change
                  log('Rows per page changed: $rowsPerPage');
                },
                availableRowsPerPage: const [
                  5,
                  10,
                  15,
                  20,
                  50,
                  100,
                  200
                ], // Adicione se necessário
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
                    width: 150,
                    sortable: true,
                    field: 'projects',
                  ),
                  ModDataHeader(
                    child: const SelectableText('Performance'),
                    widthType: WidthType.fixed,
                    width: 120,
                    sortable: true,
                    field: 'performance',
                  ),
                  ModDataHeader(
                    child: const SelectableText('Training'),
                    widthType: WidthType.fixed,
                    width: 150,
                    sortable: true,
                    field: 'training',
                  ),
                  ModDataHeader(
                    child: const SelectableText('Certifications'),
                    widthType: WidthType.fixed,
                    width: 200,
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
                rowsPerPage: 1,
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
                rowHeight: 40,
                paginationText: 'of',
                rowsPerPageText: 'Rows per page',
                paginationBackgroundColor:
                    Theme.of(context).colorScheme.surface,
                headerColor: Theme.of(context).colorScheme.surface,
                onRowsPerPageChanged: (rowsPerPage) {
                  log('Rows per page changed: $rowsPerPage');
                },
                availableRowsPerPage: const [1, 5, 10, 15, 20],
              ),
            ),
          ],
        ),
      ),
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
