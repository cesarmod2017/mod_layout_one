import 'dart:math';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mod_layout_one/widgets/buttons/icon_buttom.dart';
import 'package:mod_layout_one/widgets/grid_system/grid_system.dart';

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

/// Configuration class for the DataTable action bar.
///
/// The action bar supports dynamic composition through the [actions] list,
/// allowing developers to add any widget (buttons, inputs, icons, etc.).
/// The settings button (when enabled) is always positioned at the rightmost position.
///
/// Alternatively, you can use [actionsModColumn] to render actions within a
/// responsive grid system using ModContainer > ModRow > columns structure.
///
/// Example usage:
/// ```dart
/// ModDataTableActionBarConfig(
///   actions: [
///     IconButton(
///       icon: Icon(Icons.picture_as_pdf, color: Colors.red),
///       onPressed: () => exportToPdf(),
///     ),
///     IconButton(
///       icon: Icon(Icons.table_chart, color: Colors.green),
///       onPressed: () => exportToExcel(),
///     ),
///     SizedBox(
///       width: 200,
///       child: TextField(
///         decoration: InputDecoration(hintText: 'Search...'),
///       ),
///     ),
///   ],
///   enableSettings: true,
///   settingsOnChange: (columns) => updateVisibleColumns(columns),
/// )
/// ```
class ModDataTableActionBarConfig {
  /// List of custom action widgets to display in the action bar.
  /// These widgets are rendered in order, from left to right.
  /// The settings button (if enabled) is always rendered after all actions.
  /// This is optional - if not provided, an empty list is used.
  final List<Widget> actions;

  /// List of ModColumn widgets to display in the action bar using a responsive grid.
  /// When provided, these are rendered inside a ModContainer > ModRow structure.
  /// This takes precedence over [actions] if both are provided.
  final List<ModColumn>? actionsModColumn;

  /// Enable settings/column configuration button.
  /// This button is always positioned at the rightmost position of the action bar.
  final bool enableSettings;

  /// Callback when column selection is confirmed in settings modal
  final Function(List<String>)? settingsOnChange;

  /// Icon widget for the settings button. Defaults to Icon(Icons.settings) if not provided.
  final Widget? settingsIcon;

  /// Tooltip for the settings button
  final String? settingsTooltip;

  /// Title for the settings modal
  final String settingsModalTitle;

  /// Confirm button text for the settings modal
  final String settingsModalConfirmText;

  /// Cancel button text for the settings modal
  final String settingsModalCancelText;

  /// Background color for the action bar
  final Color? background;

  /// Border radius for the action bar
  final BorderRadius? borderRadius;

  const ModDataTableActionBarConfig({
    this.actions = const [],
    this.actionsModColumn,
    this.enableSettings = false,
    this.settingsOnChange,
    this.settingsIcon,
    this.settingsTooltip,
    this.settingsModalTitle = 'Column Settings',
    this.settingsModalConfirmText = 'Confirm',
    this.settingsModalCancelText = 'Cancel',
    this.background,
    this.borderRadius,
  });

  /// Returns true if there are any actions, actionsModColumn, or if settings is enabled
  bool get hasAnyAction =>
      actions.isNotEmpty ||
      (actionsModColumn != null && actionsModColumn!.isNotEmpty) ||
      enableSettings;
}

class ModDataTable<T> extends StatefulWidget {
  final List<ModDataHeader> headers;
  final List<T> data;
  final DataTableSource source;
  final BorderStyle borderStyle;
  final int rowsPerPage;

  /// Cor de fundo para linhas ímpares do body (primeira linha = ímpar)
  final Color? oddRowColor;

  /// Cor de fundo para linhas pares do body (segunda linha = par)
  final Color? evenRowColor;

  /// Cor de fundo do header da tabela
  final Color? headerBackgroundColor;

  /// Cor de fundo do footer/paginação da tabela
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

  /// Configuration for the action bar (PDF, XLS, Settings buttons)
  final ModDataTableActionBarConfig? actionBarConfig;

  /// List of column field names to display. If null or empty, all columns are shown.
  final List<String>? columnsShow;

  /// Widget to display when the data list is empty.
  /// When provided and data is empty, this widget will be shown instead of the header and body,
  /// but the action bar will remain visible.
  final Widget? emptyViewWidget;

  const ModDataTable({
    super.key,
    required this.headers,
    required this.data,
    required this.source,
    this.borderStyle = BorderStyle.none,
    required this.rowsPerPage,
    this.oddRowColor,
    this.evenRowColor,
    this.headerBackgroundColor,
    this.footerBackgroundColor,
    this.hoverColor,
    this.paginationText = 'of',
    this.rowsPerPageText = 'Rows per page',
    required this.onPageChanged,
    this.onSort,
    required this.totalRecords,
    required this.currentPage,
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
  });

  @override
  State<ModDataTable<T>> createState() => _ModDataTableState<T>();
}

class _ModDataTableState<T> extends State<ModDataTable<T>> {
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

  /// Returns the list of visible headers based on columnsShow
  List<ModDataHeader> get _visibleHeaders {
    if (widget.columnsShow == null || widget.columnsShow!.isEmpty) {
      return widget.headers;
    }
    return widget.headers
        .where((header) => widget.columnsShow!.contains(header.field))
        .toList();
  }

  /// Returns the indices of visible columns in the original headers list
  List<int> get _visibleColumnIndices {
    if (widget.columnsShow == null || widget.columnsShow!.isEmpty) {
      return List.generate(widget.headers.length, (index) => index);
    }
    final indices = <int>[];
    for (int i = 0; i < widget.headers.length; i++) {
      if (widget.columnsShow!.contains(widget.headers[i].field)) {
        indices.add(i);
      }
    }
    return indices;
  }

