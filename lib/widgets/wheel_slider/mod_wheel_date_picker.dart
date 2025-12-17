import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'mod_wheel_slider.dart';

/// Enum representing the type of date picker.
enum ModWheelDatePickerType {
  /// Full date picker with day, month, and year.
  dayMonthYear,

  /// Date picker with month and year only.
  monthYear,

  /// Date picker with year only.
  yearOnly,
}

/// Controller for externally managing a [ModWheelDatePicker] using GetX.
///
/// Provides reactive variables and methods to programmatically set the date.
class ModWheelDatePickerController extends GetxController {
  /// Reactive year value.
  final RxInt year;

  /// Reactive month value (1-12).
  final RxInt month;

  /// Reactive day value (1-31).
  final RxInt day;

  /// Creates a controller with an optional initial date.
  ModWheelDatePickerController({DateTime? initialDate})
      : year = (initialDate?.year ?? DateTime.now().year).obs,
        month = (initialDate?.month ?? DateTime.now().month).obs,
        day = (initialDate?.day ?? DateTime.now().day).obs;

  /// The current selected date.
  DateTime get date => DateTime(year.value, month.value, day.value);

  /// Sets the complete date.
  void setDate(DateTime newDate) {
    year.value = newDate.year;
    month.value = newDate.month;
    final daysInMonth = DateTime(newDate.year, newDate.month + 1, 0).day;
    day.value = newDate.day.clamp(1, daysInMonth);
  }

  /// Sets only the day value.
  void setDay(int newDay) {
    final daysInMonth = DateTime(year.value, month.value + 1, 0).day;
    day.value = newDay.clamp(1, daysInMonth);
  }

  /// Sets only the month value.
  void setMonth(int newMonth) {
    final validMonth = newMonth.clamp(1, 12);
    month.value = validMonth;
    final daysInMonth = DateTime(year.value, validMonth + 1, 0).day;
    day.value = day.value.clamp(1, daysInMonth);
  }

  /// Sets only the year value.
  void setYear(int newYear) {
    year.value = newYear;
    final daysInMonth = DateTime(newYear, month.value + 1, 0).day;
    day.value = day.value.clamp(1, daysInMonth);
  }

  /// Returns the number of days in the current month.
  int get daysInCurrentMonth => DateTime(year.value, month.value + 1, 0).day;
}

/// A customizable wheel-based date picker widget.
///
/// Supports different modes: full date (day/month/year), month/year only, or year only.
class ModWheelDatePicker extends StatefulWidget {
  /// The type of date picker to display.
  final ModWheelDatePickerType type;

  /// The initial date to display.
  final DateTime? initialDate;

  /// External controller for programmatically setting the date.
  final ModWheelDatePickerController? controller;

  /// Callback function that is triggered when the date changes.
  final ValueChanged<DateTime>? onDateChanged;

  /// The minimum year to display in the year picker.
  final int minYear;

  /// The maximum year to display in the year picker.
  final int maxYear;

  /// Height of the date picker.
  final double height;

  /// Width of the date picker. If null, uses available width.
  final double? width;

  /// Text style for the selected item.
  final TextStyle? selectedStyle;

  /// Text style for unselected items.
  final TextStyle? unselectedStyle;

  /// Whether to show a divider between wheels.
  final bool showDividers;

  /// The color of the dividers.
  final Color? dividerColor;

  /// Background color of the picker.
  final Color? backgroundColor;

  /// Border radius of the picker container.
  final BorderRadius? borderRadius;

  /// Enables or disables haptic feedback.
  final bool enableHapticFeedback;

  /// Type of haptic feedback to be used.
  final ModHapticFeedbackType hapticFeedbackType;

  /// Whether to use short month names (e.g., "Jan" instead of "January").
  final bool useShortMonthNames;

  /// Custom month names. If null, uses default names based on locale.
  final List<String>? customMonthNames;

  /// Size of each item in the wheel.
  final double itemSize;

  /// Enables or disables animation for initial value display.
  final bool enableAnimation;

  /// Duration of the animation for initial value display.
  final Duration animationDuration;

  /// Whether to order as day-month-year (true) or month-day-year (false).
  final bool dayMonthYearOrder;

