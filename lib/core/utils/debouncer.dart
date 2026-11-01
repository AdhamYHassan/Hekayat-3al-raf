import 'dart:async';
import 'package:flutter/foundation.dart';

/// Reusable utility to debounce user input (search fields, slider scrubbing).
///
/// Ensures asynchronous actions only fire after [delay] of typing inactivity,
/// preventing network contention, race conditions, and battery drain.
class Debouncer {
  final Duration delay;
  Timer? _timer;

  Debouncer({this.delay = const Duration(milliseconds: 350)});

  void run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(delay, action);
  }

  void dispose() {
    _timer?.cancel();
    _timer = null;
  }
}

