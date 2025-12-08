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
class ModWheelSlider extends StatefulWidget {
  /// Height of the horizontal list view.
  final double horizontalListHeight;

  /// Width of the horizontal list view.
  final double horizontalListWidth;

  /// Height of the vertical list view.
  final double verticalListHeight;

  /// Width of the vertical list view.
  final double verticalListWidth;

  /// The total number of items in the slider.
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
        currentIndex = null,
        interval = 1;

  @override
  State<ModWheelSlider> createState() => _ModWheelSliderState();
}

enum _WheelSliderType { line, number, custom }

class _ModWheelSliderState extends State<ModWheelSlider> {
  late FixedExtentScrollController _scrollController;
  int _selectedIndex = 0;

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
      if (i * widget.interval == widget.initValue) {
        return i;
      }
    }
    return 0;
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
      widget.onValueChanged(index * widget.interval);
    }
  }

  List<Widget> _buildLineItems() {
    return List.generate(
      widget.totalCount + 1,
      (index) {
        final isMultipleOfFive = _isMultipleOfFive(index * widget.interval);
        final height = widget.horizontal
            ? (isMultipleOfFive ? 35.0 : 20.0)
            : 1.5;
        final width = widget.horizontal
            ? 1.5
            : (isMultipleOfFive ? 35.0 : 20.0);

        return Container(
          height: height,
          width: width,
          alignment: Alignment.center,
          child: Container(
            height: height,
            width: width,
            color: widget.lineColor ?? Colors.black87,
          ),
        );
      },
    );
  }

  List<Widget> _buildNumberItems() {
    return List.generate(
      widget.totalCount + 1,
      (index) {
        final value = index * widget.interval;
        final formattedValue = widget.interval.toString().contains('.')
            ? value.toStringAsFixed(
                widget.interval.toString().split('.').last.length)
            : value.toString();

        return Container(
          alignment: Alignment.center,
          child: Text(
            formattedValue,
            style: _selectedIndex == index
                ? widget.selectedNumberStyle
                : widget.unSelectedNumberStyle,
          ),
        );
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
        return widget.children ?? [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final children = _getChildren();

    return SizedBox(
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