  const ModWheelDatePicker({
    super.key,
    this.type = ModWheelDatePickerType.dayMonthYear,
    this.initialDate,
    this.controller,
    this.onDateChanged,
    this.minYear = 1900,
    this.maxYear = 2100,
    this.height = 150,
    this.width,
    this.selectedStyle,
    this.unselectedStyle,
    this.showDividers = false,
    this.dividerColor,
    this.backgroundColor,
    this.borderRadius,
    this.enableHapticFeedback = true,
    this.hapticFeedbackType = ModHapticFeedbackType.vibrate,
    this.useShortMonthNames = false,
    this.customMonthNames,
    this.itemSize = 40,
    this.enableAnimation = true,
    this.animationDuration = const Duration(milliseconds: 500),
    this.dayMonthYearOrder = true,
  });

  /// Creates a date picker with day, month, and year wheels.
  const ModWheelDatePicker.dayMonthYear({
    super.key,
    this.initialDate,
    this.controller,
    this.onDateChanged,
    this.minYear = 1900,
    this.maxYear = 2100,
    this.height = 150,
    this.width,
    this.selectedStyle,
    this.unselectedStyle,
    this.showDividers = false,
    this.dividerColor,
    this.backgroundColor,
    this.borderRadius,
    this.enableHapticFeedback = true,
    this.hapticFeedbackType = ModHapticFeedbackType.vibrate,
    this.useShortMonthNames = false,
    this.customMonthNames,
    this.itemSize = 40,
    this.enableAnimation = true,
    this.animationDuration = const Duration(milliseconds: 500),
    this.dayMonthYearOrder = true,
  }) : type = ModWheelDatePickerType.dayMonthYear;

  /// Creates a date picker with month and year wheels only.
  const ModWheelDatePicker.monthYear({
    super.key,
    this.initialDate,
    this.controller,
    this.onDateChanged,
    this.minYear = 1900,
    this.maxYear = 2100,
    this.height = 150,
    this.width,
    this.selectedStyle,
    this.unselectedStyle,
    this.showDividers = false,
    this.dividerColor,
    this.backgroundColor,
    this.borderRadius,
    this.enableHapticFeedback = true,
    this.hapticFeedbackType = ModHapticFeedbackType.vibrate,
    this.useShortMonthNames = false,
    this.customMonthNames,
    this.itemSize = 40,
    this.enableAnimation = true,
    this.animationDuration = const Duration(milliseconds: 500),
  })  : type = ModWheelDatePickerType.monthYear,
        dayMonthYearOrder = true;

  /// Creates a date picker with year wheel only.
  const ModWheelDatePicker.yearOnly({
    super.key,
    this.initialDate,
    this.controller,
    this.onDateChanged,
    this.minYear = 1900,
    this.maxYear = 2100,
    this.height = 150,
    this.width,
    this.selectedStyle,
    this.unselectedStyle,
    this.backgroundColor,
    this.borderRadius,
    this.enableHapticFeedback = true,
    this.hapticFeedbackType = ModHapticFeedbackType.vibrate,
    this.itemSize = 40,
    this.enableAnimation = true,
    this.animationDuration = const Duration(milliseconds: 500),
  })  : type = ModWheelDatePickerType.yearOnly,
        showDividers = false,
        dividerColor = null,
        useShortMonthNames = false,
        customMonthNames = null,
        dayMonthYearOrder = true;

  @override
  State<ModWheelDatePicker> createState() => _ModWheelDatePickerState();
}

class _ModWheelDatePickerState extends State<ModWheelDatePicker> {
  late ModWheelDatePickerController _internalController;
  late FixedExtentScrollController _dayController;
  late FixedExtentScrollController _monthController;
  late FixedExtentScrollController _yearController;

  // Workers for reactive subscriptions
  Worker? _yearWorker;
  Worker? _monthWorker;
  Worker? _dayWorker;

  // Scroll threshold for triggering a scroll (Windows typically sends 120 per notch)
  static const double _scrollThreshold = 50.0;

  static const List<String> _defaultMonthNames = [
    'Janeiro',
    'Fevereiro',
    'Março',
    'Abril',
    'Maio',
    'Junho',
    'Julho',
    'Agosto',
    'Setembro',
    'Outubro',
    'Novembro',
    'Dezembro',
  ];

  static const List<String> _defaultShortMonthNames = [
    'Jan',
    'Fev',
    'Mar',
    'Abr',
    'Mai',
    'Jun',
    'Jul',
    'Ago',
    'Set',
    'Out',
    'Nov',
    'Dez',
  ];

  List<String> get _monthNames {
    if (widget.customMonthNames != null && widget.customMonthNames!.length == 12) {
      return widget.customMonthNames!;
    }
    return widget.useShortMonthNames ? _defaultShortMonthNames : _defaultMonthNames;
  }

  ModWheelDatePickerController get _controller =>
      widget.controller ?? _internalController;

