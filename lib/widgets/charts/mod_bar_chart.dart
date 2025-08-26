import 'dart:io' show Platform;
import 'dart:math' as math;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'controllers/bar_chart_controller.dart';
import 'models/chart_data.dart';

enum BarChartOrientation {
  horizontal,
  vertical,
}

class _HoverableBar extends StatefulWidget {
  final ModChartDataItem item;
  final Color color;
  final double width;
  final double height;
  final double radius;
  final String formattedValue;
  final bool showValueLabels;
  final bool showTooltip;
  final VoidCallback? onTap;
  final bool isHorizontal;

  const _HoverableBar({
    required this.item,
    required this.color,
    required this.width,
    required this.height,
    required this.radius,
    required this.formattedValue,
    required this.showValueLabels,
    required this.showTooltip,
    this.onTap,
    this.isHorizontal = true,
  });

  @override
  State<_HoverableBar> createState() => _HoverableBarState();
}

class _HoverableBarState extends State<_HoverableBar> {
  bool _isHovered = false;
  bool _isPressed = false;

  bool get _isDesktop =>
      kIsWeb ||
      (!kIsWeb && (Platform.isWindows || Platform.isMacOS || Platform.isLinux));

  Color get _currentColor {
    if (_isPressed && !_isDesktop) {
      return widget.color.withValues(alpha: 0.5); // Mobile pressed
    } else if (_isHovered && _isDesktop) {
      return widget.color.withValues(alpha: 0.5); // Desktop hover
    }
    return widget.color; // Normal state
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: widget.onTap != null
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      onEnter: _isDesktop ? (_) => setState(() => _isHovered = true) : null,
      onExit: _isDesktop ? (_) => setState(() => _isHovered = false) : null,
      child: GestureDetector(
        onTapDown:
            !_isDesktop ? (_) => setState(() => _isPressed = true) : null,
        onTapUp: !_isDesktop ? (_) => setState(() => _isPressed = false) : null,
        onTapCancel:
            !_isDesktop ? () => setState(() => _isPressed = false) : null,
        onTap: widget.onTap,
        child: Tooltip(
          message: widget.showTooltip
              ? '${widget.item.label}: ${widget.formattedValue}'
              : '',
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            height: widget.height,
            width: widget.width,
            decoration: BoxDecoration(
              color: _currentColor,
              borderRadius: widget.isHorizontal
                  ? BorderRadius.circular(widget.radius)
                  : BorderRadius.vertical(
                      top: Radius.circular(widget.radius),
                      bottom: Radius.circular(widget.radius / 2),
                    ),
              boxShadow: [
                BoxShadow(
                  color: _currentColor.withValues(alpha: 0.3),
                  blurRadius: _isHovered || _isPressed ? 12 : 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: widget.showValueLabels &&
                    widget.isHorizontal &&
                    widget.width >= 50
                ? Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: Text(
                        widget.formattedValue,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  )
                : null,
          ),
        ),
      ),
    );
  }
}

class ModBarChart extends StatefulWidget {
  final String title;
  final TextStyle? titleStyle;
  final List<ChartActionButton> actions;
  final ModChartData? initialData;
  final Future<ModChartData> Function(String period)? fetchData;
  final Function(String)? onPeriodChange;
  final Function(String, List<ModChartDataItem>)? onDataLoaded;
  final Function(ModChartDataItem)? onBarClick;
  final Function(String)? onError;
  final BarChartOrientation orientation;
  final double barHeight;
  final double barSpacing;
  final double barRadius;
  final int maxItemsBeforeScroll;
  final bool showTooltip;
  final bool showValueLabels;
  final bool enableZoom;
  final double minZoom;
  final double maxZoom;
  final double chartContainerHeight;
  final double? barChartWidth;
  final EdgeInsets? padding;
  final Widget? footer;
  final List<Color>? customColors;

  // Footer interativo
  final bool enableFooter;
  final String? emptyStateTitle;
  final IconData? emptyStateIcon;

