import 'dart:math';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart' hide BorderStyle;
import 'package:get/get.dart';
import 'package:mod_layout_one/widgets/buttons/icon_buttom.dart';
import 'package:mod_layout_one/widgets/grid_system/grid_system.dart';
import 'package:mod_layout_one/widgets/modal/modal.dart';

import 'datatable.dart';

/// Configuration class for the DataTableModal footer buttons
class ModDataTableModalFooterConfig {
  /// List of custom buttons to display in the footer (right side)
  final List<Widget> buttons;

  /// Whether to show the close button
  final bool showCloseButton;

  /// Close button text
  final String closeButtonText;

  /// Close button style
  final ButtonStyle? closeButtonStyle;

  const ModDataTableModalFooterConfig({
    this.buttons = const [],
    this.showCloseButton = true,
    this.closeButtonText = 'Close',
    this.closeButtonStyle,
  });
}

/// A widget that displays a ModDataTable inside a ModModal with pagination in the footer.
///
/// The footer is organized with pagination controls on the left and action buttons on the right.
class ModDataTableModal<T> extends StatefulWidget {
  // DataTable properties
  final List<ModDataHeader> headers;
  final List<T> data;
  final DataTableSource source;
  final BorderStyle borderStyle;
  final int rowsPerPage;
  final Color? oddRowColor;
  final Color? evenRowColor;
  final Color? headerBackgroundColor;
  final Color? footerBackgroundColor;

  /// Cor de fundo quando o mouse está sobre a linha (hover).
  /// Se não informado, usa a cor padrão do tema (hoverColor).
  /// O efeito hover é ativado apenas em plataformas Windows e Web.
  final Color? hoverColor;

  final String paginationText;
  final String rowsPerPageText;
  final Function(int page) onPageChanged;
  final Function(String field, SortDirection direction)? onSort;
  final int totalRecords;
  final int currentPage;
  final Function(int rowsPerPage)? onRowsPerPageChanged;
  final List<int> availableRowsPerPage;
  final double? paginationBorderRadius;
  final String? currentSortField;
  final SortDirection currentSortDirection;
  final double rowHeight;
  final bool fixedHeader;
  final bool enableSimplePagination;
  final Function(String field, double newWidth)? onColumnWidthChanged;
  final bool enableColumnResize;
  final bool showHorizontalScrollbar;
  final ModDataTableActionBarConfig? actionBarConfig;
  final List<String>? columnsShow;

  /// Widget to display when the data list is empty.
  /// When provided and data is empty, this widget will be shown instead of the header and body,
  /// but the action bar will remain visible.
  final Widget? emptyViewWidget;

  // Modal properties
  final Widget header;
  final Color? modalHeaderColor;
  final Color? modalBodyColor;
  final Color? modalFooterColor;
  final ModModalPosition position;
  final ModModalSize size;
  final ModModalHeight height;
  final bool fullScreen;
  final double borderRadius;
  final bool barrierDismissible;
  final VoidCallback? onClose;
  final double? maxWidth;
  final double? minWidth;
  final double? maxHeight;
  final double? minHeight;
  final EdgeInsets? bodyPadding;

  /// Configuration for footer buttons
  final ModDataTableModalFooterConfig footerConfig;

  const ModDataTableModal({
    super.key,
    // DataTable required properties
    required this.headers,
    required this.data,
    required this.source,
    required this.onPageChanged,
    required this.totalRecords,
    required this.currentPage,
    required this.rowsPerPage,
    // DataTable optional properties
    this.borderStyle = BorderStyle.none,
    this.oddRowColor,
    this.evenRowColor,
    this.headerBackgroundColor,
    this.footerBackgroundColor,
    this.hoverColor,
    this.paginationText = 'of',
    this.rowsPerPageText = 'Rows per page',
    this.onSort,
    this.onRowsPerPageChanged,
    this.availableRowsPerPage = const [5, 10, 15, 20, 50, 100, 200],
    this.paginationBorderRadius = 5,
    this.currentSortField,
    this.currentSortDirection = SortDirection.none,
    this.rowHeight = 35.0,
    this.fixedHeader = false,
    this.enableSimplePagination = false,
    this.onColumnWidthChanged,
    this.enableColumnResize = false,
    this.showHorizontalScrollbar = true,
    this.actionBarConfig,
    this.columnsShow,
    this.emptyViewWidget,
    // Modal required properties
    required this.header,
    // Modal optional properties
    this.modalHeaderColor,
    this.modalBodyColor,
    this.modalFooterColor,
    this.position = ModModalPosition.center,
    this.size = ModModalSize.lg,
    this.height = ModModalHeight.auto,
    this.fullScreen = false,
    this.borderRadius = 8.0,
    this.barrierDismissible = true,
    this.onClose,
    this.maxWidth,
    this.minWidth,
    this.maxHeight,
    this.minHeight,
    this.bodyPadding,
    this.footerConfig = const ModDataTableModalFooterConfig(),
  });

