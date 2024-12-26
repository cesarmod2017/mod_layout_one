import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

enum ModLoadingPosition {
  center,
  left,
  right,
  topLeft,
  topCenter,
  topRight,
  bottomLeft,
  bottomCenter,
  bottomRight,
}

enum ModLoadingOrientation {
  vertical,
  horizontal,
}

class ModLoadingConfig {
  final String? imagePath;
  final IconData? icon;
  final bool animate;
  final double size;
  final ModLoadingPosition position;
  final Color? backgroundColor;
  final double borderRadius;
  final EdgeInsets? padding;
  final bool barrierDismissible;
  final String? title;
  final ModLoadingOrientation orientation;
  final double spacing;

  ModLoadingConfig({
    this.imagePath,
    this.icon,
    this.animate = true,
    this.size = 32,
    this.position = ModLoadingPosition.center,
    this.backgroundColor,
    this.borderRadius = 8,
    this.padding,
    this.barrierDismissible = false,
    this.title,
    this.orientation = ModLoadingOrientation.vertical,
    this.spacing = 20,
  });
}

class ModLoading {
  static final Map<int, OverlayEntry> _entries = {};
  static int _currentId = 0;
  late final int _id;
  OverlayEntry? _overlayEntry;

  ModLoading._() {
    _id = _currentId++;
  }

  static ModLoading instance = ModLoading._();

  void show({ModLoadingConfig? config}) {
    config ??= ModLoadingConfig();

    _overlayEntry = OverlayEntry(
      builder: (context) => Material(
        type: MaterialType.transparency,
        child: _ModLoadingWidget(
          config: config!,
          onDismiss: config.barrierDismissible ? close : null,
        ),
      ),
    );

    _entries[_id] = _overlayEntry!;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Get.isOverlaysOpen) return;

      try {
        final context = Get.overlayContext;
        if (context != null) {
          Navigator.of(context).overlay?.insert(_overlayEntry!);
        } else {
          Get.printError(info: 'ModLoading: No overlay context found');
        }
      } catch (e) {
        Get.printError(info: 'ModLoading: Error showing loading - $e');
      }
    });
  }

  void close() {
    try {
      if (_overlayEntry != null) {
        _overlayEntry!.remove();
        _entries.remove(_id);
        _overlayEntry = null;
      }
    } catch (e) {
      Get.printError(info: 'ModLoading: Error closing loading - $e');
    }
  }
}

class _ModLoadingWidget extends StatefulWidget {
  final ModLoadingConfig config;
  final VoidCallback? onDismiss;

  const _ModLoadingWidget({
    required this.config,
    this.onDismiss,
  });

  @override
  _ModLoadingWidgetState createState() => _ModLoadingWidgetState();
}

class _ModLoadingWidgetState extends State<_ModLoadingWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    if (widget.config.animate) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Alignment _getAlignment() {
    switch (widget.config.position) {
      case ModLoadingPosition.center:
        return Alignment.center;
      case ModLoadingPosition.left:
        return Alignment.centerLeft;
      case ModLoadingPosition.right:
        return Alignment.centerRight;
      case ModLoadingPosition.topLeft:
        return Alignment.topLeft;
      case ModLoadingPosition.topCenter:
        return Alignment.topCenter;
      case ModLoadingPosition.topRight:
        return Alignment.topRight;
      case ModLoadingPosition.bottomLeft:
        return Alignment.bottomLeft;
      case ModLoadingPosition.bottomCenter:
        return Alignment.bottomCenter;
      case ModLoadingPosition.bottomRight:
        return Alignment.bottomRight;
    }
  }

  Widget _buildLoadingContent() {
    Widget iconWidget;

    if (widget.config.imagePath != null) {
      final image = widget.config.imagePath!.toLowerCase();
      if (image.endsWith('.svg')) {
        iconWidget = SvgPicture.asset(
          widget.config.imagePath!,
          width: widget.config.size,
          height: widget.config.size,
        );
      } else {
        iconWidget = Image.asset(
          widget.config.imagePath!,
          width: widget.config.size,
          height: widget.config.size,
        );
      }
    } else {
      final icon = widget.config.icon ?? Icons.loop;
      iconWidget = RotationTransition(
        turns: _controller,
        child: Icon(
          icon,
          size: widget.config.size,
          color: Colors.white,
        ),
      );
    }

    if (widget.config.title == null) {
      return iconWidget;
    }

    final titleWidget = Text(
      widget.config.title!,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 16,
        decoration: TextDecoration.none,
        fontWeight: FontWeight.normal,
      ),
    );

    return widget.config.orientation == ModLoadingOrientation.horizontal
        ? Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              iconWidget,
              SizedBox(width: widget.config.spacing),
              titleWidget,
            ],
          )
        : Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              iconWidget,
              SizedBox(height: widget.config.spacing),
              titleWidget,
            ],
          );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: GestureDetector(
        onTap: widget.onDismiss,
        child: Container(
          color: Colors.black54,
          child: Align(
            alignment: _getAlignment(),
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: widget.config.padding ?? const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: widget.config.backgroundColor ??
                    Theme.of(context).appBarTheme.backgroundColor,
                borderRadius: BorderRadius.circular(widget.config.borderRadius),
              ),
              child: _buildLoadingContent(),
            ),
          ),
        ),
      ),
    );
  }
}
