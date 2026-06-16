import 'package:intl/intl.dart';

DateTime? _parseFlexibleDateTime(String dateStr) {
  final input = dateStr.trim();
  if (input.isEmpty) return null;

  // Fast path for ISO-like values.
  final direct = DateTime.tryParse(input);
  if (direct != null) return direct;

  // Common backend format seen in logs: 2026/04/05 20:13:06
  final normalized = input.replaceAll('/', '-');
  final normalizedParsed = DateTime.tryParse(normalized);
  if (normalizedParsed != null) return normalizedParsed;

  // Last-resort patterns for non-ISO server payloads.
  for (final pattern in <String>['yyyy/MM/dd HH:mm:ss', 'yyyy-MM-dd HH:mm:ss', 'yyyy/MM/dd HH:mm', 'yyyy-MM-dd HH:mm']) {
    try {
      return DateFormat(pattern).parseStrict(input);
    } catch (_) {
      // try next pattern
    }
  }
  return null;
}

String formatDateYYYYMMDD(DateTime date) {
  return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
}

String formatDateString(String dateStr, {bool endOfDay = false}) {
  DateTime? date = _parseFlexibleDateTime(dateStr);
  if (date == null) return dateStr;
  if (endOfDay) {
    date = DateTime(date.year, date.month, date.day, 23, 59, 59);
  }
  return DateFormat('yyyy/MM/dd HH:mm:ss').format(date);
}

String formatOnlyDateString(String dateStr, {bool endOfDay = false}) {
  DateTime? date = _parseFlexibleDateTime(dateStr);
  if (date == null) return dateStr;
  if (endOfDay) {
    date = DateTime(date.year, date.month, date.day, 23, 59, 59);
  }
  return DateFormat('yyyy-MM-dd').format(date);
}

String formatOnlyTimeString(String dateStr, {bool endOfDay = false}) {
  DateTime? date = _parseFlexibleDateTime(dateStr);
  if (date == null) return dateStr;
  if (endOfDay) {
    date = DateTime(date.year, date.month, date.day, 23, 59, 59);
  }
  return DateFormat('HH:mm').format(date);
}

String formatDateActivityLogsYYYYMMDD(dynamic date) {
  if (date is DateTime) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} 00:00:00.000";
  } else if (date is String && date.length >= 10) {
    final d = DateTime.tryParse(date.substring(0, 10));
    if (d != null) {
      return "${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')} 00:00:00.000";
    }
  }
  return date.toString();
}
