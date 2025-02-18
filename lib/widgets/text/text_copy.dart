import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ModTextCopy extends StatefulWidget {
  final Widget child;
  final String textToCopy;

  const ModTextCopy({
    super.key,
    required this.child,
    required this.textToCopy,
  });

  @override
  State<ModTextCopy> createState() => _ModTextCopyState();
}

class _ModTextCopyState extends State<ModTextCopy>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _showCopyIcon = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _copyToClipboard() async {
    await Clipboard.setData(ClipboardData(text: widget.textToCopy));
    setState(() => _showCopyIcon = true);
    _controller.forward(from: 0.0);

    await Future.delayed(const Duration(milliseconds: 1000));
    setState(() => _showCopyIcon = false);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.centerRight,
      children: [
        GestureDetector(
          onTap: _copyToClipboard,
          child: widget.child,
        ),
        if (_showCopyIcon)
          Positioned(
            right: 8,
            child: RotationTransition(
              turns: Tween(begin: 0.0, end: 1.0).animate(_controller),
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  Icons.check_circle,
                  color: Theme.of(context).colorScheme.onPrimary,
                  size: 20,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
