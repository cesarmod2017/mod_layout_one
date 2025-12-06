import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'mod_progress.dart';
import 'mod_progress_controller.dart';

/// Manager class for showing progress overlays.
/// Supports multiple independent progress instances.
class ModProgressManager {
  static final ModProgressManager _instance = ModProgressManager._internal();
  factory ModProgressManager() => _instance;
  ModProgressManager._internal();

  /// Map of active progress entries by ID
  final Map<String, _ProgressEntry> _activeProgress = {};

  /// Counter for generating unique IDs
  int _idCounter = 0;

  /// Shows a progress overlay with the given configuration.
  /// Returns a [ModProgressController] for controlling the progress.
  ModProgressController show({
    String? id,
    ModProgressConfig config = const ModProgressConfig(),
    String? title,
    String? subtitle,
    double? initialProgress,
    VoidCallback? onComplete,
    void Function(String error)? onError,
    VoidCallback? onClose,
  }) {
    final progressId = id ?? 'progress_${_idCounter++}';

    // If a progress with this ID already exists, return its controller
    if (_activeProgress.containsKey(progressId)) {
      final existingController = _activeProgress[progressId]!.controller;
      existingController.open(
        title: title ?? config.title,
        subtitle: subtitle ?? config.subtitle,
        initialProgress: initialProgress ?? config.initialProgress,
      );
      return existingController;
    }

    // Create new controller
    final controller = ModProgressController(id: progressId);
    controller.onCompleteCallback = onComplete;
    controller.onErrorCallback = onError;
    controller.onCloseCallback = () {
      _removeProgress(progressId);
      onClose?.call();
    };

    // Open with initial values
    controller.open(
      title: title ?? config.title,
      subtitle: subtitle ?? config.subtitle,
      initialProgress: initialProgress ?? config.initialProgress,
    );

    // Register with GetX
    Get.put(controller, tag: progressId);

    // Create overlay entry
    final overlayEntry = OverlayEntry(
      builder: (context) => Material(
        type: MaterialType.transparency,
        child: ModProgress(
          controller: controller,
          config: config,
          onClose: () => close(progressId),
        ),
      ),
    );

    _activeProgress[progressId] = _ProgressEntry(
      controller: controller,
      overlayEntry: overlayEntry,
    );

    // Insert overlay
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _insertOverlay(overlayEntry);
    });

    return controller;
  }

  /// Shows a progress overlay that listens to a stream for updates.
  /// Useful for gRPC streaming or other async progress sources.
  ModProgressController showWithStream({
    required Stream<ProgressUpdate> stream,
    String? id,
    ModProgressConfig config = const ModProgressConfig(),
    String? title,
    String? subtitle,
    VoidCallback? onComplete,
    void Function(String error)? onError,
    VoidCallback? onClose,
    bool autoCloseOnComplete = false,
    Duration? autoCloseDelay,
  }) {
    // Generate ID first if not provided
    final progressId = id ?? 'progress_$_idCounter';

    final controller = show(
      id: progressId,
      config: config,
      title: title,
      subtitle: subtitle,
      onComplete: () {
        onComplete?.call();
        if (autoCloseOnComplete) {
          if (autoCloseDelay != null) {
            Future.delayed(autoCloseDelay, () {
              close(progressId);
            });
          } else {
            close(progressId);
          }
        }
      },
      onError: onError,
      onClose: onClose,
    );

    controller.connectToStream(stream);

    return controller;
  }

  void _insertOverlay(OverlayEntry entry) {
    try {
      final context = Get.overlayContext;
      if (context != null) {
        Navigator.of(context).overlay?.insert(entry);
      } else {
        Get.printError(info: 'ModProgressManager: No overlay context found');
      }
    } catch (e) {
      Get.printError(info: 'ModProgressManager: Error showing progress - $e');
    }
  }

  /// Gets the controller for a progress by ID
  ModProgressController? getController(String id) {
    return _activeProgress[id]?.controller;
  }

  /// Updates an existing progress by ID
  void updateProgress(
    String id, {
    String? title,
    String? subtitle,
    double? progress,
  }) {
    final controller = _activeProgress[id]?.controller;
    controller?.updateAll(
      title: title,
      subtitle: subtitle,
      progress: progress,
    );
  }

  /// Closes a specific progress by ID
  void close(String id) {
    _removeProgress(id);
  }

  /// Closes all active progress overlays
  void closeAll() {
    final ids = List<String>.from(_activeProgress.keys);
    for (final id in ids) {
      _removeProgress(id);
    }
  }

  void _removeProgress(String id) {
    final entry = _activeProgress.remove(id);
    if (entry != null) {
      try {
        entry.overlayEntry.remove();
        entry.controller.close();
        Get.delete<ModProgressController>(tag: id);
      } catch (e) {
        Get.printError(info: 'ModProgressManager: Error removing progress - $e');
      }
    }
  }

  /// Checks if a progress with the given ID is active
  bool isActive(String id) {
    return _activeProgress.containsKey(id);
  }

  /// Gets the count of active progress overlays
  int get activeCount => _activeProgress.length;

  /// Gets all active progress IDs
  List<String> get activeIds => List.from(_activeProgress.keys);
}

/// Internal class to hold progress entry data
class _ProgressEntry {
  final ModProgressController controller;
  final OverlayEntry overlayEntry;

  _ProgressEntry({
    required this.controller,
    required this.overlayEntry,
  });
}

/// Extension methods for easy access to progress manager
extension ModProgressManagerExtension on GetInterface {
  /// Gets the singleton progress manager instance
  ModProgressManager get progressManager => ModProgressManager();

  /// Shows a progress overlay
  ModProgressController showProgress({
    String? id,
    ModProgressConfig config = const ModProgressConfig(),
    String? title,
    String? subtitle,
    double? initialProgress,
    VoidCallback? onComplete,
    void Function(String error)? onError,
    VoidCallback? onClose,
  }) {
    return ModProgressManager().show(
      id: id,
      config: config,
      title: title,
      subtitle: subtitle,
      initialProgress: initialProgress,
      onComplete: onComplete,
      onError: onError,
      onClose: onClose,
    );
  }

  /// Shows a progress overlay with stream updates
  ModProgressController showProgressWithStream({
    required Stream<ProgressUpdate> stream,
    String? id,
    ModProgressConfig config = const ModProgressConfig(),
    String? title,
    String? subtitle,
    VoidCallback? onComplete,
    void Function(String error)? onError,
    VoidCallback? onClose,
    bool autoCloseOnComplete = false,
    Duration? autoCloseDelay,
  }) {
    return ModProgressManager().showWithStream(
      stream: stream,
      id: id,
      config: config,
      title: title,
      subtitle: subtitle,
      onComplete: onComplete,
      onError: onError,
      onClose: onClose,
      autoCloseOnComplete: autoCloseOnComplete,
      autoCloseDelay: autoCloseDelay,
    );
  }

  /// Closes a progress by ID
  void closeProgress(String id) {
    ModProgressManager().close(id);
  }

  /// Closes all active progress overlays
  void closeAllProgress() {
    ModProgressManager().closeAll();
  }
}