  @override
  State<ModDataTableModal<T>> createState() => _ModDataTableModalState<T>();

  /// Shows the DataTableModal as a dialog
  static Future<R?> show<T, R>({
    required BuildContext context,
    // DataTable required properties
    required List<ModDataHeader> headers,
    required List<T> data,
    required DataTableSource source,
    required Function(int page) onPageChanged,
    required int totalRecords,
    required int currentPage,
    required int rowsPerPage,
    // DataTable optional properties
    BorderStyle borderStyle = BorderStyle.none,
    Color? oddRowColor,
    Color? evenRowColor,
    Color? headerBackgroundColor,
    Color? footerBackgroundColor,
    Color? hoverColor,
    String paginationText = 'of',
    String rowsPerPageText = 'Rows per page',
    Function(String field, SortDirection direction)? onSort,
    Function(int rowsPerPage)? onRowsPerPageChanged,
    List<int> availableRowsPerPage = const [5, 10, 15, 20, 50, 100, 200],
    double? paginationBorderRadius = 5,
    String? currentSortField,
    SortDirection currentSortDirection = SortDirection.none,
    double rowHeight = 35.0,
    bool fixedHeader = false,
    bool enableSimplePagination = false,
    Function(String field, double newWidth)? onColumnWidthChanged,
    bool enableColumnResize = false,
    bool showHorizontalScrollbar = true,
    ModDataTableActionBarConfig? actionBarConfig,
    List<String>? columnsShow,
    Widget? emptyViewWidget,
    // Modal required properties
    required Widget header,
    // Modal optional properties
    Color? modalHeaderColor,
    Color? modalBodyColor,
    Color? modalFooterColor,
    ModModalPosition position = ModModalPosition.center,
    ModModalSize size = ModModalSize.lg,
    ModModalHeight height = ModModalHeight.auto,
    bool fullScreen = false,
    double borderRadius = 8.0,
    bool barrierDismissible = true,
    VoidCallback? onClose,
    double? maxWidth,
    double? minWidth,
    double? maxHeight,
    double? minHeight,
    EdgeInsets? bodyPadding,
    ModDataTableModalFooterConfig footerConfig =
        const ModDataTableModalFooterConfig(),
  }) {
    final modalAlignment = position == ModModalPosition.top
        ? Alignment.topCenter
        : position == ModModalPosition.bottom
            ? Alignment.bottomCenter
            : Alignment.center;

    return showDialog<R>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => Align(
        alignment: modalAlignment,
        child: ModDataTableModal<T>(
          // DataTable properties
          headers: headers,
          data: data,
          source: source,
          onPageChanged: onPageChanged,
          totalRecords: totalRecords,
          currentPage: currentPage,
          rowsPerPage: rowsPerPage,
          borderStyle: borderStyle,
          oddRowColor: oddRowColor,
          evenRowColor: evenRowColor,
          headerBackgroundColor: headerBackgroundColor,
          footerBackgroundColor: footerBackgroundColor,
          hoverColor: hoverColor,
          paginationText: paginationText,
          rowsPerPageText: rowsPerPageText,
          onSort: onSort,
          onRowsPerPageChanged: onRowsPerPageChanged,
          availableRowsPerPage: availableRowsPerPage,
          paginationBorderRadius: paginationBorderRadius,
          currentSortField: currentSortField,
          currentSortDirection: currentSortDirection,
          rowHeight: rowHeight,
          fixedHeader: fixedHeader,
          enableSimplePagination: enableSimplePagination,
          onColumnWidthChanged: onColumnWidthChanged,
          enableColumnResize: enableColumnResize,
          showHorizontalScrollbar: showHorizontalScrollbar,
          actionBarConfig: actionBarConfig,
          columnsShow: columnsShow,
          emptyViewWidget: emptyViewWidget,
          // Modal properties
          header: header,
          modalHeaderColor: modalHeaderColor,
          modalBodyColor: modalBodyColor,
          modalFooterColor: modalFooterColor,
          position: position,
          size: size,
          height: height,
          fullScreen: fullScreen,
          borderRadius: borderRadius,
          barrierDismissible: barrierDismissible,
          onClose: onClose,
          maxWidth: maxWidth,
          minWidth: minWidth,
          maxHeight: maxHeight,
          minHeight: minHeight,
          bodyPadding: bodyPadding,
          footerConfig: footerConfig,
        ),
      ),
    );
  }
}