  // Cores dos botões de ação - Light Theme
  final Color? lightSelectedBackgroundColor;
  final Color? lightUnselectedBackgroundColor;
  final Color? lightSelectedTextColor;
  final Color? lightUnselectedTextColor;
  final Color? lightBorderColor;

  // Cores dos botões de ação - Dark Theme
  final Color? darkSelectedBackgroundColor;
  final Color? darkUnselectedBackgroundColor;
  final Color? darkSelectedTextColor;
  final Color? darkUnselectedTextColor;
  final Color? darkBorderColor;

  const ModBarChart({
    super.key,
    required this.title,
    this.titleStyle,
    this.actions = const [],
    this.initialData,
    this.fetchData,
    this.onPeriodChange,
    this.onDataLoaded,
    this.onBarClick,
    this.onError,
    this.orientation = BarChartOrientation.horizontal,
    this.barHeight = 36,
    this.barSpacing = 16,
    this.barRadius = 8,
    this.maxItemsBeforeScroll = 12,
    this.showTooltip = true,
    this.showValueLabels = true,
    this.enableZoom = true,
    this.minZoom = 50.0,
    this.maxZoom = 200.0,
    this.chartContainerHeight = 400.0,
    this.barChartWidth,
    this.padding,
    this.footer,
    this.customColors,
    // Footer options
    this.enableFooter = false,
    this.emptyStateTitle,
    this.emptyStateIcon,
    // Light theme colors
    this.lightSelectedBackgroundColor,
    this.lightUnselectedBackgroundColor,
    this.lightSelectedTextColor,
    this.lightUnselectedTextColor,
    this.lightBorderColor,
    // Dark theme colors
    this.darkSelectedBackgroundColor,
    this.darkUnselectedBackgroundColor,
    this.darkSelectedTextColor,
    this.darkUnselectedTextColor,
    this.darkBorderColor,
  });

  @override
  State<ModBarChart> createState() => _ModBarChartState();
}

class _ModBarChartState extends State<ModBarChart> {
  late BarChartController controller;
  double _currentZoom = 100.0;
  
  // Controla a visibilidade dos itens do gráfico
  Map<String, bool> _itemVisibility = {};

  final List<Color> defaultColors = [
    const Color(0xFF2196F3), // Blue
    const Color(0xFF00BCD4), // Cyan
    const Color(0xFFFF9800), // Orange
    const Color(0xFFE91E63), // Pink
    const Color(0xFF4CAF50), // Green
    const Color(0xFF9C27B0), // Purple
    const Color(0xFFFFEB3B), // Yellow
    const Color(0xFF795548), // Brown
    const Color(0xFF607D8B), // Blue Grey
    const Color(0xFFF44336), // Red
    const Color(0xFF3F51B5), // Indigo
    const Color(0xFF009688), // Teal
    const Color(0xFFCDDC39), // Lime
    const Color(0xFFFFC107), // Amber
    const Color(0xFFFF5722), // Deep Orange
    const Color(0xFF673AB7), // Deep Purple
    const Color(0xFF03A9F4), // Light Blue
    const Color(0xFF8BC34A), // Light Green
    const Color(0xFFFFCDD2), // Red 100
    const Color(0xFFC5E1A5), // Light Green 100
  ];

  @override
  void initState() {
    super.initState();
    controller = Get.put(
      BarChartController(),
      tag: 'bar_chart_${widget.key ?? DateTime.now().millisecondsSinceEpoch}',
    );

    if (widget.initialData != null) {
      controller.chartData.value = widget.initialData;
    } else if (widget.fetchData != null && widget.actions.isNotEmpty) {
      final selectedAction = widget.actions.firstWhere(
        (a) => a.isSelected,
        orElse: () => widget.actions.first,
      );
      _loadData(selectedAction.title.toLowerCase());
    }
  }

  @override
  void dispose() {
    Get.delete<BarChartController>(
      tag: 'bar_chart_${widget.key ?? DateTime.now().millisecondsSinceEpoch}',
    );
    super.dispose();
  }

