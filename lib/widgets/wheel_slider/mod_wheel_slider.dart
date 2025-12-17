import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Controller for externally managing a [ModWheelSlider].
///
/// Provides methods to programmatically set the value and listen to value changes.
class ModWheelSliderController extends ChangeNotifier {
  num _value;
  final num interval;

  /// Creates a controller with an optional initial value and interval.
  ModWheelSliderController({
    num initialValue = 0,
    this.interval = 1,
  }) : _value = initialValue;

  /// The current value of the slider.
  num get value => _value;

  /// Sets the slider value and notifies listeners.
  set value(num newValue) {
    if (_value != newValue) {
      _value = newValue;
      notifyListeners();
    }
  }

  /// Programmatically sets the slider value.
  void setValue(num newValue) {
    value = newValue;
  }

  /// Increments the value by the interval.
  void increment() {
    value = _value + interval;
  }

  /// Decrements the value by the interval.
  void decrement() {
    value = _value - interval;
  }
}

/// Defines haptic feedback types for the wheel slider.
class ModHapticFeedbackType {
  final String value;

  const ModHapticFeedbackType._(this.value);

  /// Vibrate: Produces a standard vibration feedback
  static const ModHapticFeedbackType vibrate = ModHapticFeedbackType._('vibrate');

  /// Light Impact: Generates a subtle haptic feedback
  static const ModHapticFeedbackType lightImpact = ModHapticFeedbackType._('light');

  /// Medium Impact: Creates a more pronounced haptic feedback
  static const ModHapticFeedbackType mediumImpact = ModHapticFeedbackType._('medium');

  /// Heavy Impact: Produces strong haptic feedback
  static const ModHapticFeedbackType heavyImpact = ModHapticFeedbackType._('heavy');

  /// Selection Click: Mimics a physical click
  static const ModHapticFeedbackType selectionClick =
      ModHapticFeedbackType._('selectionClick');

  /// No haptic feedback
  static const ModHapticFeedbackType none = ModHapticFeedbackType._('none');

  static List<ModHapticFeedbackType> values = [
    vibrate,
    lightImpact,
    mediumImpact,
    heavyImpact,
    selectionClick,
    none,
  ];

  factory ModHapticFeedbackType.fromString(String input) =>
      values.firstWhere(
        (element) => element.value == input,
        orElse: () => vibrate,
      );
}

/// A customizable wheel slider widget that provides wheel-like scrolling appearance.
///
/// Supports horizontal and vertical orientations, custom items, haptic feedback,
/// and various visual customization options.
///
/// **Important:** The `totalCount` parameter represents the number of steps/items,
/// not the maximum value. The actual values displayed will be from 0 to
/// `totalCount * interval`. For example, with `totalCount: 10` and `interval: 0.5`,
/// the values will be: 0, 0.5, 1, 1.5, 2, 2.5, 3, 3.5, 4, 4.5, 5.
///
/// To create a slider from `min` to `max` with a specific `interval`, calculate
/// `totalCount` as: `((max - min) / interval).round()`.
class ModWheelSlider extends StatefulWidget {
  /// Height of the horizontal list view.
  final double horizontalListHeight;

  /// Width of the horizontal list view.
  final double horizontalListWidth;

  /// Height of the vertical list view.
  final double verticalListHeight;

  /// Width of the vertical list view.
  final double verticalListWidth;

  /// The total number of steps/items in the slider.
  /// The maximum value will be `totalCount * interval`.
  final int totalCount;

  /// The initial value to display in the slider.
  final num initValue;

  /// Callback function that is triggered when the slider value changes.
  final Function(dynamic) onValueChanged;

  /// Size of each item in the slider.
  final double itemSize;

  /// Perspective effect of the list. Values <= 0.01 are recommended.
  final double perspective;

  /// Enables or disables infinite scrolling.
  final bool isInfinite;

  /// Sets the orientation of the slider. `true` for horizontal, `false` for vertical.
  final bool horizontal;

  /// Squeeze factor for the items in the slider.
  final double squeeze;

  /// Color of the slider lines.
  final Color? lineColor;

  /// Color of the pointer.
  final Color pointerColor;

  /// Height of the pointer.
  final double pointerHeight;

  /// Width of the pointer.
  final double pointerWidth;

  /// Background widget displayed behind the slider.
  final Widget? background;

  /// Enables or disables haptic feedback.
  final bool enableHapticFeedback;

  /// Type of haptic feedback to be used.
  final ModHapticFeedbackType hapticFeedbackType;

  /// Determines if the pointer is visible.
  final bool showPointer;

  /// Custom pointer widget.
  final Widget? customPointer;