  /// Returns the widths of visible columns
  List<double> get _visibleColumnWidths {
    final indices = _visibleColumnIndices;
    return indices.map((i) => _columnWidths[i]).toList();
  }

  @override
  void initState() {
    super.initState();
    _sortField = widget.currentSortField;
    _sortDirection = widget.currentSortDirection;
    _columnWidths = widget.headers.map((header) => header.width).toList();

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

    // Debug para entender o problema
    debugPrint(
        'Drag: localPos=$localPosition, trackWidth=$trackWidth, percentage=$percentage, targetOffset=$targetOffset, isDragging=$_isDragging');

    _bodyScrollController.jumpTo(targetOffset);
  }

  void _handleHorizontalDrag(double deltaX) {
    if (!_bodyScrollController.hasClients ||
        !_bodyScrollController.position.hasContentDimensions) {
      return;
    }

    final double currentOffset = _bodyScrollController.offset;
    final double maxScroll = _bodyScrollController.position.maxScrollExtent;

    // Inverte o deltaX para o comportamento natural (arrastar para direita move para esquerda)
    final double newOffset = (currentOffset - deltaX).clamp(0.0, maxScroll);

    _bodyScrollController.jumpTo(newOffset);
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
            // Conteúdo flexível mas não expandido
            Flexible(
              child: child,
            ),
            // Scrollbar fixo na parte inferior
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
                          // Verificação de segurança mais robusta
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

  /// Shows the column settings modal
  void _showColumnSettingsModal(BuildContext context) {
    final config = widget.actionBarConfig!;
    final allHeaders = widget.headers;
    final currentColumnsShow = widget.columnsShow;

    // Initialize selected columns: if columnsShow is null/empty, all columns are selected
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
                    // Header
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
                    // Body - Column checkboxes
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
                                    // Prevent unchecking the last column
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
                    // Footer
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
                              // Maintain original order based on headers
                              final orderedSelection = allHeaders
                                  .where(
                                      (h) => selectedColumns.contains(h.field))
                                  .map((h) => h.field)
                                  .toList();
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

  /// Extracts IconData from a Widget if it's an Icon, otherwise returns the default
  IconData _extractIconData(Widget? iconWidget, IconData defaultIcon) {
    if (iconWidget is Icon) {
      return iconWidget.icon ?? defaultIcon;
    }
    return defaultIcon;
  }

  /// Extracts the color from a Widget if it's an Icon
  Color? _extractIconColor(Widget? iconWidget) {
    if (iconWidget is Icon) {
      return iconWidget.color;
    }
    return null;
  }

  /// Extracts the size from a Widget if it's an Icon
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
    if (config.actionsModColumn != null &&
        config.actionsModColumn!.isNotEmpty) {
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

  /// Checks if the table should show the empty view
  bool get _shouldShowEmptyView =>
      widget.data.isEmpty && widget.emptyViewWidget != null;

  @override
  Widget build(BuildContext context) {
    const headerHeight = 40.0;
    const paginationHeight = 56.0;
    final hasActionBar = widget.actionBarConfig?.hasAnyAction ?? false;
    const actionBarHeight = 48.0;

    // If showing empty view, calculate height differently
    if (_shouldShowEmptyView) {
      return LayoutBuilder(
        builder: (context, constraints) {
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
        },
      );
    }

    final totalHeight =
        (widget.rowHeight * min(widget.rowsPerPage, widget.source.rowCount)) +
            headerHeight +
            paginationHeight +
            25 +
            (hasActionBar ? actionBarHeight : 0);

    return SizedBox(
      height: totalHeight,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final screenWidth = constraints.maxWidth;
          double totalFixedWidth = 0;
          double totalPercentage = 0;

          // Use visible headers for width calculations
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
                physics:
                    const NeverScrollableScrollPhysics(), // Desabilita o scroll nativo para usar o personalizado
                child: SizedBox(
                  width: max(totalWidth, screenWidth),
                  child: Column(
                    children: [
                      if (!widget.fixedHeader) _buildHeader(columnWidths),
                      _buildRows(widget.data, columnWidths),
                    ],
                  ),
                ),
              ),
            );

            return Column(
              children: [
                // Action bar above the table header
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
                      physics:
                          const NeverScrollableScrollPhysics(), // Desabilita o scroll nativo para usar o personalizado
                      child: SizedBox(
                        width: max(totalWidth, screenWidth),
                        child: _buildHeader(columnWidths),
                      ),
                    ),
                  ),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: widget.showHorizontalScrollbar
                        ? _buildCustomScrollbar(
                            scrollableContent, totalWidth, screenWidth)
                        : scrollableContent,
                  ),
                ),
                _buildPagination(),
              ],
            );
          }

          return buildScrollableContent();
        },
      ),
    );
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
        final row = widget.source.getRow(index);
        final isHovered = _hoveredRowIndex == index;
        final baseColor =
            index % 2 == 0 ? widget.evenRowColor : widget.oddRowColor;

        // Determina a cor de hover: usa a cor personalizada ou a cor padrão do tema
        final effectiveHoverColor = widget.hoverColor ?? theme.hoverColor;

        // Aplica a cor de hover apenas se estiver habilitado e a linha estiver com hover
        final rowColor =
            (_isHoverEnabled && isHovered) ? effectiveHoverColor : baseColor;

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

  Widget _buildPagination() {
    final totalPages = (widget.totalRecords / widget.rowsPerPage).ceil();
    final currentStart = (widget.currentPage * widget.rowsPerPage) + 1;
    final currentEnd =
        min((widget.currentPage + 1) * widget.rowsPerPage, widget.totalRecords);
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 600;

    return Container(
      decoration: BoxDecoration(
        color: widget.footerBackgroundColor,
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
