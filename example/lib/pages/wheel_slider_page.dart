import 'dart:developer';

import 'package:example/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mod_layout_one/mod_layout_one.dart';

class WheelSliderPage extends StatefulWidget {
  const WheelSliderPage({super.key});

  @override
  State<WheelSliderPage> createState() => _WheelSliderPageState();
}

class _WheelSliderPageState extends State<WheelSliderPage> {
  num _lineValue = 50;
  num _numberValue = 25;
  num _verticalValue = 10;
  num _customValue = 0;
  num _intervalValue = 0;

  // Controllers for external control
  late ModWheelSliderController _externalController;
  late ModWheelDatePickerController _dateController;
  DateTime _selectedFullDate = DateTime.now();
  DateTime _selectedMonthYear = DateTime.now();
  DateTime _selectedYear = DateTime.now();

  final List<String> _weekDays = [
    'Segunda',
    'Terça',
    'Quarta',
    'Quinta',
    'Sexta',
    'Sábado',
    'Domingo',
  ];

  @override
  void initState() {
    super.initState();
    _externalController = ModWheelSliderController(initialValue: 50);
    // Initialize GetX controller using Get.put for proper lifecycle management
    _dateController = Get.put(
      ModWheelDatePickerController(initialDate: DateTime.now()),
      tag: 'wheel_slider_page_date_controller',
    );
  }