class _ModDataTableModalState<T> extends State<ModDataTableModal<T>> {
  late String? _sortField;
  late SortDirection _sortDirection;
  final ScrollController _headerScrollController = ScrollController();
  final ScrollController _bodyScrollController = ScrollController();
  List<double> _columnWidths = [];
  bool _isDragging = false;
  bool _isHorizontalDragging = false;
  double? _lastPanPosition;
  int? _hoveredRowIndex;

  /// Verifica se o hover deve ser habilitado (apenas Windows e Web)
  bool get _isHoverEnabled {
    if (kIsWeb) return true;
    // Em plataformas nativas, verifica se é Windows
    return Theme.of(context).platform == TargetPlatform.windows;
  }

  // Internal state for pagination
  late int _currentPage;
  late int _rowsPerPage;

  // Internal state for visible columns
  late List<String>? _columnsShow;

  List<ModDataHeader> get _visibleHeaders {
    if (_columnsShow == null || _columnsShow!.isEmpty) {
      return widget.headers;
    }
    return widget.headers
        .where((header) => _columnsShow!.contains(header.field))
        .toList();
  }

  List<int> get _visibleColumnIndices {
    if (_columnsShow == null || _columnsShow!.isEmpty) {
      return List.generate(widget.headers.length, (index) => index);
    }
    final indices = <int>[];
    for (int i = 0; i < widget.headers.length; i++) {
      if (_columnsShow!.contains(widget.headers[i].field)) {
        indices.add(i);
      }
    }
    return indices;
  }

  List<double> get _visibleColumnWidths {
    final indices = _visibleColumnIndices;
    return indices.map((i) => _columnWidths[i]).toList();
  }

  /// Returns the paginated data based on current page and rows per page
  List<T> get _paginatedData {
    final startIndex = _currentPage * _rowsPerPage;
    final endIndex = (startIndex + _rowsPerPage).clamp(0, widget.totalRecords);
    if (startIndex >= widget.data.length) {
      return [];
    }
    return widget.data.sublist(startIndex, endIndex.clamp(0, widget.data.length));
  }

  @override
  void initState() {
    super.initState();
    _sortField = widget.currentSortField;
    _sortDirection = widget.currentSortDirection;
    _columnWidths = widget.headers.map((header) => header.width).toList();

    // Initialize internal pagination state
    _currentPage = widget.currentPage;
    _rowsPerPage = widget.rowsPerPage;

    // Initialize internal columns state
    _columnsShow = widget.columnsShow != null ? List.from(widget.columnsShow!) : null;

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
  void didUpdateWidget(ModDataTableModal<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentSortField != widget.currentSortField ||
        oldWidget.currentSortDirection != widget.currentSortDirection) {
      _sortField = widget.currentSortField;
      _sortDirection = widget.currentSortDirection;
    }
  }

  void _handleScrollbarDrag(double localPosition, double trackWidth) {
    if (!_bodyScrollController.hasClients ||
        !_bodyScrollController.position.hasContentDimensions) {
      return;
    }

    final double maxScroll = _bodyScrollController.position.maxScrollExtent;
    if (maxScroll <= 0) {
      return;
    }

    final double percentage = (localPosition / trackWidth).clamp(0.0, 1.0);
    final double targetOffset = (maxScroll * percentage).clamp(0.0, maxScroll);

    _bodyScrollController.jumpTo(targetOffset);
  }

