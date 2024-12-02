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
  bool _sortAscending = true;
  int _sortColumnIndex = 0;
  int _rowsPerPage = 3;

  final List<Map<String, dynamic>> _data = [
    {'name': 'John Doe', 'age': 30, 'city': 'New York'},
    {'name': 'Jane Smith', 'age': 25, 'city': 'Los Angeles'},
    {'name': 'Bob Johnson', 'age': 35, 'city': 'Chicago'},
    {'name': 'Alice Brown', 'age': 28, 'city': 'Houston'},
    {'name': 'Charlie Wilson', 'age': 42, 'city': 'Phoenix'},
    {'name': 'David Lee', 'age': 33, 'city': 'Boston'},
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
            ModCard(
              header: const Text(
                "Basic DataTable with Sorting",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: DataTable(
                sortColumnIndex: _sortColumnIndex,
                sortAscending: _sortAscending,
                columns: [
                  DataColumn(
                    label: const Text('Name'),
                    onSort: (columnIndex, ascending) {
                      setState(() {
                        _sortColumnIndex = columnIndex;
                        _sortAscending = ascending;
                      });
                    },
                  ),
                  DataColumn(
                    label: const Text('Age'),
                    numeric: true,
                    onSort: (columnIndex, ascending) {
                      setState(() {
                        _sortColumnIndex = columnIndex;
                        _sortAscending = ascending;
                      });
                    },
                  ),
                  DataColumn(
                    label: const Text('City'),
                    onSort: (columnIndex, ascending) {
                      setState(() {
                        _sortColumnIndex = columnIndex;
                        _sortAscending = ascending;
                      });
                    },
                  ),
                ],
                rows: _sortedData.map((item) {
                  return DataRow(
                    cells: [
                      DataCell(Text(item['name'].toString())),
                      DataCell(Text(item['age'].toString())),
                      DataCell(Text(item['city'].toString())),
                    ],
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),

            // Styled DataTable with pagination
            ModCard(
              header: const Text(
                "Styled DataTable with Pagination",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Theme(
                data: Theme.of(context).copyWith(
                  dataTableTheme: DataTableThemeData(
                    // headingRowColor:
                    //     WidgetStateProperty.all(Colors.blue.shade50),
                    dataRowColor: WidgetStateProperty.resolveWith((states) {
                      if (states.contains(WidgetState.selected)) {
                        return Colors.grey.shade200;
                      }
                      return null;
                    }),
                    headingTextStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      // color: Colors.blue.shade900,
                    ),
                    dividerThickness: 2,
                  ),
                ),
                child: PaginatedDataTable(
                  availableRowsPerPage: const [3, 5, 10, 15, 25],
                  source: _DataSource(_sortedData),
                  header: const Text('Employees'),
                  sortColumnIndex: _sortColumnIndex,
                  sortAscending: _sortAscending,
                  columns: [
                    DataColumn(
                      label: const Text('Name'),
                      onSort: (columnIndex, ascending) {
                        setState(() {
                          _sortColumnIndex = columnIndex;
                          _sortAscending = ascending;
                        });
                      },
                    ),
                    DataColumn(
                      label: const Text('Age'),
                      numeric: true,
                      onSort: (columnIndex, ascending) {
                        setState(() {
                          _sortColumnIndex = columnIndex;
                          _sortAscending = ascending;
                        });
                      },
                    ),
                    DataColumn(
                      label: const Text('City'),
                      onSort: (columnIndex, ascending) {
                        setState(() {
                          _sortColumnIndex = columnIndex;
                          _sortAscending = ascending;
                        });
                      },
                    ),
                  ],
                  rowsPerPage: _rowsPerPage,
                  onRowsPerPageChanged: (value) {
                    setState(() {
                      _rowsPerPage = value!;
                    });
                  },
                  showCheckboxColumn: false,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Compact DataTable with selection
            ModCard(
              header: const Text(
                "Compact DataTable with Selection",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: DataTable(
                dataRowHeight: 40,
                headingRowHeight: 40,
                horizontalMargin: 12,
                columnSpacing: 24,
                showCheckboxColumn: true,
                columns: const [
                  DataColumn(label: Text('Name')),
                  DataColumn(label: Text('Age'), numeric: true),
                  DataColumn(label: Text('City')),
                ],
                rows: _sortedData.map((item) {
                  return DataRow(
                    selected: false,
                    onSelectChanged: (selected) {
                      // Handle selection
                    },
                    cells: [
                      DataCell(Text(item['name'].toString())),
                      DataCell(Text(item['age'].toString())),
                      DataCell(Text(item['city'].toString())),
                    ],
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 20),

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
                    width: 150,
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
                rowsPerPage: 5,
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
