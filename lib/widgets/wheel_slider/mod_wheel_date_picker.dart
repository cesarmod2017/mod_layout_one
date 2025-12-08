import 'package:flutter/material.dart';
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

/// Controller for externally managing a [ModWheelDatePicker].
///
/// Provides methods to programmatically set the date and listen to date changes.
class ModWheelDatePickerController extends ChangeNotifier {
  DateTime _date;

  /// Creates a controller with an optional initial date.
  ModWheelDatePickerController({DateTime? initialDate})
      : _date = initialDate ?? DateTime.now();

  /// The current selected date.
  DateTime get date => _date;

  /// Sets the date and notifies listeners.
  set date(DateTime newDate) {
    if (_date != newDate) {
      _date = newDate;
      notifyListeners();
    }
  }

  /// Programmatically sets the date.
  void setDate(DateTime newDate) {
    date = newDate;
  }

  /// Sets only the day value.
  void setDay(int day) {
    final daysInMonth = DateTime(_date.year, _date.month + 1, 0).day;
    final validDay = day.clamp(1, daysInMonth);
    date = DateTime(_date.year, _date.month, validDay);
  }

  /// Sets only the month value.
  void setMonth(int month) {
    final validMonth = month.clamp(1, 12);
    final daysInMonth = DateTime(_date.year, validMonth + 1, 0).day;
    final validDay = _date.day.clamp(1, daysInMonth);
    date = DateTime(_date.year, validMonth, validDay);
  }

  /// Sets only the year value.
  void setYear(int year) {
    final daysInMonth = DateTime(year, _date.month + 1, 0).day;
    final validDay = _date.day.clamp(1, daysInMonth);
    date = DateTime(year, _date.month, validDay);
  }
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
  late DateTime _currentDate;
  late FixedExtentScrollController _dayController;
  late FixedExtentScrollController _monthController;
  late FixedExtentScrollController _yearController;

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

  int get _daysInCurrentMonth {
    return DateTime(_currentDate.year, _currentDate.month + 1, 0).day;
  }

  int get _yearCount => widget.maxYear - widget.minYear + 1;

  @override
  void initState() {
    super.initState();
    _currentDate = widget.controller?.date ?? widget.initialDate ?? DateTime.now();
    _initControllers();
    widget.controller?.addListener(_onControllerChanged);
  }

  void _initControllers() {
    _dayController = FixedExtentScrollController(initialItem: _currentDate.day - 1);
    _monthController = FixedExtentScrollController(initialItem: _currentDate.month - 1);
    _yearController = FixedExtentScrollController(
      initialItem: _currentDate.year - widget.minYear,
    );
  }

  @override
  void didUpdateWidget(ModWheelDatePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?.removeListener(_onControllerChanged);
      widget.controller?.addListener(_onControllerChanged);
    }
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_onControllerChanged);
    _dayController.dispose();
    _monthController.dispose();
    _yearController.dispose();
    super.dispose();
  }

  void _onControllerChanged() {
    if (!mounted) return;
    final newDate = widget.controller!.date;
    if (_currentDate != newDate) {
      setState(() {
        _currentDate = newDate;
      });
      _animateToDate(newDate);
    }
  }

  void _animateToDate(DateTime date) {
    if (_dayController.hasClients) {
      _dayController.animateToItem(
        date.day - 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
    if (_monthController.hasClients) {
      _monthController.animateToItem(
        date.month - 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
    if (_yearController.hasClients) {
      _yearController.animateToItem(
        date.year - widget.minYear,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
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
    final newYear = year ?? _currentDate.year;
    final newMonth = month ?? _currentDate.month;
    final daysInMonth = DateTime(newYear, newMonth + 1, 0).day;
    final newDay = (day ?? _currentDate.day).clamp(1, daysInMonth);

    final newDate = DateTime(newYear, newMonth, newDay);
    if (_currentDate != newDate) {
      setState(() {
        _currentDate = newDate;
      });
      widget.controller?.date = newDate;
      widget.onDateChanged?.call(newDate);

      // Adjust day wheel if the new month has fewer days
      if (day == null && _currentDate.day > daysInMonth) {
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
        itemBuilder: (index) {
          final day = index + 1;
          final isSelected = day == _currentDate.day;
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
        itemBuilder: (index) {
          final isSelected = index + 1 == _currentDate.month;
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
        itemBuilder: (index) {
          final year = widget.minYear + index;
          final isSelected = year == _currentDate.year;
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
    required Widget Function(int index) itemBuilder,
  }) {
    return ListWheelScrollView.useDelegate(
      controller: controller,
      itemExtent: widget.itemSize,
      perspective: 0.005,
      diameterRatio: 1.5,
      physics: const FixedExtentScrollPhysics(),
      onSelectedItemChanged: onChanged,
      childDelegate: ListWheelChildBuilderDelegate(
        childCount: itemCount,
        builder: (context, index) => itemBuilder(index),
      ),
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