  void _loadData(String period) {
    if (widget.fetchData != null) {
      controller.loadData(
        fetchData: widget.fetchData!,
        period: period,
        onPeriodChange: widget.onPeriodChange,
        onDataLoaded: widget.onDataLoaded,
        onError: widget.onError,
      );
    }
  }

  void _zoomIn() {
    setState(() {
      _currentZoom =
          (_currentZoom + 25.0).clamp(widget.minZoom, widget.maxZoom);
    });
  }

  void _zoomOut() {
    setState(() {
      _currentZoom =
          (_currentZoom - 25.0).clamp(widget.minZoom, widget.maxZoom);
    });
  }

  void _resetZoom() {
    setState(() {
      _currentZoom = 100.0;
    });
  }

  Color _getBarColor(int index) {
    final colors = widget.customColors ?? defaultColors;
    return colors[index % colors.length];
  }

  String _formatValue(double value, String unit, UnitPosition position) {
    final formatter = NumberFormat.decimalPattern('pt_BR');
    final formatted = formatter.format(value);

    if (unit.isEmpty) {
      return formatted;
    }

    // Adiciona espaço entre unidade e valor
    return position == UnitPosition.left
        ? '$unit $formatted'
        : '$formatted $unit';
  }

  Widget _buildZoomControls(ThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Zoom Out (-)
        _buildZoomButton(
          icon: Icons.remove,
          onTap: _zoomOut,
          enabled: _currentZoom > widget.minZoom,
          theme: theme,
          isDark: isDark,
        ),
        const SizedBox(width: 4),
        // Reset Zoom ([])
        _buildZoomButton(
          icon: Icons.crop_free,
          onTap: _resetZoom,
          enabled: _currentZoom != 100.0,
          theme: theme,
          isDark: isDark,
        ),
        const SizedBox(width: 4),
        // Zoom In (+)
        _buildZoomButton(
          icon: Icons.add,
          onTap: _zoomIn,
          enabled: _currentZoom < widget.maxZoom,
          theme: theme,
          isDark: isDark,
        ),
      ],
    );
  }

  Widget _buildZoomButton({
    required IconData icon,
    required VoidCallback onTap,
    required bool enabled,
    required ThemeData theme,
    required bool isDark,
  }) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: enabled
            ? (isDark ? Colors.grey[800] : Colors.grey[100])
            : (isDark ? Colors.grey[850] : Colors.grey[50]),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: enabled ? onTap : null,
          borderRadius: BorderRadius.circular(6),
          child: Icon(
            icon,
            size: 16,
            color: enabled
                ? (isDark ? Colors.white : Colors.black87)
                : (isDark ? Colors.grey[600] : Colors.grey[400]),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: widget.padding ?? const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900] : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(theme),
          const SizedBox(height: 24),
          Obx(() => _buildContent(theme)),
          if (widget.footer != null) ...[
            const SizedBox(height: 16),
            widget.footer!,
          ],
          if (widget.enableFooter) ...[
            const SizedBox(height: 16),
            _buildInteractiveFooter(theme),
          ],
        ],
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 768;

        if (isMobile) {
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Center(
                      child: Text(
                        widget.title,
                        style: widget.titleStyle ??
                            theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                  ),
                  if (widget.enableZoom) _buildZoomControls(theme),
                ],
              ),
              if (widget.actions.isNotEmpty) ...[
                const SizedBox(height: 16),
                _buildActionButtons(theme),
              ],
            ],
          );
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Center(
                child: Text(
                  widget.title,
                  style: widget.titleStyle ??
                      theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.enableZoom) _buildZoomControls(theme),
                if (widget.actions.isNotEmpty) ...[
                  if (widget.enableZoom) const SizedBox(width: 16),
                  _buildActionButtons(theme),
                ],
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildActionButtons(ThemeData theme) {
    return Obx(() {
      final isLoading = controller.isLoading.value;
      final isDark = theme.brightness == Brightness.dark;

      return Row(
        mainAxisSize: MainAxisSize.min,
        children: widget.actions.map((action) {
          final isSelected =
              controller.selectedPeriod.value == action.title.toLowerCase();

          // Determina as cores baseado no tema e nas customizações
          final backgroundColor = _getButtonBackgroundColor(
            isSelected,
            isDark,
            theme,
          );

          final textColor = _getButtonTextColor(
            isSelected,
            isDark,
            theme,
          );

          final borderColor = _getButtonBorderColor(
            isSelected,
            isDark,
            theme,
          );

          return Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Container(
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: borderColor,
                  width: 1,
                ),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: isLoading
                      ? null
                      : () {
                          _loadData(action.title.toLowerCase());
                          action.onPressed();
                        },
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Text(
                      action.title,
                      style: action.textStyle ??
                          TextStyle(
                            color: textColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      );
    });
  }

  // Métodos auxiliares para determinar as cores dos botões
  Color _getButtonBackgroundColor(
      bool isSelected, bool isDark, ThemeData theme) {
    if (isSelected) {
      return isDark
          ? (widget.darkSelectedBackgroundColor ?? theme.primaryColor)
          : (widget.lightSelectedBackgroundColor ?? theme.primaryColor);
    } else {
      return isDark
          ? (widget.darkUnselectedBackgroundColor ??
              theme.primaryColor.withValues(alpha: 0.2))
          : (widget.lightUnselectedBackgroundColor ??
              theme.primaryColor.withValues(alpha: 0.1));
    }
  }

  Color _getButtonTextColor(bool isSelected, bool isDark, ThemeData theme) {
    if (isSelected) {
      return isDark
          ? (widget.darkSelectedTextColor ?? Colors.white)
          : (widget.lightSelectedTextColor ?? Colors.white);
    } else {
      return isDark
          ? (widget.darkUnselectedTextColor ??
              theme.primaryColor.withValues(alpha: 0.9))
          : (widget.lightUnselectedTextColor ?? theme.primaryColor);
    }
  }

  Color _getButtonBorderColor(bool isSelected, bool isDark, ThemeData theme) {
    if (isSelected) {
      return Colors.transparent;
    } else {
      return isDark
          ? (widget.darkBorderColor ??
              theme.primaryColor.withValues(alpha: 0.3))
          : (widget.lightBorderColor ??
              theme.primaryColor.withValues(alpha: 0.2));
    }
  }

  Widget _buildContent(ThemeData theme) {
    if (controller.isLoading.value) {
      return _buildLoadingState(theme);
    }

    if (controller.hasError.value) {
      return _buildErrorState(theme);
    }

    final data = controller.chartData.value;
    if (data == null || data.data.isEmpty) {
      return _buildEmptyState(theme);
    }

    // Se o footer interativo estiver habilitado, filtra apenas os itens visíveis
    List<ModChartDataItem> itemsToShow = data.data;
    if (widget.enableFooter) {
      _initializeItemVisibility(data.data);
      itemsToShow = _getVisibleItems(data.data);
      
      // Se todos os itens estão ocultos, mostra estado vazio personalizado
      if (itemsToShow.isEmpty) {
        return _buildCustomEmptyState(theme);
      }
    }

    // Cria dados filtrados para renderização
    final filteredData = ModChartData(
      title: data.title,
      period: data.period,
      unit: data.unit,
      unitPosition: data.unitPosition,
      updatedAt: data.updatedAt,
      data: itemsToShow,
      maxHint: data.maxHint,
    );

    return _buildChart(filteredData, theme);
  }

  Widget _buildLoadingState(ThemeData theme) {
    return Column(
      children: List.generate(4, (index) {
        return Padding(
          padding: EdgeInsets.only(bottom: widget.barSpacing),
          child: Row(
            children: [
              Container(
                width: 80,
                height: 20,
                decoration: BoxDecoration(
                  color: theme.dividerColor.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Container(
                  height: widget.barHeight,
                  decoration: BoxDecoration(
                    color: theme.dividerColor.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(widget.barRadius),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildErrorState(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 48,
            color: theme.colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text(
            'Erro ao carregar dados',
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            controller.errorMessage.value,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.textTheme.bodySmall?.color,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              if (widget.fetchData != null) {
                controller.retry(
                  fetchData: widget.fetchData!,
                  onPeriodChange: widget.onPeriodChange,
                  onDataLoaded: widget.onDataLoaded,
                  onError: widget.onError,
                );
              }
            },
            child: const Text('Tentar novamente'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.bar_chart,
            size: 48,
            color: theme.dividerColor,
          ),
          const SizedBox(height: 16),
          Text(
            'Sem dados para o período selecionado',
            style: theme.textTheme.titleMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildCustomEmptyState(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            widget.emptyStateIcon ?? Icons.visibility_off,
            size: 48,
            color: theme.dividerColor,
          ),
          const SizedBox(height: 16),
          Text(
            widget.emptyStateTitle ?? 'Nenhum item selecionado',
            style: theme.textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Clique nos itens da legenda para exibi-los no gráfico',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.textTheme.bodySmall?.color,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildChart(ModChartData data, ThemeData theme) {
    final maxValue = _calculateMaxValue(data);

    return widget.orientation == BarChartOrientation.horizontal
        ? _buildHorizontalChart(data, theme, maxValue)
        : _buildVerticalChart(data, theme, maxValue);
  }

  Widget _buildHorizontalChart(
      ModChartData data, ThemeData theme, double maxValue) {
    final zoomFactor = widget.enableZoom ? _currentZoom / 100.0 : 1.0;

    Widget chartContent = Column(
      children: [
        ...data.data.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          return Padding(
            padding: EdgeInsets.only(bottom: widget.barSpacing),
            child: _buildHorizontalBarRow(item, index, maxValue, theme),
          );
        }),
      ],
    );

    if (!widget.enableZoom) {
      // Sem zoom - layout simples
      return Container(
        height: widget.chartContainerHeight,
        decoration: BoxDecoration(
          border: Border.all(
            color: theme.dividerColor.withValues(alpha: 0.2),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            padding: const EdgeInsets.all(16),
            child: chartContent,
          ),
        ),
      );
    }

    // Com zoom - layout com dimensões calculadas
    if (widget.barChartWidth == null) {
      // Largura automática - sem scroll horizontal, apenas vertical se necessário
      final itemHeight = (widget.barHeight + widget.barSpacing);
      final baseHeight =
          itemHeight * data.data.length + 32; // incluindo padding
      final scaledHeight = math.max(baseHeight, baseHeight * zoomFactor);

      return Container(
        height: widget.chartContainerHeight,
        decoration: BoxDecoration(
          border: Border.all(
            color: theme.dividerColor.withValues(alpha: 0.2),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            height: scaledHeight,
            padding: const EdgeInsets.all(16),
            child: Transform.scale(
              scale: zoomFactor,
              alignment: Alignment.topLeft,
              child: chartContent,
            ),
          ),
        ),
      );
    }

    // Largura fixa - com scroll horizontal e vertical
    final baseWidth = 116 + widget.barChartWidth! + 32; // incluindo padding
    final scaledWidth =
        math.max(baseWidth, baseWidth * zoomFactor); // Garante largura mínima
    final itemHeight = (widget.barHeight + widget.barSpacing);
    final baseHeight = itemHeight * data.data.length + 32; // incluindo padding
    final scaledHeight =
        math.max(baseHeight, baseHeight * zoomFactor); // Garante altura mínima

    // Container com scroll horizontal e vertical
    return Container(
      height: widget.chartContainerHeight, // Altura configurável
      decoration: BoxDecoration(
        border: Border.all(
          color: theme.dividerColor.withValues(alpha: 0.2),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(
            width: scaledWidth,
            height: scaledHeight,
            padding: const EdgeInsets.all(16),
            child: Transform.scale(
              scale: zoomFactor,
              alignment: Alignment.topLeft,
              child: chartContent,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVerticalChart(ModChartData data, ThemeData theme, double maxValue) {
    final zoomFactor = widget.enableZoom ? _currentZoom / 100.0 : 1.0;

    Widget chartContent = Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        ...data.data.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          return Padding(
            padding: EdgeInsets.only(right: widget.barSpacing),
            child: _buildVerticalBarColumn(item, index, maxValue, theme),
          );
        }),
      ],
    );

    if (!widget.enableZoom) {
      // Sem zoom - layout simples com scroll horizontal e largura total
      // Calcula largura necessária para todos os itens considerando labels
      final barWidth = widget.barHeight;
      final labelWidth = barWidth + 20; // Largura do label (conforme _buildVerticalBarColumn)
      final itemWidth = math.max(barWidth, labelWidth) + widget.barSpacing;
      final totalContentWidth = (itemWidth * data.data.length) + 32; // +32 for padding
      
      return Container(
        width: double.infinity, // Ocupa 100% da largura disponível
        height: widget.chartContainerHeight,
        decoration: BoxDecoration(
          border: Border.all(
            color: theme.dividerColor.withValues(alpha: 0.2),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(
            width: totalContentWidth,
            padding: const EdgeInsets.all(16),
            child: chartContent,
          ),
        ),
      );
    }

    // Com zoom - layout com dimensões calculadas
    const maxBarHeight = 200.0;
    const verticalSpacing = 60.0; // Space for labels above and below
    // Calcula largura necessária considerando labels (igual ao modo sem zoom)
    final barWidth = widget.barHeight;
    final labelWidth = barWidth + 20; // Largura do label (conforme _buildVerticalBarColumn)
    final itemWidth = math.max(barWidth, labelWidth) + widget.barSpacing;
    final baseWidth = itemWidth * data.data.length + 32; // incluindo padding
    final scaledWidth =
        math.max(baseWidth, baseWidth * zoomFactor); // Garante largura mínima
    final baseHeight = maxBarHeight + verticalSpacing + 32; // +32 for padding
    final scaledHeight =
        math.max(baseHeight, baseHeight * zoomFactor); // Garante altura mínima

    // Container com scroll horizontal e vertical
    return Container(
      width: double.infinity, // Ocupa 100% da largura disponível
      height: widget.chartContainerHeight, // Altura configurável
      decoration: BoxDecoration(
        border: Border.all(
          color: theme.dividerColor.withValues(alpha: 0.2),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(
            width: scaledWidth,
            height: scaledHeight,
            padding: const EdgeInsets.all(16),
            child: Transform.scale(
              scale: zoomFactor,
              alignment: Alignment.bottomLeft,
              child: chartContent,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHorizontalBarRow(
    ModChartDataItem item,
    int index,
    double maxValue,
    ThemeData theme,
  ) {
    final percentage = maxValue > 0 ? item.value / maxValue : 0.0;
    final color = item.color ?? _getBarColor(index);
    final chartData = controller.chartData.value;
    final formattedValue = _formatValue(
      item.value,
      chartData?.unit ?? '',
      chartData?.unitPosition ?? UnitPosition.right,
    );

    return Row(
      children: [
        SizedBox(
          width: 100,
          child: Text(
            item.label,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 16),
        widget.barChartWidth != null
            ? SizedBox(
                width: widget.barChartWidth, // Largura fixa configurável
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final barWidth = constraints.maxWidth * percentage;
                    final showLabelOutside = barWidth < 50;

                    return Stack(
                      clipBehavior: Clip.none,
                      children: [
                        _HoverableBar(
                          item: item,
                          color: color,
                          width: barWidth,
                          height: widget.barHeight,
                          radius: widget.barRadius,
                          formattedValue: formattedValue,
                          showValueLabels:
                              !showLabelOutside && widget.showValueLabels,
                          showTooltip: widget.showTooltip,
                          onTap: widget.onBarClick != null
                              ? () => widget.onBarClick?.call(item)
                              : null,
                          isHorizontal: true,
                        ),
                        if (showLabelOutside && widget.showValueLabels)
                          Positioned(
                            left: barWidth + 8,
                            top: 0,
                            bottom: 0,
                            child: Center(
                              child: Text(
                                formattedValue,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              )
            : Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final barWidth = constraints.maxWidth * percentage;
                    final showLabelOutside = barWidth < 50;

                    return Stack(
                      clipBehavior: Clip.none,
                      children: [
                        _HoverableBar(
                          item: item,
                          color: color,
                          width: barWidth,
                          height: widget.barHeight,
                          radius: widget.barRadius,
                          formattedValue: formattedValue,
                          showValueLabels:
                              !showLabelOutside && widget.showValueLabels,
                          showTooltip: widget.showTooltip,
                          onTap: widget.onBarClick != null
                              ? () => widget.onBarClick?.call(item)
                              : null,
                          isHorizontal: true,
                        ),
                        if (showLabelOutside && widget.showValueLabels)
                          Positioned(
                            left: barWidth + 8,
                            top: 0,
                            bottom: 0,
                            child: Center(
                              child: Text(
                                formattedValue,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
      ],
    );
  }

  double _calculateMaxValue(ModChartData data) {
    if (data.data.isEmpty) return 0;

    final maxDataValue =
        data.data.map((e) => e.value).reduce((a, b) => math.max(a, b));

    if (data.maxHint != null) {
      return math.max(maxDataValue, data.maxHint!);
    }

    return maxDataValue * 1.1; // Add 10% padding
  }

  Widget _buildVerticalBarColumn(
    ModChartDataItem item,
    int index,
    double maxValue,
    ThemeData theme,
  ) {
    final percentage = maxValue > 0 ? item.value / maxValue : 0.0;
    final color = item.color ?? _getBarColor(index);
    final chartData = controller.chartData.value;
    final formattedValue = _formatValue(
      item.value,
      chartData?.unit ?? '',
      chartData?.unitPosition ?? UnitPosition.right,
    );

    const maxBarHeight = 200.0; // Altura máxima das barras verticais
    final barHeight = maxBarHeight * percentage;
    final barWidth =
        widget.barHeight; // Usar barHeight como largura da barra vertical

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Label do valor acima da barra
        if (widget.showValueLabels)
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            child: Text(
              formattedValue,
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        // Barra vertical com hover
        _HoverableBar(
          item: item,
          color: color,
          width: barWidth,
          height: barHeight,
          radius: widget.barRadius,
          formattedValue: formattedValue,
          showValueLabels: false, // Valor mostrado acima
          showTooltip: widget.showTooltip,
          onTap: widget.onBarClick != null
              ? () => widget.onBarClick?.call(item)
              : null,
          isHorizontal: false,
        ),
        // Label do item abaixo da barra
        Container(
          width: barWidth + 20, // Pouco mais largo que a barra
          margin: const EdgeInsets.only(top: 8),
          child: Text(
            item.label,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  // Inicializa a visibilidade de todos os itens como true
  void _initializeItemVisibility(List<ModChartDataItem> items) {
    for (var item in items) {
      if (!_itemVisibility.containsKey(item.label)) {
        _itemVisibility[item.label] = true;
      }
    }
  }

  // Retorna apenas os itens visíveis
  List<ModChartDataItem> _getVisibleItems(List<ModChartDataItem> items) {
    return items.where((item) => _itemVisibility[item.label] == true).toList();
  }

  // Constrói o footer interativo com legenda
  Widget _buildInteractiveFooter(ThemeData theme) {
    final chartData = controller.chartData.value;
    if (chartData == null) return const SizedBox.shrink();

    final items = chartData.data;
    _initializeItemVisibility(items);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainer.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: theme.dividerColor.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Wrap(
            spacing: 12,
            runSpacing: 8,
            children: items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final color = _getBarColor(index);
              final isVisible = _itemVisibility[item.label] ?? true;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _itemVisibility[item.label] = !isVisible;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: isVisible 
                        ? color.withValues(alpha: 0.1) 
                        : Colors.grey.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isVisible 
                          ? color 
                          : Colors.grey.withValues(alpha: 0.5),
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: isVisible 
                              ? color 
                              : Colors.grey.withValues(alpha: 0.5),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        item.label,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: isVisible 
                              ? theme.textTheme.bodySmall?.color
                              : Colors.grey,
                          fontWeight: isVisible 
                              ? FontWeight.w600 
                              : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }
}