  int get _daysInCurrentMonth => _controller.daysInCurrentMonth;

  int get _yearCount => widget.maxYear - widget.minYear + 1;

  @override
  void initState() {
    super.initState();
    final initialDate = widget.controller?.date ?? widget.initialDate ?? DateTime.now();
    _internalController = ModWheelDatePickerController(initialDate: initialDate);
    _initControllers();
    _setupReactiveListeners();
  }

  void _initControllers() {
    _dayController = FixedExtentScrollController(initialItem: _controller.day.value - 1);
    _monthController = FixedExtentScrollController(initialItem: _controller.month.value - 1);
    _yearController = FixedExtentScrollController(
      initialItem: _controller.year.value - widget.minYear,
    );
  }

  void _setupReactiveListeners() {
    // Listen to external controller changes (when using widget.controller)
    if (widget.controller != null) {
      _yearWorker = ever(widget.controller!.year, (int year) {
        if (!mounted) return;
        _animateToYear(year);
      });
      _monthWorker = ever(widget.controller!.month, (int month) {
        if (!mounted) return;
        _animateToMonth(month);
        _adjustDayIfNeeded();
      });
      _dayWorker = ever(widget.controller!.day, (int day) {
        if (!mounted) return;
        _animateToDay(day);
      });
    }
  }

  void _disposeWorkers() {
    _yearWorker?.dispose();
    _monthWorker?.dispose();
    _dayWorker?.dispose();
  }

