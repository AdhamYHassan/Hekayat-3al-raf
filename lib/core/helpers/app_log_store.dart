import 'package:flutter/foundation.dart';

/// Simple In-App Circular Buffer Log Store for Production Diagnostic
class AppLogStore {
  AppLogStore._();
  static final AppLogStore instance = AppLogStore._();

  final List<String> _logs = [];
  static const int _maxLogs = 200;

  List<String> get logs => List.unmodifiable(_logs);

  void log(String message) {
    final timestamp = DateTime.now().toIso8601String().substring(11, 19);
    final entry = '[$timestamp] $message';
    _logs.add(entry);
    if (_logs.length > _maxLogs) {
      _logs.removeAt(0);
    }
    if (kDebugMode) {
      debugPrint(entry);
    }
  }

  void clear() {
    _logs.clear();
  }
}
