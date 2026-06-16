import 'dart:collection';
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'web_utils.dart' as web_utils;

enum LogLevel { debug, info, warning, error, fatal }

class LogEntry {
  LogEntry({required this.level, required this.tag, required this.message, this.error, this.stackTrace}) : timestamp = DateTime.now();

  final DateTime timestamp;
  final LogLevel level;
  final String tag;
  final String message;
  final Object? error;
  final StackTrace? stackTrace;

  String format() {
    final buf = StringBuffer();
    buf.write('[${timestamp.toIso8601String()}] ');
    buf.write('[${level.name.toUpperCase().padRight(7)}] ');
    buf.write('[$tag] ');
    buf.write(message);
    if (error != null) {
      buf.write('\n  ERROR: $error');
    }
    if (stackTrace != null) {
      buf.write('\n  STACK: $stackTrace');
    }
    return buf.toString();
  }
}

class LogService {
  LogService._();
  static final LogService instance = LogService._();

  static const int _maxEntries = 5000;

  final Queue<LogEntry> _entries = Queue<LogEntry>();
  final String sessionId = _generateSessionId();

  static String _generateSessionId() {
    final now = DateTime.now();
    return '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}'
        '_${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}${now.second.toString().padLeft(2, '0')}';
  }

  void log(LogLevel level, String tag, String message, {Object? error, StackTrace? stackTrace}) {
    final entry = LogEntry(level: level, tag: tag, message: message, error: error, stackTrace: stackTrace);
    _entries.addLast(entry);
    while (_entries.length > _maxEntries) {
      _entries.removeFirst();
    }
    // Also print to console in debug mode so dev tools still work
    if (kDebugMode) {
      debugPrint(entry.format());
    }
  }

  void debug(String tag, String message) => log(LogLevel.debug, tag, message);
  void info(String tag, String message) => log(LogLevel.info, tag, message);
  void warning(String tag, String message, {Object? error, StackTrace? stackTrace}) => log(LogLevel.warning, tag, message, error: error, stackTrace: stackTrace);
  void error(String tag, String message, {Object? error, StackTrace? stackTrace}) => log(LogLevel.error, tag, message, error: error, stackTrace: stackTrace);
  void fatal(String tag, String message, {Object? error, StackTrace? stackTrace}) => log(LogLevel.fatal, tag, message, error: error, stackTrace: stackTrace);

  /// Captures a raw print() call intercepted by the Zone.
  void captureZonePrint(String line) {
    final entry = LogEntry(level: LogLevel.debug, tag: 'PRINT', message: line);
    _entries.addLast(entry);
    while (_entries.length > _maxEntries) {
      _entries.removeFirst();
    }
  }

  String exportAsText() {
    final buf = StringBuffer();
    buf.writeln('====== SESSION LOG: $sessionId ======');
    buf.writeln('Exported at: ${DateTime.now().toIso8601String()}');
    buf.writeln('Entries: ${_entries.length}');
    buf.writeln('=====================================\n');
    for (final entry in _entries) {
      buf.writeln(entry.format());
    }
    return buf.toString();
  }

  /// Downloads the session log as a .log file via browser download.
  void downloadLogFile() {
    final content = exportAsText();
    final bytes = utf8.encode(content);
    web_utils.downloadBytes(bytes, 'session_$sessionId.log', mimeType: 'text/plain');
  }

  int get entryCount => _entries.length;
  List<LogEntry> get entries => _entries.toList();
}