  @override
  void didUpdateWidget(ModWheelDatePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      _disposeWorkers();
      _setupReactiveListeners();
    }
  }

  @override
  void dispose() {
    _disposeWorkers();
    _dayController.dispose();
    _monthController.dispose();
    _yearController.dispose();
    super.dispose();
  }

  void _animateToYear(int year) {
    if (_yearController.hasClients) {
      final targetIndex = year - widget.minYear;
      if (_yearController.selectedItem != targetIndex) {
        _yearController.animateToItem(
          targetIndex,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    }
  }

  void _animateToMonth(int month) {
    if (_monthController.hasClients) {
      final targetIndex = month - 1;
      if (_monthController.selectedItem != targetIndex) {
        _monthController.animateToItem(
          targetIndex,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    }
  }

  void _animateToDay(int day) {
    if (_dayController.hasClients) {
      final targetIndex = day - 1;
      if (_dayController.selectedItem != targetIndex) {
        _dayController.animateToItem(
          targetIndex,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    }
  }

  void _adjustDayIfNeeded() {
    final daysInMonth = _daysInCurrentMonth;
    if (_controller.day.value > daysInMonth) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_dayController.hasClients) {
          _dayController.animateToItem(
            daysInMonth - 1,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  void _onDayChanged(int index) {
    final newDay = index + 1;
    final daysInMonth = _daysInCurrentMonth;
    final validDay = newDay.clamp(1, daysInMonth);
    _updateDate(day: validDay);
  }

  void _onMonthChanged(int index) {
    final newMonth = index + 1;
    _updateDate(month: newMonth);
  }

  void _onYearChanged(int index) {
    final newYear = widget.minYear + index;
    _updateDate(year: newYear);
  }

  void _updateDate({int? day, int? month, int? year}) {
    final newYear = year ?? _controller.year.value;
    final newMonth = month ?? _controller.month.value;
    final daysInMonth = DateTime(newYear, newMonth + 1, 0).day;
    final newDay = (day ?? _controller.day.value).clamp(1, daysInMonth);

    final currentDate = _controller.date;
    final newDate = DateTime(newYear, newMonth, newDay);

    if (currentDate != newDate) {
      // Update controller values
      _controller.year.value = newYear;
      _controller.month.value = newMonth;
      _controller.day.value = newDay;

      widget.onDateChanged?.call(newDate);

      // Adjust day wheel if the new month has fewer days
      if (day == null && _controller.day.value > daysInMonth) {
        _adjustDayIfNeeded();
      }
    }
  }

  TextStyle get _selectedStyle =>
      widget.selectedStyle ??
      const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      );

  TextStyle get _unselectedStyle =>
      widget.unselectedStyle ??
      TextStyle(
        fontSize: 14,
        color: Colors.grey.shade600,
      );

  Widget _buildDayWheel() {
    return Expanded(
      child: _buildWheelPicker(
        controller: _dayController,
        itemCount: 31,
        onChanged: _onDayChanged,
        selectedValue: _controller.day,
        valueOffset: 1,
        itemBuilder: (index, isSelected) {
          final day = index + 1;
          return Obx(() {
            final isValid = day <= _daysInCurrentMonth;
            return Center(
              child: Text(
                day.toString().padLeft(2, '0'),
                style: isSelected
                    ? _selectedStyle
                    : _unselectedStyle.copyWith(
                        color: isValid ? null : Colors.grey.shade300,
                      ),
              ),
            );
          });
        },
      ),
    );
  }

  Widget _buildMonthWheel() {
    return Expanded(
      flex: widget.useShortMonthNames ? 1 : 2,
      child: _buildWheelPicker(
        controller: _monthController,
        itemCount: 12,
        onChanged: _onMonthChanged,
        selectedValue: _controller.month,
        valueOffset: 1,
        itemBuilder: (index, isSelected) {
          return Center(
            child: Text(
              _monthNames[index],
              style: isSelected ? _selectedStyle : _unselectedStyle,
            ),
          );
        },
      ),
    );
  }

  Widget _buildYearWheel() {
    return Expanded(
      child: _buildWheelPicker(
        controller: _yearController,
        itemCount: _yearCount,
        onChanged: _onYearChanged,
        selectedValue: _controller.year,
        valueOffset: widget.minYear,
        itemBuilder: (index, isSelected) {
          final year = widget.minYear + index;
          return Center(
            child: Text(
              year.toString(),
              style: isSelected ? _selectedStyle : _unselectedStyle,
            ),
          );
        },
      ),
    );
  }

  Widget _buildWheelPicker({
    required FixedExtentScrollController controller,
    required int itemCount,
    required ValueChanged<int> onChanged,
    required Widget Function(int index, bool isSelected) itemBuilder,
    required RxInt selectedValue,
    required int valueOffset,
  }) {
    return _WheelPickerWithDrag(
      controller: controller,
      itemCount: itemCount,
      itemSize: widget.itemSize,
      onChanged: onChanged,
      itemBuilder: itemBuilder,
      scrollThreshold: _scrollThreshold,
      selectedValue: selectedValue,
      valueOffset: valueOffset,
    );
  }

  Widget _buildDivider() {
    if (!widget.showDividers) return const SizedBox.shrink();
    return Container(
      width: 1,
      height: widget.height * 0.6,
      color: widget.dividerColor ?? Colors.grey.shade300,
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget content;
    switch (widget.type) {
      case ModWheelDatePickerType.dayMonthYear:
        if (widget.dayMonthYearOrder) {
          content = Row(
            children: [
              _buildDayWheel(),
              _buildDivider(),
              _buildMonthWheel(),
              _buildDivider(),
              _buildYearWheel(),
            ],
          );
        } else {
          content = Row(
            children: [
              _buildMonthWheel(),
              _buildDivider(),
              _buildDayWheel(),
              _buildDivider(),
              _buildYearWheel(),
            ],
          );
        }
        break;
      case ModWheelDatePickerType.monthYear:
        content = Row(
          children: [
            _buildMonthWheel(),
            _buildDivider(),
            _buildYearWheel(),
          ],
        );
        break;
      case ModWheelDatePickerType.yearOnly:
        content = _buildYearWheel();
        break;
    }

    return Container(
      height: widget.height,
      width: widget.width,
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: widget.borderRadius,
      ),
      child: content,
    );
  }
}

/// A helper widget that adds mouse scroll handling, drag-and-drop support,
/// and click-to-select functionality (Windows/Web) to the wheel picker.
class _WheelPickerWithDrag extends StatefulWidget {
  final FixedExtentScrollController controller;
  final int itemCount;
  final double itemSize;
  final ValueChanged<int> onChanged;
  final Widget Function(int index, bool isSelected) itemBuilder;
  final double scrollThreshold;
  final RxInt selectedValue;
  final int valueOffset;

  const _WheelPickerWithDrag({
    required this.controller,
    required this.itemCount,
    required this.itemSize,
    required this.onChanged,
    required this.itemBuilder,
    required this.scrollThreshold,
    required this.selectedValue,
    this.valueOffset = 0,
  });

  @override
  State<_WheelPickerWithDrag> createState() => _WheelPickerWithDragState();
}

class _WheelPickerWithDragState extends State<_WheelPickerWithDrag> {
  // For mouse scroll handling on Windows
  double _accumulatedScrollDelta = 0;

  // For drag-and-drop functionality
  bool _isDragging = false;
  double _dragStartY = 0;
  int _dragStartIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(_WheelPickerWithDrag oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    super.dispose();
  }

  /// Returns true if click-to-select should be enabled (Windows or Web only)
  bool get _isClickToSelectEnabled {
    if (kIsWeb) return true;
    try {
      return Platform.isWindows;
    } catch (_) {
      return false;
    }
  }

  /// Handles tap on an item to select it directly (Windows/Web only)
  void _onItemTap(int index) {
    if (!_isClickToSelectEnabled) return;
    final currentSelectedIndex = widget.selectedValue.value - widget.valueOffset;
    if (index == currentSelectedIndex) return;
    if (!widget.controller.hasClients) return;

    final int clampedIndex = index.clamp(0, widget.itemCount - 1);

    widget.controller.animateToItem(
      clampedIndex,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
    );
  }

  void _handlePointerSignal(PointerSignalEvent event) {
    if (event is PointerScrollEvent && widget.controller.hasClients) {
      // Accumulate scroll delta to handle high-resolution scroll devices
      _accumulatedScrollDelta += event.scrollDelta.dy;

      // Only trigger a scroll when we've accumulated enough delta
      if (_accumulatedScrollDelta.abs() >= widget.scrollThreshold) {
        // Determine direction: positive delta = scroll down = increase index
        final int direction = _accumulatedScrollDelta > 0 ? 1 : -1;

        // Reset accumulated delta after triggering
        _accumulatedScrollDelta = 0;

        final int currentIndex = widget.controller.selectedItem;
        final int targetIndex = (currentIndex + direction).clamp(0, widget.itemCount - 1);

        widget.controller.animateToItem(
          targetIndex,
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeOut,
        );
      }
    }
  }

  void _handlePointerDown(PointerDownEvent event) {
    // Only handle mouse events (not touch)
    if (event.kind == PointerDeviceKind.mouse) {
      setState(() {
        _isDragging = true;
      });
      _dragStartY = event.position.dy;
      _dragStartIndex = widget.controller.selectedItem;
    }
  }

  void _handlePointerMove(PointerMoveEvent event) {
    if (!_isDragging || !widget.controller.hasClients) return;

    // Calculate drag delta (vertical only for date picker)
    final double dragDelta = event.position.dy - _dragStartY;

    // Calculate how many items to move based on drag distance
    // Use a sensitivity factor to make dragging feel more natural
    final double sensitivity = widget.itemSize * 0.8;
    final int itemsToMove = (dragDelta / sensitivity).round();
    final int targetIndex = _dragStartIndex + itemsToMove;

    // Clamp index
    final int clampedIndex = targetIndex.clamp(0, widget.itemCount - 1);

    if (clampedIndex != widget.controller.selectedItem) {
      widget.controller.jumpToItem(clampedIndex);
    }
  }

  void _handlePointerUp(PointerUpEvent event) {
    if (_isDragging) {
      setState(() {
        _isDragging = false;
      });
    }
  }

  void _handlePointerCancel(PointerCancelEvent event) {
    if (_isDragging) {
      setState(() {
        _isDragging = false;
      });
    }
  }

  Widget _buildItem(BuildContext context, int index) {
    // Use Obx to rebuild when selectedValue changes
    return Obx(() {
      final selectedIndex = widget.selectedValue.value - widget.valueOffset;
      final isSelected = selectedIndex == index;
      final itemWidget = widget.itemBuilder(index, isSelected);

      // Wrap with GestureDetector for click-to-select on Windows/Web
      if (_isClickToSelectEnabled) {
        return GestureDetector(
          onTap: () => _onItemTap(index),
          behavior: HitTestBehavior.opaque,
          child: MouseRegion(
            cursor: isSelected
                ? SystemMouseCursors.basic
                : SystemMouseCursors.click,
            child: itemWidget,
          ),
        );
      }

      return itemWidget;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerSignal: _handlePointerSignal,
      onPointerDown: _handlePointerDown,
      onPointerMove: _handlePointerMove,
      onPointerUp: _handlePointerUp,
      onPointerCancel: _handlePointerCancel,
      child: MouseRegion(
        cursor: _isDragging ? SystemMouseCursors.grabbing : SystemMouseCursors.grab,
        child: ListWheelScrollView.useDelegate(
          controller: widget.controller,
          itemExtent: widget.itemSize,
          perspective: 0.005,
          diameterRatio: 1.5,
          physics: const FixedExtentScrollPhysics(),
          onSelectedItemChanged: widget.onChanged,
          childDelegate: ListWheelChildBuilderDelegate(
            childCount: widget.itemCount,
            builder: _buildItem,
          ),
        ),
      ),
    );
  }
}
