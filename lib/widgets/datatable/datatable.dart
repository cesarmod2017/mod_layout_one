import 'dart:math';

import 'package:flutter/material.dart';

enum BorderStyle { none, topBottom, topLeftRightBottom }

enum WidthType { percentage, fixed }

enum SortDirection { asc, desc, none }

class ModDataHeader {
  final Widget child;
  final WidthType widthType;
  final double width;
  final bool sortable;
  final String field;

  ModDataHeader({
    required this.child,
    this.widthType = WidthType.fixed,
    required this.width,
    this.sortable = false,
    required this.field,
  });
}

class ModDataTable<T> extends StatefulWidget {
  final List<ModDataHeader> headers;
  final List<T> data;
  final DataTableSource source;
  final BorderStyle borderStyle;
  final int rowsPerPage;
  final Color? oddRowColor;
  final Color? evenRowColor;
  final Color? headerColor;
  final String paginationText;
  final String rowsPerPageText;
  final Function(int page) onPageChanged;
  final Function(String field, SortDirection direction)? onSort;
  final int totalRecords;
  final int currentPage;
  final Color? paginationBackgroundColor;
  final Function(int rowsPerPage)? onRowsPerPageChanged;
  final List<int> availableRowsPerPage;
  final double? paginationBorderRadius;
  final String? currentSortField;
  final SortDirection currentSortDirection;
  final double rowHeight;
  final bool fixedHeader;
  final bool enableSimplePagination;

  const ModDataTable({
    super.key,
    required this.headers,
    required this.data,
    required this.source,
    this.borderStyle = BorderStyle.none,
    required this.rowsPerPage,
    this.oddRowColor,
    this.evenRowColor,
    this.headerColor,
    this.paginationText = 'of',
    this.rowsPerPageText = 'Rows per page',
    required this.onPageChanged,
    this.onSort,
    required this.totalRecords,
    required this.currentPage,
    this.paginationBackgroundColor,
    this.onRowsPerPageChanged,
    this.availableRowsPerPage = const [5, 10, 15, 20, 50, 100, 200],
    this.paginationBorderRadius = 5,
    this.currentSortField,
    this.currentSortDirection = SortDirection.none,
    this.rowHeight = 35.0,
    this.fixedHeader = false,
    this.enableSimplePagination = false,
  });

  @override
  State<ModDataTable<T>> createState() => _ModDataTableState<T>();
}

class _ModDataTableState<T> extends State<ModDataTable<T>> {
  late String? _sortField;
  late SortDirection _sortDirection;
  final ScrollController _headerScrollController = ScrollController();
  final ScrollController _bodyScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _sortField = widget.currentSortField;
    _sortDirection = widget.currentSortDirection;