  /// Text style for the selected number in the slider.
  final TextStyle? selectedNumberStyle;

  /// Text style for unselected numbers in the slider.
  final TextStyle? unSelectedNumberStyle;

  /// Width of the selected number container.
  ///
  /// Use this to ensure large numbers (e.g., 1000) don't overflow or break
  /// the layout. When null, the width adapts to the content automatically.
  final double? selectedNumberWidth;

  /// A list of custom child widgets for the slider.
  final List<Widget>? children;

  /// Scroll physics for the list view.
  final ScrollPhysics? scrollPhysics;

  /// Enables or disables tappable pointer interactions.
  final bool allowPointerTappable;

  /// Interval value between slider steps.
  final num interval;

  /// Enables or disables animation for initial value display.
  final bool enableAnimation;

  /// Duration of the animation for initial value display.
  final Duration animationDuration;

  /// Type of animation curve to use.
  final Curve animationType;

  /// Controller for the scroll position of the slider.
  final FixedExtentScrollController? controller;

  /// External controller for programmatically setting values.
  final ModWheelSliderController? sliderController;

  /// The type of wheel slider display.
  final _WheelSliderType _sliderType;

  /// Current index for number type slider.
  final num? currentIndex;

  /// Constructs a ModWheelSlider with line-based UI.
  const ModWheelSlider({
    super.key,
    this.horizontalListHeight = 50,
    this.horizontalListWidth = double.infinity,
    this.verticalListHeight = 400.0,
    this.verticalListWidth = 50.0,
    required this.totalCount,
    required this.initValue,
    required this.onValueChanged,
    this.itemSize = 10,
    this.perspective = 0.0007,
    this.isInfinite = true,
    this.horizontal = true,
    this.squeeze = 1.0,
    this.lineColor,
    this.pointerColor = Colors.black,
    this.pointerHeight = 50.0,
    this.pointerWidth = 3.0,
    this.background,
    this.enableHapticFeedback = true,
    this.hapticFeedbackType = ModHapticFeedbackType.vibrate,
    this.showPointer = true,
    this.customPointer,
    this.scrollPhysics,
    this.allowPointerTappable = true,
    this.interval = 1,
    this.enableAnimation = true,
    this.animationDuration = const Duration(seconds: 1),
    this.animationType = Curves.easeIn,
    this.controller,
    this.sliderController,
  })  : assert(perspective <= 0.01, 'perspective must be <= 0.01'),
        _sliderType = _WheelSliderType.line,
        selectedNumberStyle = null,
        unSelectedNumberStyle = null,
        selectedNumberWidth = null,
        children = null,
        currentIndex = null;

  /// Constructs a ModWheelSlider with numbered UI.
  const ModWheelSlider.number({
    super.key,
    this.horizontalListHeight = 50,
    this.horizontalListWidth = double.infinity,
    this.verticalListHeight = 400.0,
    this.verticalListWidth = 50.0,
    required this.totalCount,
    required this.initValue,
    required this.onValueChanged,
    this.itemSize = 40,
    this.perspective = 0.0007,
    this.isInfinite = true,
    this.horizontal = true,
    this.squeeze = 1.0,
    this.pointerColor = Colors.black,
    this.pointerHeight = 50.0,
    this.pointerWidth = 3.0,
    this.background,
    this.enableHapticFeedback = true,
    this.hapticFeedbackType = ModHapticFeedbackType.vibrate,
    this.showPointer = false,
    this.customPointer,
    this.selectedNumberStyle = const TextStyle(fontWeight: FontWeight.bold),
    this.unSelectedNumberStyle = const TextStyle(),
    this.selectedNumberWidth,
    required this.currentIndex,
    this.scrollPhysics,
    this.allowPointerTappable = true,
    this.interval = 1,
    this.enableAnimation = true,
    this.animationDuration = const Duration(seconds: 1),
    this.animationType = Curves.easeIn,
    this.controller,
    this.sliderController,
  })  : assert(perspective <= 0.01, 'perspective must be <= 0.01'),
        _sliderType = _WheelSliderType.number,
        lineColor = null,
        children = null;