  void _handleHorizontalDrag(double deltaX) {
    if (!_bodyScrollController.hasClients ||
        !_bodyScrollController.position.hasContentDimensions) {
      return;
    }

    final double currentOffset = _bodyScrollController.offset;
    final double maxScroll = _bodyScrollController.position.maxScrollExtent;

    final double newOffset = (currentOffset - deltaX).clamp(0.0, maxScroll);

    _bodyScrollController.jumpTo(newOffset);
  }

  void _showColumnSettingsModal(BuildContext context) {
    final config = widget.actionBarConfig!;
    final allHeaders = widget.headers;
    final currentColumnsShow = _columnsShow;

    final selectedColumns = <String>{};
    if (currentColumnsShow == null || currentColumnsShow.isEmpty) {
      selectedColumns.addAll(allHeaders.map((h) => h.field));
    } else {
      selectedColumns.addAll(currentColumnsShow);
    }

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              backgroundColor: Colors.transparent,
              child: Container(
                width: 400,
                constraints: const BoxConstraints(maxHeight: 500),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Theme.of(context).dividerColor,
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            config.settingsModalTitle,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => Navigator.of(dialogContext).pop(),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: allHeaders.map((header) {
                            final isSelected =
                                selectedColumns.contains(header.field);
                            return CheckboxListTile(
                              title: Text(header.field.tr),
                              value: isSelected,
                              onChanged: (value) {
                                setDialogState(() {
                                  if (value == true) {
                                    selectedColumns.add(header.field);
                                  } else {
                                    if (selectedColumns.length > 1) {
                                      selectedColumns.remove(header.field);
                                    }
                                  }
                                });
                              },
                              controlAffinity: ListTileControlAffinity.leading,
                              dense: true,
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: Theme.of(context).dividerColor,
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.of(dialogContext).pop(),
                            child: Text(config.settingsModalCancelText),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () {
                              final orderedSelection = allHeaders
                                  .where(
                                      (h) => selectedColumns.contains(h.field))
                                  .map((h) => h.field)
                                  .toList();
                              // Update internal state to trigger rebuild
                              setState(() {
                                _columnsShow = orderedSelection;
                              });
                              config.settingsOnChange?.call(orderedSelection);
                              Navigator.of(dialogContext).pop();
                            },
                            child: Text(config.settingsModalConfirmText),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  IconData _extractIconData(Widget? iconWidget, IconData defaultIcon) {
    if (iconWidget is Icon) {
      return iconWidget.icon ?? defaultIcon;
    }
    return defaultIcon;
  }

  Color? _extractIconColor(Widget? iconWidget) {
    if (iconWidget is Icon) {
      return iconWidget.color;
    }
    return null;
  }

  double? _extractIconSize(Widget? iconWidget) {
    if (iconWidget is Icon) {
      return iconWidget.size;
    }
    return null;
  }

  /// Builds the action bar with dynamic actions and the settings button.
  /// Custom actions are rendered in order, followed by the settings button (if enabled).
  /// If actionsModColumn is provided, it renders using ModContainer > ModRow > columns structure.
  Widget _buildActionBar() {
    final config = widget.actionBarConfig;
    if (config == null || !config.hasAnyAction) {
      return const SizedBox.shrink();
    }

    // If actionsModColumn is provided, render using ModContainer > ModRow structure
    if (config.actionsModColumn != null && config.actionsModColumn!.isNotEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        decoration: BoxDecoration(
          color: config.background,
          borderRadius: config.borderRadius,
        ),
        child: Row(
          children: [
            Expanded(
              child: ModContainer(
                child: ModRow(
                  columns: config.actionsModColumn!,
                ),
              ),
            ),
            // Settings button is always rendered last (rightmost position)
            if (config.enableSettings)
              Builder(
                builder: (context) => ModIconButton(
                  icon: _extractIconData(config.settingsIcon, Icons.settings),
                  color: _extractIconColor(config.settingsIcon),
                  iconSize: _extractIconSize(config.settingsIcon),
                  tooltip: config.settingsTooltip,
                  onPressed: () async => _showColumnSettingsModal(context),
                ),
              ),
          ],
        ),
      );
    }

    // Default behavior: render actions as a Row
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      decoration: BoxDecoration(
        color: config.background,
        borderRadius: config.borderRadius,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Render all custom actions from the actions list
          ...config.actions,
          // Settings button is always rendered last (rightmost position)
          if (config.enableSettings)
            Builder(
              builder: (context) => ModIconButton(
                icon: _extractIconData(config.settingsIcon, Icons.settings),
                color: _extractIconColor(config.settingsIcon),
                iconSize: _extractIconSize(config.settingsIcon),
                tooltip: config.settingsTooltip,
                onPressed: () async => _showColumnSettingsModal(context),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCustomScrollbar(
      Widget child, double totalWidth, double screenWidth) {
    if (!widget.showHorizontalScrollbar || totalWidth <= screenWidth) {
      return child;
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth <= 0) {
          return child;
        }

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: child,
            ),
            Container(
              height: 25,
              width: constraints.maxWidth,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: LayoutBuilder(
                builder: (context, scrollbarConstraints) {
                  if (scrollbarConstraints.maxWidth <= 16) {
                    return const SizedBox();
                  }

                  return GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onPanStart: (details) {
                      if (_bodyScrollController.hasClients &&
                          _bodyScrollController.position.hasContentDimensions) {
                        _isDragging = true;
                        _handleScrollbarDrag(details.localPosition.dx,
                            scrollbarConstraints.maxWidth - 16);
                      }
                    },
                    onPanUpdate: (details) {
                      if (_isDragging &&
                          _bodyScrollController.hasClients &&
                          _bodyScrollController.position.hasContentDimensions) {
                        _handleScrollbarDrag(details.localPosition.dx,
                            scrollbarConstraints.maxWidth - 16);
                      }
                    },
                    onPanEnd: (details) {
                      _isDragging = false;
                    },
                    onTapDown: (details) {
                      if (_bodyScrollController.hasClients &&
                          _bodyScrollController.position.hasContentDimensions) {
                        _handleScrollbarDrag(details.localPosition.dx,
                            scrollbarConstraints.maxWidth - 16);
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      height: 13,
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: AnimatedBuilder(
                        animation: _bodyScrollController,
                        builder: (context, child) {
                          if (!_bodyScrollController.hasClients ||
                              !_bodyScrollController
                                  .position.hasContentDimensions ||
                              scrollbarConstraints.maxWidth <= 16) {
                            return Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                width: 50,
                                height: 13,
                                decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.6),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                            );
                          }

                          final double maxScroll =
                              _bodyScrollController.position.maxScrollExtent;
                          final double currentScroll =
                              _bodyScrollController.offset;
                          final double trackWidth =
                              scrollbarConstraints.maxWidth - 16;
                          final double thumbWidth =
                              (screenWidth / totalWidth * trackWidth)
                                  .clamp(50.0, trackWidth);
                          final double thumbPosition = maxScroll > 0
                              ? (currentScroll / maxScroll) *
                                  (trackWidth - thumbWidth)
                              : 0;

                          return Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              margin: EdgeInsets.only(
                                  left: thumbPosition.clamp(
                                      0.0, trackWidth - thumbWidth)),
                              width: thumbWidth,
                              height: 13,
                              decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.6),
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
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

  Widget _buildHeader(List<double> columnWidths) {
    final visibleHeaders = _visibleHeaders;
    final visibleIndices = _visibleColumnIndices;

    return Container(
      color: widget.headerBackgroundColor,
      child: Row(
        children: List.generate(visibleHeaders.length, (visibleIndex) {
          final header = visibleHeaders[visibleIndex];
          final originalIndex = visibleIndices[visibleIndex];
          final width = _columnWidths[originalIndex];

          Widget headerContent = GestureDetector(
            onTap: () {
              if (header.sortable && widget.onSort != null) {
                setState(() {
                  if (_sortField == header.field) {
                    _sortDirection = _sortDirection == SortDirection.asc
                        ? SortDirection.desc
                        : SortDirection.asc;
                  } else {
                    _sortField = header.field;
                    _sortDirection = SortDirection.asc;
                  }
                  widget.onSort!(_sortField!, _sortDirection);
                });
              }
            },
            child: Container(
              width: width,
              decoration: _getBorderDecoration(),
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Expanded(
                    child: header.child,
                  ),
                  if (header.sortable)
                    Icon(
                      _sortField == header.field
                          ? (_sortDirection == SortDirection.asc
                              ? Icons.arrow_upward
                              : Icons.arrow_downward)
                          : Icons.unfold_more,
                      size: 16,
                    ),
                ],
              ),
            ),
          );

          if (widget.enableColumnResize) {
            headerContent = GestureDetector(
              onHorizontalDragUpdate: (details) {
                setState(() {
                  final newWidth = max(
                      50.0, _columnWidths[originalIndex] + details.delta.dx);
                  _columnWidths[originalIndex] = newWidth;
                  if (widget.onColumnWidthChanged != null) {
                    widget.onColumnWidthChanged!(header.field, newWidth);
                  }
                });
              },
              child: MouseRegion(
                cursor: SystemMouseCursors.resizeColumn,
                child: headerContent,
              ),
            );
          }

          return headerContent;
        }),
      ),
    );
  }

  Widget _buildRows(List<T> visibleData, List<double> columnWidths) {
    final visibleIndices = _visibleColumnIndices;
    final theme = Theme.of(context);

    return Column(
      children: List.generate(visibleData.length, (index) {
        // Calculate the absolute index in the source based on current page
        final absoluteIndex = (_currentPage * _rowsPerPage) + index;
        final row = widget.source.getRow(absoluteIndex);
        final isHovered = _hoveredRowIndex == index;
        final baseColor = index % 2 == 0 ? widget.evenRowColor : widget.oddRowColor;

        // Determina a cor de hover: usa a cor personalizada ou a cor padrão do tema
        final effectiveHoverColor = widget.hoverColor ?? theme.hoverColor;

        // Aplica a cor de hover apenas se estiver habilitado e a linha estiver com hover
        final rowColor = (_isHoverEnabled && isHovered) ? effectiveHoverColor : baseColor;

        Widget rowWidget = Container(
          color: rowColor,
          child: Row(
            children: List.generate(visibleIndices.length, (visibleIndex) {
              final originalIndex = visibleIndices[visibleIndex];
              return Container(
                width: _columnWidths[originalIndex],
                decoration: _getBorderDecoration(),
                padding: const EdgeInsets.all(8),
                child: row?.cells[originalIndex].child ?? const SizedBox(),
              );
            }),
          ),
        );

        // Adiciona MouseRegion apenas se hover estiver habilitado
        if (_isHoverEnabled) {
          rowWidget = MouseRegion(
            onEnter: (_) {
              setState(() {
                _hoveredRowIndex = index;
              });
            },
            onExit: (_) {
              setState(() {
                _hoveredRowIndex = null;
              });
            },
            child: rowWidget,
          );
        }

        return rowWidget;
      }),
    );
  }

  Widget _buildPaginationControls() {
    final totalPages = (widget.totalRecords / _rowsPerPage).ceil();
    final currentStart = (_currentPage * _rowsPerPage) + 1;
    final currentEnd =
        min((_currentPage + 1) * _rowsPerPage, widget.totalRecords);
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 600;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.onRowsPerPageChanged != null) ...[
          _buildRowsPerPage(isMobile),
          const SizedBox(width: 16),
        ],
        _buildPageNavigation(totalPages, currentStart, currentEnd, isMobile),
      ],
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
          value: _rowsPerPage,
          items: widget.availableRowsPerPage
              .map((value) => DropdownMenuItem<int>(
                    value: value,
                    child: Text(value.toString()),
                  ))
              .toList(),
          onChanged: (value) {
            if (value != null) {
              setState(() {
                _rowsPerPage = value;
                // Reset to first page when changing rows per page
                _currentPage = 0;
              });
              widget.onRowsPerPageChanged?.call(value);
            }
          },
        ),
      ],
    );
  }

  void _handlePageChange(int newPage) {
    setState(() {
      _currentPage = newPage;
    });
    widget.onPageChanged(newPage);
  }

  Widget _buildPageNavigation(
      int totalPages, int currentStart, int currentEnd, bool isMobile) {
    final pageNumbers = _generatePageNumbers(totalPages);

    return Row(
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
          onPressed: _currentPage > 0
              ? () => _handlePageChange(_currentPage - 1)
              : null,
        ),
        if (widget.enableSimplePagination && widget.totalRecords == 0)
          Text('${_currentPage + 1}')
        else if (isMobile)
          Text('${_currentPage + 1} / $totalPages')
        else
          ...pageNumbers.map((pageNum) => SizedBox(
                width: 40,
                child: TextButton(
                  onPressed: () => _handlePageChange(pageNum - 1),
                  child: Text(
                    pageNum.toString(),
                    style: TextStyle(
                      fontWeight: pageNum == _currentPage + 1
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
              ? () => _handlePageChange(_currentPage + 1)
              : null,
        ),
      ],
    );
  }

  List<int> _generatePageNumbers(int totalPages) {
    const maxVisiblePages = 5;
    final currentPage = _currentPage + 1;
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

  /// Checks if the table should show the empty view
  bool get _shouldShowEmptyView =>
      widget.data.isEmpty && widget.emptyViewWidget != null;

  Widget _buildDataTableBody() {
    final hasActionBar = widget.actionBarConfig?.hasAnyAction ?? false;

    // If showing empty view, display action bar and empty view widget only
    if (_shouldShowEmptyView) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Action bar is always visible
          if (hasActionBar) _buildActionBar(),
          // Empty view widget
          Flexible(
            child: widget.emptyViewWidget!,
          ),
        ],
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        double totalFixedWidth = 0;
        double totalPercentage = 0;

        final visibleHeaders = _visibleHeaders;
        for (var header in visibleHeaders) {
          if (header.widthType == WidthType.fixed) {
            totalFixedWidth += header.width;
          } else {
            totalPercentage += header.width;
          }
        }

        final remainingWidth = max(0.0, screenWidth - totalFixedWidth);
        final columnWidths = visibleHeaders.map((header) {
          return header.widthType == WidthType.fixed
              ? header.width
              : remainingWidth * (header.width / totalPercentage);
        }).toList();

        final totalWidth =
            _visibleColumnWidths.fold(0.0, (sum, width) => sum + width);

        Widget buildScrollableContent() {
          final scrollableContent = GestureDetector(
            onPanStart: (details) {
              _isHorizontalDragging = true;
              _lastPanPosition = details.localPosition.dx;
            },
            onPanUpdate: (details) {
              if (_isHorizontalDragging && _lastPanPosition != null) {
                final double deltaX =
                    details.localPosition.dx - _lastPanPosition!;
                _handleHorizontalDrag(deltaX);
                _lastPanPosition = details.localPosition.dx;
              }
            },
            onPanEnd: (details) {
              _isHorizontalDragging = false;
              _lastPanPosition = null;
            },
            onPanCancel: () {
              _isHorizontalDragging = false;
              _lastPanPosition = null;
            },
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              controller: _bodyScrollController,
              physics: const NeverScrollableScrollPhysics(),
              child: SizedBox(
                width: max(totalWidth, screenWidth),
                child: Column(
                  children: [
                    if (!widget.fixedHeader) _buildHeader(columnWidths),
                    _buildRows(_paginatedData, columnWidths),
                  ],
                ),
              ),
            ),
          );

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (hasActionBar) _buildActionBar(),
              if (widget.fixedHeader)
                GestureDetector(
                  onPanStart: (details) {
                    _isHorizontalDragging = true;
                    _lastPanPosition = details.localPosition.dx;
                  },
                  onPanUpdate: (details) {
                    if (_isHorizontalDragging && _lastPanPosition != null) {
                      final double deltaX =
                          details.localPosition.dx - _lastPanPosition!;
                      _handleHorizontalDrag(deltaX);
                      _lastPanPosition = details.localPosition.dx;
                    }
                  },
                  onPanEnd: (details) {
                    _isHorizontalDragging = false;
                    _lastPanPosition = null;
                  },
                  onPanCancel: () {
                    _isHorizontalDragging = false;
                    _lastPanPosition = null;
                  },
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    controller: _headerScrollController,
                    physics: const NeverScrollableScrollPhysics(),
                    child: SizedBox(
                      width: max(totalWidth, screenWidth),
                      child: _buildHeader(columnWidths),
                    ),
                  ),
                ),
              Flexible(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: widget.showHorizontalScrollbar
                      ? _buildCustomScrollbar(
                          scrollableContent, totalWidth, screenWidth)
                      : scrollableContent,
                ),
              ),
            ],
          );
        }

        return buildScrollableContent();
      },
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Pagination on the left
        Flexible(
          child: _buildPaginationControls(),
        ),
        // Buttons on the right
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ...widget.footerConfig.buttons,
            if (widget.footerConfig.showCloseButton) ...[
              if (widget.footerConfig.buttons.isNotEmpty)
                const SizedBox(width: 8),
              TextButton(
                style: widget.footerConfig.closeButtonStyle,
                onPressed: () {
                  if (widget.onClose != null) {
                    widget.onClose!();
                  }
                  Navigator.of(context).pop();
                },
                child: Text(widget.footerConfig.closeButtonText),
              ),
            ],
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: widget.fullScreen
          ? EdgeInsets.zero
          : const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Container(
        width: _getModalWidth(context),
        constraints: BoxConstraints(
          maxHeight: _getModalHeight(context),
          minWidth: widget.minWidth ?? 0,
          maxWidth: widget.maxWidth ?? double.infinity,
          minHeight: widget.minHeight ?? 0,
        ),
        decoration: BoxDecoration(
          borderRadius: widget.fullScreen
              ? BorderRadius.zero
              : BorderRadius.circular(widget.borderRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: widget.modalHeaderColor ?? theme.colorScheme.surface,
                borderRadius: widget.fullScreen
                    ? BorderRadius.zero
                    : BorderRadius.only(
                        topLeft: Radius.circular(widget.borderRadius),
                        topRight: Radius.circular(widget.borderRadius),
                      ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: widget.header),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      if (widget.onClose != null) {
                        widget.onClose!();
                      }
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
            const Divider(height: 1, thickness: 1),
            // Body - DataTable
            Flexible(
              child: Container(
                width: double.infinity,
                color: widget.modalBodyColor ?? theme.colorScheme.surface,
                padding: widget.bodyPadding ?? const EdgeInsets.all(16),
                child: _buildDataTableBody(),
              ),
            ),
            const Divider(height: 1, thickness: 1),
            // Footer - Pagination left, buttons right
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: widget.modalFooterColor ?? theme.colorScheme.surface,
                borderRadius: widget.fullScreen
                    ? BorderRadius.zero
                    : BorderRadius.only(
                        bottomLeft: Radius.circular(widget.borderRadius),
                        bottomRight: Radius.circular(widget.borderRadius),
                      ),
              ),
              child: _buildFooter(context),
            ),
          ],
        ),
      ),
    );
  }

  double _getModalWidth(BuildContext context) {
    if (widget.fullScreen) return MediaQuery.of(context).size.width;

    final screenWidth = MediaQuery.of(context).size.width;
    double calculatedWidth;

    switch (widget.size) {
      case ModModalSize.xs:
        calculatedWidth = screenWidth * 0.3;
        break;
      case ModModalSize.sm:
        calculatedWidth = screenWidth * 0.5;
        break;
      case ModModalSize.md:
        calculatedWidth = screenWidth * 0.7;
        break;
      case ModModalSize.lg:
        calculatedWidth = screenWidth * 0.9;
        break;
    }

    if (widget.maxWidth != null && calculatedWidth > widget.maxWidth!) {
      calculatedWidth = widget.maxWidth!;
    }
    if (widget.minWidth != null && calculatedWidth < widget.minWidth!) {
      calculatedWidth = widget.minWidth!;
    }

    return calculatedWidth;
  }

  double _getModalHeight(BuildContext context) {
    if (widget.fullScreen) return MediaQuery.of(context).size.height;

    final screenHeight = MediaQuery.of(context).size.height;
    double calculatedHeight;

    switch (widget.height) {
      case ModModalHeight.full:
        calculatedHeight = screenHeight * 0.9;
        break;
      case ModModalHeight.auto:
        return widget.maxHeight ?? double.infinity;
      case ModModalHeight.normal:
        calculatedHeight = screenHeight * 0.6;
        break;
    }

    if (widget.maxHeight != null && calculatedHeight > widget.maxHeight!) {
      calculatedHeight = widget.maxHeight!;
    }
    if (widget.minHeight != null && calculatedHeight < widget.minHeight!) {
      calculatedHeight = widget.minHeight!;
    }

    return calculatedHeight;
  }
}