    // Synchronize the scroll of header and body
    _headerScrollController.addListener(() {
      if (_bodyScrollController.hasClients) {
        _bodyScrollController.jumpTo(_headerScrollController.offset);
      }
    });
    _bodyScrollController.addListener(() {
      if (_headerScrollController.hasClients) {
        _headerScrollController.jumpTo(_bodyScrollController.offset);
      }
    });
  }

  @override
  void dispose() {
    _headerScrollController.dispose();
    _bodyScrollController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(ModDataTable<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentSortField != widget.currentSortField ||
        oldWidget.currentSortDirection != widget.currentSortDirection) {
      _sortField = widget.currentSortField;
      _sortDirection = widget.currentSortDirection;
    }
  }

  @override
  Widget build(BuildContext context) {
    const headerHeight = 40.0;
    const paginationHeight = 56.0;
    final totalHeight =
        (widget.rowHeight * min(widget.rowsPerPage, widget.source.rowCount)) +
            headerHeight +
            paginationHeight +
            25;

    return SizedBox(
      height: totalHeight,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final screenWidth = constraints.maxWidth;
          double totalFixedWidth = 0;
          double totalPercentage = 0;

          for (var header in widget.headers) {
            if (header.widthType == WidthType.fixed) {
              totalFixedWidth += header.width;
            } else {
              totalPercentage += header.width;
            }
          }

          final remainingWidth = max(0.0, screenWidth - totalFixedWidth);
          final columnWidths = widget.headers.map((header) {
            return header.widthType == WidthType.fixed
                ? header.width
                : remainingWidth * (header.width / totalPercentage);
          }).toList();

          final totalWidth =
              columnWidths.fold(0.0, (sum, width) => sum + width);
          final visibleData = widget.data
              .take(min(widget.rowsPerPage, widget.source.rowCount))
              .toList();

          return Column(
            children: [
              if (widget.fixedHeader)
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  controller: _headerScrollController,
                  child: SizedBox(
                    width: max(totalWidth, screenWidth),
                    child: _buildHeader(columnWidths),
                  ),
                ),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    controller: _bodyScrollController,
                    child: SizedBox(
                      width: max(totalWidth, screenWidth),
                      child: Column(
                        children: [
                          if (!widget.fixedHeader) _buildHeader(columnWidths),
                          _buildRows(visibleData, columnWidths),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              _buildPagination(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeader(List<double> columnWidths) {
    return Container(
      color: widget.headerColor,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(widget.headers.length, (index) {
          final header = widget.headers[index];
          final width = columnWidths[index];

          return InkWell(
            onTap: header.sortable
                ? () {
                    if (_sortField != header.field) {
                      _sortDirection = SortDirection.asc;
                    } else {
                      _sortDirection = _sortDirection == SortDirection.asc
                          ? SortDirection.desc
                          : SortDirection.asc;
                    }
                    _sortField = header.field;
                    widget.onSort?.call(_sortField!, _sortDirection);
                    setState(() {});
                  }
                : null,
            child: Container(
              width: width,
              decoration: _getBorderDecoration(),
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Expanded(child: header.child),
                  if (header.sortable && _sortField == header.field)
                    Icon(
                      _sortDirection == SortDirection.asc
                          ? Icons.arrow_upward
                          : Icons.arrow_downward,
                      size: 16,
                    ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildRows(List<T> visibleData, List<double> columnWidths) {
    return Column(
      children: List.generate(visibleData.length, (index) {
        final row = widget.source.getRow(index);
        return Container(
          color: index % 2 == 0 ? widget.evenRowColor : widget.oddRowColor,
          child: Row(
            children: List.generate(widget.headers.length, (cellIndex) {
              return Container(
                width: columnWidths[cellIndex],
                decoration: _getBorderDecoration(),
                padding: const EdgeInsets.all(8),
                child: row?.cells[cellIndex].child ?? const SizedBox(),
              );
            }),
          ),
        );
      }),
    );
  }

  Widget _buildPagination() {
    final totalPages = (widget.totalRecords / widget.rowsPerPage).ceil();
    final currentStart = (widget.currentPage * widget.rowsPerPage) + 1;
    final currentEnd =
        min((widget.currentPage + 1) * widget.rowsPerPage, widget.totalRecords);
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 600;

    return Container(
      decoration: BoxDecoration(
        color: widget.paginationBackgroundColor,
        borderRadius: BorderRadius.circular(widget.paginationBorderRadius ?? 0),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (widget.onRowsPerPageChanged != null)
            Flexible(child: _buildRowsPerPage(isMobile)),
          Flexible(
            flex: 2,
            child: _buildPageNavigation(
                totalPages, currentStart, currentEnd, isMobile),
          ),
        ],
      ),
    );
  }

  Widget _buildRowsPerPage(bool isMobile) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (!isMobile)
          Flexible(
            child: Text(
              widget.rowsPerPageText,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        if (!isMobile) const SizedBox(width: 8),
        DropdownButton<int>(
          value: widget.rowsPerPage,
          items: widget.availableRowsPerPage
              .map((value) => DropdownMenuItem<int>(
                    value: value,
                    child: Text(value.toString()),
                  ))
              .toList(),
          onChanged: (value) {
            if (value != null) {
              widget.onRowsPerPageChanged?.call(value);
            }
          },
        ),
      ],
    );
  }

  Widget _buildPageNavigation(
      int totalPages, int currentStart, int currentEnd, bool isMobile) {
    final pageNumbers = _generatePageNumbers(totalPages);

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (!isMobile &&
            !(widget.enableSimplePagination && widget.totalRecords == 0))
          Flexible(
            child: Text(
              '$currentStart-$currentEnd ${widget.paginationText} ${widget.totalRecords}',
              overflow: TextOverflow.ellipsis,
            ),
          ),
        IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: widget.currentPage > 0
              ? () => widget.onPageChanged(widget.currentPage - 1)
              : null,
        ),
        if (widget.enableSimplePagination && widget.totalRecords == 0)
          Text('${widget.currentPage + 1}')
        else if (isMobile)
          Text('${widget.currentPage + 1} / $totalPages')
        else
          ...pageNumbers.map((pageNum) => SizedBox(
                width: 40,
                child: TextButton(
                  onPressed: () => widget.onPageChanged(pageNum - 1),
                  child: Text(
                    pageNum.toString(),
                    style: TextStyle(
                      fontWeight: pageNum == widget.currentPage + 1
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ),
              )),
        IconButton(
          icon: const Icon(Icons.chevron_right),
          onPressed: currentEnd < widget.totalRecords ||
                  (widget.enableSimplePagination && widget.totalRecords == 0)
              ? () => widget.onPageChanged(widget.currentPage + 1)
              : null,
        ),
      ],
    );
  }

  List<int> _generatePageNumbers(int totalPages) {
    const maxVisiblePages = 5;
    final currentPage = widget.currentPage + 1;
    final width = MediaQuery.of(context).size.width;
    final visiblePages = width < 960 ? 3 : maxVisiblePages;

    if (totalPages <= visiblePages) {
      return List.generate(totalPages, (i) => i + 1);
    }

    var start = currentPage - (visiblePages ~/ 2);
    var end = currentPage + (visiblePages ~/ 2);

    if (start < 1) {
      start = 1;
      end = visiblePages;
    }

    if (end > totalPages) {
      end = totalPages;
      start = totalPages - visiblePages + 1;
    }

    return List.generate(end - start + 1, (i) => start + i);
  }

  BoxDecoration _getBorderDecoration() {
    switch (widget.borderStyle) {
      case BorderStyle.none:
        return const BoxDecoration();
      case BorderStyle.topBottom:
        return BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.grey.shade300),
            bottom: BorderSide(color: Colors.grey.shade300),
          ),
        );
      case BorderStyle.topLeftRightBottom:
        return BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
        );
    }
  }
}