  /// Constructs a ModWheelSlider with custom child widgets.
  const ModWheelSlider.customWidget({
    super.key,
    this.horizontalListHeight = 50,
    this.horizontalListWidth = double.infinity,
    this.verticalListHeight = 400.0,
    this.verticalListWidth = 50.0,
    required this.totalCount,
    required this.initValue,
    required this.onValueChanged,
    this.itemSize = 10,
    this.perspective = 0.0007,
    this.isInfinite = true,
    this.horizontal = true,
    this.squeeze = 1.0,
    this.pointerColor = Colors.black,
    this.pointerHeight = 50.0,
    this.pointerWidth = 3.0,
    required this.children,
    this.background,
    this.enableHapticFeedback = true,
    this.hapticFeedbackType = ModHapticFeedbackType.vibrate,
    this.showPointer = true,
    this.customPointer,
    this.scrollPhysics,
    this.allowPointerTappable = true,
    this.enableAnimation = true,
    this.animationDuration = const Duration(seconds: 1),
    this.animationType = Curves.easeIn,
    this.controller,
    this.sliderController,
  })  : assert(perspective <= 0.01, 'perspective must be <= 0.01'),
        _sliderType = _WheelSliderType.custom,
        lineColor = null,
        selectedNumberStyle = null,
        unSelectedNumberStyle = null,
        selectedNumberWidth = null,
        currentIndex = null,
        interval = 1;

  @override
  State<ModWheelSlider> createState() => _ModWheelSliderState();
}

enum _WheelSliderType { line, number, custom }

class _ModWheelSliderState extends State<ModWheelSlider> {
  late FixedExtentScrollController _scrollController;
  int _selectedIndex = 0;

  // For mouse scroll handling on Windows
  // Accumulated scroll delta to handle high-resolution scroll events
  double _accumulatedScrollDelta = 0;
  // Threshold for triggering a scroll (Windows typically sends 120 per notch)
  static const double _scrollThreshold = 50.0;

  // For drag-and-drop functionality
  bool _isDragging = false;
  double _dragStartY = 0;
  double _dragStartX = 0;
  int _dragStartIndex = 0;

  /// Returns true if click-to-select should be enabled (Windows or Web only)
  bool get _isClickToSelectEnabled {
    if (kIsWeb) return true;
    try {
      return Platform.isWindows;
    } catch (_) {
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController = widget.controller ?? FixedExtentScrollController();
    widget.sliderController?.addListener(_onSliderControllerChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToInitialValue());
  }

  @override
  void didUpdateWidget(ModWheelSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.sliderController != widget.sliderController) {
      oldWidget.sliderController?.removeListener(_onSliderControllerChanged);
      widget.sliderController?.addListener(_onSliderControllerChanged);
    }
  }

  @override
  void dispose() {
    widget.sliderController?.removeListener(_onSliderControllerChanged);
    if (widget.controller == null) {
      _scrollController.dispose();
    }
    super.dispose();
  }

