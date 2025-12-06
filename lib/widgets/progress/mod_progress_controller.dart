import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Controller for managing progress widget state using GetX.
/// Supports real-time updates via streaming (e.g., gRPC streaming).
class ModProgressController extends GetxController {
  /// Unique identifier for this progress instance
  final String id;

  /// Observable title text
  final RxString title = ''.obs;

  /// Observable subtitle/message text
  final RxString subtitle = ''.obs;

  /// Observable progress value (0.0 to 1.0)
  /// null means indeterminate progress
  final Rx<double?> progress = Rx<double?>(null);

  /// Observable visibility state
  final RxBool isVisible = false.obs;

  /// Observable completion state
  final RxBool isCompleted = false.obs;

  /// Observable error state
  final RxBool hasError = false.obs;

  /// Observable error message
  final RxString errorMessage = ''.obs;

  /// Stream subscription for real-time updates
  StreamSubscription<ProgressUpdate>? _streamSubscription;

  /// Callback when progress completes
  VoidCallback? onCompleteCallback;

  /// Callback when progress encounters an error
  void Function(String error)? onErrorCallback;

  /// Callback when progress is closed
  VoidCallback? onCloseCallback;

  ModProgressController({required this.id});

  /// Opens the progress widget with initial values
  void open({
    String? title,
    String? subtitle,
    double? initialProgress,
  }) {
    this.title.value = title ?? '';
    this.subtitle.value = subtitle ?? '';
    progress.value = initialProgress;
    isVisible.value = true;
    isCompleted.value = false;
    hasError.value = false;
    errorMessage.value = '';
  }

  /// Updates the title text
  void updateTitle(String newTitle) {
    title.value = newTitle;
  }

  /// Updates the subtitle/message text
  void updateSubtitle(String newSubtitle) {
    subtitle.value = newSubtitle;
  }

  /// Updates the progress value (0.0 to 1.0)
  /// Pass null for indeterminate progress
  void updateProgress(double? value) {
    if (value != null) {
      progress.value = value.clamp(0.0, 1.0);
    } else {
      progress.value = null;
    }
  }

  /// Updates title, subtitle, and progress at once
  void updateAll({
    String? title,
    String? subtitle,
    double? progress,
  }) {
    if (title != null) this.title.value = title;
    if (subtitle != null) this.subtitle.value = subtitle;
    if (progress != null) {
      this.progress.value = progress.clamp(0.0, 1.0);
    }
  }

  /// Marks progress as complete
  void complete({String? message}) {
    progress.value = 1.0;
    isCompleted.value = true;
    if (message != null) subtitle.value = message;
    onCompleteCallback?.call();
  }

  /// Sets error state with message
  void setError(String message) {
    hasError.value = true;
    errorMessage.value = message;
    subtitle.value = message;
    onErrorCallback?.call(message);
  }

  /// Closes the progress widget
  void close() {
    isVisible.value = false;
    _cancelStreamSubscription();
    onCloseCallback?.call();
  }

  /// Connects to a stream for real-time progress updates
  /// Useful for gRPC streaming or other async sources
  void connectToStream(Stream<ProgressUpdate> stream) {
    _cancelStreamSubscription();
    _streamSubscription = stream.listen(
      (update) {
        if (update.title != null) updateTitle(update.title!);
        if (update.subtitle != null) updateSubtitle(update.subtitle!);
        if (update.progress != null) updateProgress(update.progress);
        if (update.isCompleted) complete(message: update.subtitle);
        if (update.hasError) setError(update.errorMessage ?? 'Unknown error');
      },
      onError: (error) {
        setError(error.toString());
      },
      onDone: () {
        if (!hasError.value && !isCompleted.value) {
          complete();
        }
      },
    );
  }

  /// Cancels any active stream subscription
  void _cancelStreamSubscription() {
    _streamSubscription?.cancel();
    _streamSubscription = null;
  }

  @override
  void onClose() {
    _cancelStreamSubscription();
    super.onClose();
  }

  /// Resets the controller to initial state
  void reset() {
    title.value = '';
    subtitle.value = '';
    progress.value = null;
    isVisible.value = false;
    isCompleted.value = false;
    hasError.value = false;
    errorMessage.value = '';
    _cancelStreamSubscription();
  }
}

/// Data class for streaming progress updates
class ProgressUpdate {
  final String? title;
  final String? subtitle;
  final double? progress;
  final bool isCompleted;
  final bool hasError;
  final String? errorMessage;

  const ProgressUpdate({
    this.title,
    this.subtitle,
    this.progress,
    this.isCompleted = false,
    this.hasError = false,
    this.errorMessage,
  });

  /// Creates a progress update with just a message
  factory ProgressUpdate.message(String message) {
    return ProgressUpdate(subtitle: message);
  }

  /// Creates a progress update with progress value
  factory ProgressUpdate.withProgress(double progress, {String? message}) {
    return ProgressUpdate(progress: progress, subtitle: message);
  }

  /// Creates a completion update
  factory ProgressUpdate.complete({String? message}) {
    return ProgressUpdate(isCompleted: true, subtitle: message, progress: 1.0);
  }

  /// Creates an error update
  factory ProgressUpdate.error(String message) {
    return ProgressUpdate(hasError: true, errorMessage: message);
  }
}