  @override
  void dispose() {
    _externalController.dispose();
    // Delete GetX controller when page is disposed
    Get.delete<ModWheelDatePickerController>(tag: 'wheel_slider_page_date_controller');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomLayout(
      title: 'Wheel Slider',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ModCard(
              header: const Text(
                "Line Wheel Slider",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Basic Line Slider (Horizontal):"),
                  const SizedBox(height: 8),
                  Center(
                    child: Text(
                      'Valor: $_lineValue',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Theme.of(context).dividerColor,
                      ),
                    ),
                    child: ModWheelSlider(
                      totalCount: 100,
                      initValue: 50,
                      onValueChanged: (value) {
                        setState(() {
                          _lineValue = value;
                        });
                      },
                      pointerColor: Theme.of(context).primaryColor,
                      lineColor: Theme.of(context).hintColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text("Line Slider with Custom Colors:"),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ModWheelSlider(
                      totalCount: 100,
                      initValue: 30,
                      onValueChanged: (value) {},
                      pointerColor: Colors.amber,
                      lineColor: Colors.white54,
                      pointerHeight: 40,
                      pointerWidth: 4,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const ModCodeExample(
                    code: '''// Basic Line Slider
ModWheelSlider(
  totalCount: 100,
  initValue: 50,
  onValueChanged: (value) {
    setState(() {
      _lineValue = value;
    });
  },
  pointerColor: Theme.of(context).primaryColor,
  lineColor: Theme.of(context).hintColor,
),

// Line Slider with Custom Colors
ModWheelSlider(
  totalCount: 100,
  initValue: 30,
  onValueChanged: (value) {},
  pointerColor: Colors.amber,
  lineColor: Colors.white54,
  pointerHeight: 40,
  pointerWidth: 4,
),''',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            ModCard(
              header: const Text(
                "Number Wheel Slider",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Number Slider (Horizontal):"),
                  const SizedBox(height: 8),
                  Center(
                    child: Text(
                      'Selecionado: $_numberValue',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Theme.of(context).dividerColor,
                      ),
                    ),
                    child: ModWheelSlider.number(
                      totalCount: 50,
                      initValue: 25,
                      currentIndex: _numberValue,
                      onValueChanged: (value) {
                        setState(() {
                          _numberValue = value;
                        });
                      },
                      selectedNumberStyle: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                      unSelectedNumberStyle: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).hintColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text("Number Slider with Pointer:"),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ModWheelSlider.number(
                      totalCount: 30,
                      initValue: 15,
                      currentIndex: 15,
                      showPointer: true,
                      onValueChanged: (value) {},
                      pointerColor: Colors.blue,
                      pointerHeight: 45,
                      pointerWidth: 2,
                      selectedNumberStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                      unSelectedNumberStyle: TextStyle(
                        fontSize: 14,
                        color: Colors.blue.shade300,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const ModCodeExample(
                    code: '''// Number Slider
ModWheelSlider.number(
  totalCount: 50,
  initValue: 25,
  currentIndex: _numberValue,
  onValueChanged: (value) {
    setState(() {
      _numberValue = value;
    });
  },
  selectedNumberStyle: TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Theme.of(context).primaryColor,
  ),
  unSelectedNumberStyle: TextStyle(
    fontSize: 14,
    color: Theme.of(context).hintColor,
  ),
),

// Number Slider with Pointer
ModWheelSlider.number(
  totalCount: 30,
  initValue: 15,
  currentIndex: 15,
  showPointer: true,
  onValueChanged: (value) {},
  pointerColor: Colors.blue,
  pointerHeight: 45,
  pointerWidth: 2,
),''',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            ModCard(
              header: const Text(
                "Vertical Wheel Slider",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Vertical Line Slider:"),
                  const SizedBox(height: 8),
                  Center(
                    child: Text(
                      'Valor: $_verticalValue',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Theme.of(context).dividerColor,
                        ),
                      ),
                      child: ModWheelSlider(
                        totalCount: 50,
                        initValue: 10,
                        horizontal: false,
                        verticalListHeight: 200,
                        verticalListWidth: 80,
                        onValueChanged: (value) {
                          setState(() {
                            _verticalValue = value;
                          });
                        },
                        pointerColor: Colors.green,
                        lineColor: Theme.of(context).hintColor,
                        pointerHeight: 60,
                        pointerWidth: 3,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text("Vertical Number Slider:"),
                  const SizedBox(height: 8),
                  Center(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.purple.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ModWheelSlider.number(
                        totalCount: 24,
                        initValue: 12,
                        currentIndex: 12,
                        horizontal: false,
                        verticalListHeight: 180,
                        verticalListWidth: 60,
                        onValueChanged: (value) {},
                        selectedNumberStyle: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple,
                        ),
                        unSelectedNumberStyle: TextStyle(
                          fontSize: 16,
                          color: Colors.purple.shade300,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const ModCodeExample(
                    code: '''// Vertical Line Slider
ModWheelSlider(
  totalCount: 50,
  initValue: 10,
  horizontal: false,
  verticalListHeight: 200,
  verticalListWidth: 80,
  onValueChanged: (value) {
    setState(() {
      _verticalValue = value;
    });
  },
  pointerColor: Colors.green,
  lineColor: Theme.of(context).hintColor,
),

// Vertical Number Slider
ModWheelSlider.number(
  totalCount: 24,
  initValue: 12,
  currentIndex: 12,
  horizontal: false,
  verticalListHeight: 180,
  verticalListWidth: 60,
  onValueChanged: (value) {},
),''',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            ModCard(
              header: const Text(
                "Custom Widget Wheel Slider",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Custom Widgets (Days of Week):"),
                  const SizedBox(height: 8),
                  Center(
                    child: Text(
                      'Dia: ${_weekDays[_customValue.toInt() % _weekDays.length]}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Theme.of(context).dividerColor,
                      ),
                    ),
                    child: ModWheelSlider.customWidget(
                      totalCount: _weekDays.length - 1,
                      initValue: 0,
                      itemSize: 60,
                      horizontalListHeight: 60,
                      onValueChanged: (value) {
                        setState(() {
                          _customValue = value;
                        });
                      },
                      showPointer: false,
                      children: _weekDays.map((day) {
                        return Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            day,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: _weekDays[_customValue.toInt() %
                                          _weekDays.length] ==
                                      day
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: _weekDays[_customValue.toInt() %
                                          _weekDays.length] ==
                                      day
                                  ? Theme.of(context).primaryColor
                                  : Theme.of(context).hintColor,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text("Custom Widgets (Icons):"),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ModWheelSlider.customWidget(
                      totalCount: 4,
                      initValue: 0,
                      itemSize: 50,
                      horizontalListHeight: 60,
                      onValueChanged: (value) {},
                      showPointer: true,
                      pointerColor: Colors.orange,
                      pointerHeight: 50,
                      pointerWidth: 2,
                      children: const [
                        Icon(Icons.home, size: 30, color: Colors.orange),
                        Icon(Icons.star, size: 30, color: Colors.orange),
                        Icon(Icons.favorite, size: 30, color: Colors.orange),
                        Icon(Icons.settings, size: 30, color: Colors.orange),
                        Icon(Icons.person, size: 30, color: Colors.orange),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const ModCodeExample(
                    code: '''// Custom Widget Slider (Days of Week)
ModWheelSlider.customWidget(
  totalCount: _weekDays.length - 1,
  initValue: 0,
  itemSize: 60,
  horizontalListHeight: 60,
  onValueChanged: (value) {
    setState(() {
      _customValue = value;
    });
  },
  showPointer: false,
  children: _weekDays.map((day) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(day),
    );
  }).toList(),
),

// Custom Widget Slider (Icons)
ModWheelSlider.customWidget(
  totalCount: 4,
  initValue: 0,
  itemSize: 50,
  horizontalListHeight: 60,
  onValueChanged: (value) {},
  showPointer: true,
  pointerColor: Colors.orange,
  children: const [
    Icon(Icons.home, size: 30),
    Icon(Icons.star, size: 30),
    Icon(Icons.favorite, size: 30),
  ],
),''',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            ModCard(
              header: const Text(
                "Interval & Configuration",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Slider with Interval (0.5):"),
                  const SizedBox(height: 8),
                  Center(
                    child: Text(
                      'Valor: ${_intervalValue.toStringAsFixed(1)}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Theme.of(context).dividerColor,
                      ),
                    ),
                    child: ModWheelSlider.number(
                      totalCount: 20,
                      initValue: 0,
                      currentIndex: _intervalValue,
                      interval: 0.5,
                      onValueChanged: (value) {
                        setState(() {
                          _intervalValue = value;
                        });
                      },
                      selectedNumberStyle: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                      unSelectedNumberStyle: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).hintColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                      "Slider with Large Numbers (selectedNumberWidth):"),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.amber.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ModWheelSlider.number(
                      totalCount: 20,
                      initValue: 500,
                      currentIndex: 500,
                      interval: 100,
                      itemSize: 60,
                      selectedNumberWidth: 80,
                      onValueChanged: (value) {},
                      selectedNumberStyle: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.amber,
                      ),
                      unSelectedNumberStyle: TextStyle(
                        fontSize: 14,
                        color: Colors.amber.shade300,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text("Non-Infinite Slider:"),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.teal.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ModWheelSlider(
                      totalCount: 20,
                      initValue: 10,
                      isInfinite: false,
                      onValueChanged: (value) {},
                      pointerColor: Colors.teal,
                      lineColor: Colors.teal.shade300,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text("Disabled Animation:"),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ModWheelSlider(
                      totalCount: 50,
                      initValue: 25,
                      enableAnimation: false,
                      onValueChanged: (value) {},
                      pointerColor: Colors.grey,
                      lineColor: Colors.grey.shade500,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const ModCodeExample(
                    code: '''// Slider with Interval
ModWheelSlider.number(
  totalCount: 20,
  initValue: 0,
  currentIndex: _intervalValue,
  interval: 0.5,
  onValueChanged: (value) {
    setState(() {
      _intervalValue = value;
    });
  },
),

// Slider with Large Numbers (selectedNumberWidth)
ModWheelSlider.number(
  totalCount: 20,
  initValue: 500,
  currentIndex: 500,
  interval: 100,
  itemSize: 60,
  selectedNumberWidth: 80, // Prevents large numbers from overflowing
  onValueChanged: (value) {},
),

// Non-Infinite Slider
ModWheelSlider(
  totalCount: 20,
  initValue: 10,
  isInfinite: false,
  onValueChanged: (value) {},
),

// Disabled Animation
ModWheelSlider(
  totalCount: 50,
  initValue: 25,
  enableAnimation: false,
  onValueChanged: (value) {},
),''',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            ModCard(
              header: const Text(
                "Haptic Feedback Types",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Light Impact:"),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.lightBlue.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ModWheelSlider(
                      totalCount: 30,
                      initValue: 15,
                      hapticFeedbackType: ModHapticFeedbackType.lightImpact,
                      onValueChanged: (value) {},
                      pointerColor: Colors.lightBlue,
                      lineColor: Colors.lightBlue.shade300,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text("Medium Impact:"),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.indigo.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ModWheelSlider(
                      totalCount: 30,
                      initValue: 15,
                      hapticFeedbackType: ModHapticFeedbackType.mediumImpact,
                      onValueChanged: (value) {},
                      pointerColor: Colors.indigo,
                      lineColor: Colors.indigo.shade300,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text("Heavy Impact:"),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.deepPurple.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ModWheelSlider(
                      totalCount: 30,
                      initValue: 15,
                      hapticFeedbackType: ModHapticFeedbackType.heavyImpact,
                      onValueChanged: (value) {},
                      pointerColor: Colors.deepPurple,
                      lineColor: Colors.deepPurple.shade300,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text("No Haptic Feedback:"),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ModWheelSlider(
                      totalCount: 30,
                      initValue: 15,
                      hapticFeedbackType: ModHapticFeedbackType.none,
                      enableHapticFeedback: false,
                      onValueChanged: (value) {},
                      pointerColor: Colors.grey,
                      lineColor: Colors.grey.shade400,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const ModCodeExample(
                    code: '''// Light Impact Haptic
ModWheelSlider(
  totalCount: 30,
  initValue: 15,
  hapticFeedbackType: ModHapticFeedbackType.lightImpact,
  onValueChanged: (value) {},
),

// Medium Impact Haptic
ModWheelSlider(
  totalCount: 30,
  initValue: 15,
  hapticFeedbackType: ModHapticFeedbackType.mediumImpact,
  onValueChanged: (value) {},
),

// Heavy Impact Haptic
ModWheelSlider(
  totalCount: 30,
  initValue: 15,
  hapticFeedbackType: ModHapticFeedbackType.heavyImpact,
  onValueChanged: (value) {},
),

// No Haptic Feedback
ModWheelSlider(
  totalCount: 30,
  initValue: 15,
  hapticFeedbackType: ModHapticFeedbackType.none,
  enableHapticFeedback: false,
  onValueChanged: (value) {},
),''',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            ModCard(
              header: const Text(
                "Custom Pointer",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Custom Pointer Widget:"),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.pink.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ModWheelSlider(
                      totalCount: 50,
                      initValue: 25,
                      onValueChanged: (value) {},
                      lineColor: Colors.pink.shade300,
                      customPointer: Container(
                        width: 4,
                        height: 50,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.pink, Colors.purple],
                          ),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text("Triangle Pointer:"),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.cyan.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ModWheelSlider(
                      totalCount: 40,
                      initValue: 20,
                      onValueChanged: (value) {},
                      lineColor: Colors.cyan.shade300,
                      customPointer: CustomPaint(
                        size: const Size(20, 50),
                        painter: _TrianglePointerPainter(color: Colors.cyan),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const ModCodeExample(
                    code: '''// Custom Gradient Pointer
ModWheelSlider(
  totalCount: 50,
  initValue: 25,
  onValueChanged: (value) {},
  lineColor: Colors.pink.shade300,
  customPointer: Container(
    width: 4,
    height: 50,
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Colors.pink, Colors.purple],
      ),
      borderRadius: BorderRadius.circular(2),
    ),
  ),
),

// Triangle Pointer
ModWheelSlider(
  totalCount: 40,
  initValue: 20,
  onValueChanged: (value) {},
  lineColor: Colors.cyan.shade300,
  customPointer: CustomPaint(
    size: const Size(20, 50),
    painter: TrianglePointerPainter(color: Colors.cyan),
  ),
),''',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            ModCard(
              header: const Text(
                "External Control (Controller)",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Number Slider with External Controller:"),
                  const SizedBox(height: 8),
                  Center(
                    child: ListenableBuilder(
                      listenable: _externalController,
                      builder: (context, child) {
                        return Text(
                          'Valor: ${_externalController.value}',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 300,
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Theme.of(context).dividerColor,
                      ),
                    ),
                    child: ModWheelSlider.number(
                      totalCount: 1000,
                      initValue: 50,
                      itemSize: 60,
                      selectedNumberWidth: 80,
                      interval: 1,
                      currentIndex: 50,
                      sliderController: _externalController,
                      onValueChanged: (value) {
                        _externalController.setValue(value);
                        log(value.toString());
                      },
                      selectedNumberStyle: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                      unSelectedNumberStyle: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).hintColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () => _externalController.setValue(0),
                        child: const Text('Set 0'),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () => _externalController.setValue(25),
                        child: const Text('Set 25'),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () => _externalController.setValue(50),
                        child: const Text('Set 50'),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () => _externalController.setValue(75),
                        child: const Text('Set 75'),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () => _externalController.setValue(100),
                        child: const Text('Set 100'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const ModCodeExample(
                    code: '''// Create a controller
final controller = ModWheelSliderController(initialValue: 50);

// Use with the slider
ModWheelSlider.number(
  totalCount: 100,
  initValue: 50,
  currentIndex: 50,
  sliderController: controller,
  onValueChanged: (value) {
    controller.setValue(value);
  },
),

// Control externally
ElevatedButton(
  onPressed: () => controller.setValue(75),
  child: Text('Set 75'),
),''',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            ModCard(
              header: const Text(
                "Date Picker - Full Date (Day/Month/Year)",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Select Day, Month, and Year:"),
                  const SizedBox(height: 8),
                  Center(
                    child: Text(
                      'Data: ${_selectedFullDate.day.toString().padLeft(2, '0')}/${_selectedFullDate.month.toString().padLeft(2, '0')}/${_selectedFullDate.year}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Theme.of(context).dividerColor,
                      ),
                    ),
                    child: ModWheelDatePicker.dayMonthYear(
                      initialDate: DateTime.now(),
                      minYear: 2000,
                      maxYear: 2030,
                      height: 150,
                      showDividers: true,
                      dividerColor: Theme.of(context).dividerColor,
                      selectedStyle: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                      unselectedStyle: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).hintColor,
                      ),
                      onDateChanged: (date) {
                        setState(() {
                          _selectedFullDate = date;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text("With External Controller:"),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ModWheelDatePicker.dayMonthYear(
                      controller: _dateController,
                      minYear: 2000,
                      maxYear: 2030,
                      height: 150,
                      selectedStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                      unselectedStyle: TextStyle(
                        fontSize: 14,
                        color: Colors.blue.shade300,
                      ),
                      onDateChanged: (date) {},
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () =>
                            _dateController.setDate(DateTime(2025, 1, 1)),
                        child: const Text('01/01/2025'),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () =>
                            _dateController.setDate(DateTime(2024, 12, 25)),
                        child: const Text('25/12/2024'),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () =>
                            _dateController.setDate(DateTime.now()),
                        child: const Text('Hoje'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const ModCodeExample(
                    code: '''// Full Date Picker (Day/Month/Year)
ModWheelDatePicker.dayMonthYear(
  initialDate: DateTime.now(),
  minYear: 2000,
  maxYear: 2030,
  height: 150,
  showDividers: true,
  selectedStyle: TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Theme.of(context).primaryColor,
  ),
  onDateChanged: (date) {
    setState(() {
      _selectedFullDate = date;
    });
  },
),

// With External Controller
final controller = ModWheelDatePickerController(
  initialDate: DateTime.now(),
);

ModWheelDatePicker.dayMonthYear(
  controller: controller,
  ...
),

// Set date programmatically
controller.setDate(DateTime(2025, 1, 1));
controller.setDay(15);
controller.setMonth(6);
controller.setYear(2024);''',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            ModCard(
              header: const Text(
                "Date Picker - Month and Year",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Select Month and Year:"),
                  const SizedBox(height: 8),
                  Center(
                    child: Text(
                      'Mês/Ano: ${_selectedMonthYear.month.toString().padLeft(2, '0')}/${_selectedMonthYear.year}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Theme.of(context).dividerColor,
                      ),
                    ),
                    child: ModWheelDatePicker.monthYear(
                      initialDate: DateTime.now(),
                      minYear: 2020,
                      maxYear: 2030,
                      height: 150,
                      showDividers: true,
                      dividerColor: Theme.of(context).dividerColor,
                      selectedStyle: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                      unselectedStyle: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).hintColor,
                      ),
                      onDateChanged: (date) {
                        log(date.toIso8601String());
                        setState(() {
                          _selectedMonthYear = date;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text("With Short Month Names:"),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ModWheelDatePicker.monthYear(
                      initialDate: DateTime.now(),
                      minYear: 2020,
                      maxYear: 2030,
                      height: 150,
                      useShortMonthNames: true,
                      selectedStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                      unselectedStyle: TextStyle(
                        fontSize: 14,
                        color: Colors.green.shade300,
                      ),
                      onDateChanged: (date) {},
                    ),
                  ),
                  const SizedBox(height: 16),
                  const ModCodeExample(
                    code: '''// Month and Year Picker
ModWheelDatePicker.monthYear(
  initialDate: DateTime.now(),
  minYear: 2020,
  maxYear: 2030,
  height: 150,
  showDividers: true,
  onDateChanged: (date) {
    setState(() {
      _selectedMonthYear = date;
    });
  },
),

// With Short Month Names
ModWheelDatePicker.monthYear(
  initialDate: DateTime.now(),
  useShortMonthNames: true,
  ...
),''',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            ModCard(
              header: const Text(
                "Date Picker - Year Only",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Select Year:"),
                  const SizedBox(height: 8),
                  Center(
                    child: Text(
                      'Ano: ${_selectedYear.year}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: Container(
                      width: 120,
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Theme.of(context).dividerColor,
                        ),
                      ),
                      child: ModWheelDatePicker.yearOnly(
                        initialDate: DateTime.now(),
                        minYear: 1990,
                        maxYear: 2050,
                        height: 150,
                        selectedStyle: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                        unselectedStyle: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).hintColor,
                        ),
                        onDateChanged: (date) {
                          setState(() {
                            _selectedYear = date;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text("Styled Year Picker:"),
                  const SizedBox(height: 8),
                  Center(
                    child: Container(
                      width: 150,
                      decoration: BoxDecoration(
                        color: Colors.purple.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ModWheelDatePicker.yearOnly(
                        initialDate: DateTime.now(),
                        minYear: 2000,
                        maxYear: 2030,
                        height: 180,
                        itemSize: 50,
                        selectedStyle: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple,
                        ),
                        unselectedStyle: TextStyle(
                          fontSize: 18,
                          color: Colors.purple.shade200,
                        ),
                        onDateChanged: (date) {},
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const ModCodeExample(
                    code: '''// Year Only Picker
ModWheelDatePicker.yearOnly(
  initialDate: DateTime.now(),
  minYear: 1990,
  maxYear: 2050,
  height: 150,
  selectedStyle: TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Theme.of(context).primaryColor,
  ),
  onDateChanged: (date) {
    setState(() {
      _selectedYear = date;
    });
  },
),''',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TrianglePointerPainter extends CustomPainter {
  final Color color;

  _TrianglePointerPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(size.width / 2, 0)
      ..lineTo(size.width, 15)
      ..lineTo(size.width / 2, size.height)
      ..lineTo(0, 15)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