  void _onSliderControllerChanged() {
    if (!mounted || !_scrollController.hasClients) return;
    final newValue = widget.sliderController!.value;
    final targetIndex = (newValue / widget.interval).round();
    if (_selectedIndex != targetIndex) {
      _scrollController.animateToItem(
        targetIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _scrollToInitialValue() async {
    final itemIndex = await _getItemIndex();
    if (!mounted || !_scrollController.hasClients) return;

    if (widget.enableAnimation) {
      _scrollController.animateToItem(
        itemIndex,
        duration: widget.animationDuration,
        curve: widget.animationType,
      );
    } else {
      _scrollController.jumpToItem(itemIndex);
    }
  }

  Future<int> _getItemIndex() async {
    for (int i = 0; i <= widget.totalCount; i++) {
      if (_calculateValue(i) == widget.initValue) {
        return i;
      }
    }
    // Fallback: find closest index if exact match not found
    final targetIndex = (widget.initValue / widget.interval).round();
    return targetIndex.clamp(0, widget.totalCount);
  }

  /// Calculates the value for a given index, handling floating-point precision.
  num _calculateValue(int index) {
    // Use multiplication and rounding to avoid floating-point precision issues
    final intervalStr = widget.interval.toString();
    if (intervalStr.contains('.')) {
      final decimalPlaces = intervalStr.split('.').last.length;
      final multiplier = _pow10(decimalPlaces);
      final intervalInt = (widget.interval * multiplier).round();
      return (index * intervalInt) / multiplier;
    }
    return index * widget.interval;
  }

  /// Returns 10^n for positive integers
  static int _pow10(int n) {
    int result = 1;
    for (int i = 0; i < n; i++) {
      result *= 10;
    }
    return result;
  }

  Future<void> _triggerHapticFeedback() async {
    if (!widget.enableHapticFeedback) return;

    switch (widget.hapticFeedbackType.value) {
      case 'vibrate':
        await HapticFeedback.vibrate();
        break;
      case 'light':
        await HapticFeedback.lightImpact();
        break;
      case 'medium':
        await HapticFeedback.mediumImpact();
        break;
      case 'heavy':
        await HapticFeedback.heavyImpact();
        break;
      case 'selectionClick':
        await HapticFeedback.selectionClick();
        break;
      case 'none':
        break;
      default:
        await HapticFeedback.vibrate();
    }
  }

  void _onSelectedItemChanged(int index) {
    _triggerHapticFeedback();
    if (mounted) {
      setState(() {
        _selectedIndex = index;
      });
      widget.onValueChanged(_calculateValue(index));
    }
  }

  /// Handles tap on an item to select it directly (Windows/Web only)
  void _onItemTap(int index) {
    if (!_isClickToSelectEnabled) return;
    if (index == _selectedIndex) return;
    if (!_scrollController.hasClients) return;

    // Clamp index for non-infinite sliders
    final int clampedIndex = widget.isInfinite
        ? index
        : index.clamp(0, widget.totalCount);

    _scrollController.animateToItem(
      clampedIndex,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
    );
  }

  List<Widget> _buildLineItems() {
    return List.generate(
      widget.totalCount + 1,
      (index) {
        final value = _calculateValue(index);
        final isMultipleOfFive = _isMultipleOfFive(value);
        final height = widget.horizontal
            ? (isMultipleOfFive ? 35.0 : 20.0)
            : 1.5;
        final width = widget.horizontal
            ? 1.5
            : (isMultipleOfFive ? 35.0 : 20.0);

        final lineWidget = Container(
          height: height,
          width: width,
          alignment: Alignment.center,
          child: Container(
            height: height,
            width: width,
            color: widget.lineColor ?? Colors.black87,
          ),
        );

        // Wrap with GestureDetector for click-to-select on Windows/Web
        if (_isClickToSelectEnabled) {
          return GestureDetector(
            onTap: () => _onItemTap(index),
            behavior: HitTestBehavior.opaque,
            child: Container(
              alignment: Alignment.center,
              child: lineWidget,
            ),
          );
        }

        return lineWidget;
      },
    );
  }

  List<Widget> _buildNumberItems() {
    // Determine decimal places from interval
    final intervalStr = widget.interval.toString();
    final decimalPlaces = intervalStr.contains('.')
        ? intervalStr.split('.').last.length
        : 0;

    return List.generate(
      widget.totalCount + 1,
      (index) {
        // Calculate value with proper precision to avoid floating-point errors
        final value = _calculateValue(index);
        final formattedValue = decimalPlaces > 0
            ? value.toStringAsFixed(decimalPlaces)
            : value.toInt().toString();

        final isSelected = _selectedIndex == index;

        final numberWidget = Container(
          width: isSelected ? widget.selectedNumberWidth : null,
          alignment: Alignment.center,
          child: Text(
            formattedValue,
            style: isSelected
                ? widget.selectedNumberStyle
                : widget.unSelectedNumberStyle,
          ),
        );

        // Wrap with GestureDetector for click-to-select on Windows/Web
        if (_isClickToSelectEnabled) {
          return GestureDetector(
            onTap: () => _onItemTap(index),
            behavior: HitTestBehavior.opaque,
            child: MouseRegion(
              cursor: isSelected
                  ? SystemMouseCursors.basic
                  : SystemMouseCursors.click,
              child: numberWidget,
            ),
          );
        }

        return numberWidget;
      },
    );
  }

  static bool _isMultipleOfFive(num n) {
    if (n == 0) return true;
    if (n < 0) n = -n;
    return n % 5 == 0;
  }

  Widget _buildPointer() {
    if (widget.customPointer != null) {
      return widget.customPointer!;
    }

    return Container(
      height: widget.horizontal ? widget.pointerHeight : widget.pointerWidth,
      width: widget.horizontal ? widget.pointerWidth : widget.pointerHeight,
      color: widget.pointerColor,
    );
  }

  List<Widget> _getChildren() {
    switch (widget._sliderType) {
      case _WheelSliderType.line:
        return _buildLineItems();
      case _WheelSliderType.number:
        return _buildNumberItems();
      case _WheelSliderType.custom:
        return _buildCustomItems();
    }
  }

  List<Widget> _buildCustomItems() {
    final children = widget.children ?? [];
    if (!_isClickToSelectEnabled) return children;

    return List.generate(
      children.length,
      (index) {
        final isSelected = _selectedIndex == index;
        return GestureDetector(
          onTap: () => _onItemTap(index),
          behavior: HitTestBehavior.opaque,
          child: MouseRegion(
            cursor: isSelected
                ? SystemMouseCursors.basic
                : SystemMouseCursors.click,
            child: children[index],
          ),
        );
      },
    );
  }

  void _handlePointerSignal(PointerSignalEvent event) {
    if (event is PointerScrollEvent && _scrollController.hasClients) {
      // Accumulate scroll delta to handle high-resolution scroll devices
      // On Windows, each scroll "notch" typically sends ~120 pixels
      // On high-resolution touchpads, smaller deltas are sent more frequently
      _accumulatedScrollDelta += event.scrollDelta.dy;

      // Only trigger a scroll when we've accumulated enough delta
      if (_accumulatedScrollDelta.abs() >= _scrollThreshold) {
        // Determine direction: positive delta = scroll down = increase value
        final int direction = _accumulatedScrollDelta > 0 ? 1 : -1;

        // Reset accumulated delta after triggering
        _accumulatedScrollDelta = 0;

        final int targetIndex = _selectedIndex + direction;

        // Clamp index for non-infinite sliders
        final int clampedIndex = widget.isInfinite
            ? targetIndex
            : targetIndex.clamp(0, widget.totalCount);

        _scrollController.animateToItem(
          clampedIndex,
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
      _dragStartX = event.position.dx;
      _dragStartIndex = _selectedIndex;
    }
  }

  void _handlePointerMove(PointerMoveEvent event) {
    if (!_isDragging || !_scrollController.hasClients) return;

    // Calculate drag delta based on orientation
    final double dragDelta = widget.horizontal
        ? event.position.dx - _dragStartX
        : event.position.dy - _dragStartY;

    // Calculate how many items to move based on drag distance
    // Use a sensitivity factor to make dragging feel more natural
    // Smaller itemSize = more sensitive, larger itemSize = less sensitive
    final double sensitivity = widget.itemSize * 0.8;
    final int itemsToMove = (dragDelta / sensitivity).round();

    // For horizontal sliders, negative drag (left) should increase value
    // For vertical sliders, positive drag (down) should increase value
    final int direction = widget.horizontal ? -itemsToMove : itemsToMove;
    final int targetIndex = _dragStartIndex + direction;

    // Clamp index for non-infinite sliders
    final int clampedIndex = widget.isInfinite
        ? targetIndex
        : targetIndex.clamp(0, widget.totalCount);

    if (clampedIndex != _selectedIndex) {
      _scrollController.jumpToItem(clampedIndex);
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

  @override
  Widget build(BuildContext context) {
    final children = _getChildren();

    return Listener(
      onPointerSignal: _handlePointerSignal,
      onPointerDown: _handlePointerDown,
      onPointerMove: _handlePointerMove,
      onPointerUp: _handlePointerUp,
      onPointerCancel: _handlePointerCancel,
      child: MouseRegion(
        cursor: _isDragging ? SystemMouseCursors.grabbing : SystemMouseCursors.grab,
        child: SizedBox(
          height: widget.horizontal
              ? widget.horizontalListHeight
              : widget.verticalListHeight,
          width: widget.horizontal
              ? widget.horizontalListWidth
              : widget.verticalListWidth,
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (widget.background != null) widget.background!,
              widget.horizontal
                  ? _buildHorizontalWheelChooser(children)
                  : _buildVerticalWheelChooser(children),
              IgnorePointer(
                ignoring: widget.allowPointerTappable,
                child: Visibility(
                  visible: widget.showPointer,
                  child: _buildPointer(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHorizontalWheelChooser(List<Widget> children) {
    return RotatedBox(
      quarterTurns: -1,
      child: ListWheelScrollView.useDelegate(
        controller: _scrollController,
        itemExtent: widget.itemSize,
        perspective: widget.perspective,
        squeeze: widget.squeeze,
        physics: widget.scrollPhysics ?? const FixedExtentScrollPhysics(),
        onSelectedItemChanged: _onSelectedItemChanged,
        childDelegate: widget.isInfinite
            ? ListWheelChildLoopingListDelegate(
                children: children.map((child) {
                  return RotatedBox(
                    quarterTurns: 1,
                    child: child,
                  );
                }).toList(),
              )
            : ListWheelChildListDelegate(
                children: children.map((child) {
                  return RotatedBox(
                    quarterTurns: 1,
                    child: child,
                  );
                }).toList(),
              ),
      ),
    );
  }

  Widget _buildVerticalWheelChooser(List<Widget> children) {
    return ListWheelScrollView.useDelegate(
      controller: _scrollController,
      itemExtent: widget.itemSize,
      perspective: widget.perspective,
      squeeze: widget.squeeze,
      physics: widget.scrollPhysics ?? const FixedExtentScrollPhysics(),
      onSelectedItemChanged: _onSelectedItemChanged,
      childDelegate: widget.isInfinite
          ? ListWheelChildLoopingListDelegate(children: children)
          : ListWheelChildListDelegate(children: children),
    );
  }
}
