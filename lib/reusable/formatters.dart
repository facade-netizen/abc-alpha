import 'package:intl/intl.dart';

const String dateFormatForTable = "dd-MM-yyyy hh:mm:ss a";
const String yyyymmdd = 'yyyy-MM-dd';
DateFormat yyyymmddFormat = DateFormat(yyyymmdd);

String formattedDate(DateTime date, {String? format}) {
  return DateFormat(format ?? "dd-MM-yyyy").format(date.toLocal());
}

String formattedDateFromISO(String? isoString) {
  if (isoString == null || isoString.isEmpty) {
    return DateFormat("dd-MM-yyyy hh:mm:ss a").format(DateTime.now());
  }
  try {
    final dateTime = DateTime.parse(isoString).toLocal();
    final customFormat = DateFormat("dd-MM-yyyy hh:mm:ss a");
    return customFormat.format(dateTime);
  } catch (e) {
    return "Invalid date format";
  }
}

///
String formatUtcToLocal(String utcTimeString) {
  DateTime utcTime = DateTime.parse(utcTimeString);
  DateTime localTime = utcTime.toLocal();
  DateTime now = DateTime.now();
  DateTime localDate = DateTime(localTime.year, localTime.month, localTime.day);
  DateTime nowDate = DateTime(now.year, now.month, now.day);
  int differenceInDays = localDate.difference(nowDate).inDays;
  String formattedTime;
  if (differenceInDays == 0) {
    if (localTime.isBefore(now) || localTime.isAtSameMomentAs(now)) {
      formattedTime = "In-Play";
    } else {
      formattedTime = "Today ${DateFormat.Hm().format(localTime)}";
    }
  } else if (differenceInDays == 1) {
    formattedTime = 'Tomorrow ${DateFormat.Hm().format(localTime)}';
  } else {
    formattedTime = DateFormat.yMMMMd().add_jm().format(localTime);
  }
  return formattedTime;
}

String formatUpcomingEvents(String utcTimeString) {
  DateTime utcTime = DateTime.parse(utcTimeString);
  DateTime localTime = utcTime.toLocal();
  DateTime now = DateTime.now();

  DateTime localDate = DateTime(localTime.year, localTime.month, localTime.day);
  DateTime nowDate = DateTime(now.year, now.month, now.day);
  int differenceInDays = localDate.difference(nowDate).inDays;
  String formattedTime;
  if (differenceInDays == 0) {
    formattedTime = 'Today ${DateFormat.Hm().format(localTime)}';
  } else if (differenceInDays == 1) {
    formattedTime = 'Tomorrow ${DateFormat.Hm().format(localTime)}';
  } else {
    formattedTime = DateFormat.yMMMMd().add_jm().format(localTime);
  }
  return formattedTime;
}

String formattedAmounts(double number) {
  if (number == 0) return "0.00";

  final units = ["", "K", "M", "B", "T", "E"];
  int unitIndex = 0;
  double value = number;
  while (value.abs() >= 1000 && unitIndex < units.length - 1) {
    value /= 1000;
    unitIndex++;
  }
  double truncated = (value * 100).truncateToDouble() / 100;
  if (unitIndex == 0) {
    return NumberFormat("#,##0.00", "en_US").format(truncated);
  }
  return "${truncated.toStringAsFixed(2)} ${units[unitIndex]}";
}
String stringDateToDateTimeString(String dateString, {bool startOfDay = true}) {
  // Parse the string to DateTime
  final date = DateTime.parse(dateString);

  // Format as "YYYY-MM-DD HH:MM:SS.SSS"
  final year = date.year.toString().padLeft(4, '0');
  final month = date.month.toString().padLeft(2, '0');
  final day = date.day.toString().padLeft(2, '0');

  final time = startOfDay ? '00:00:00.000' : '23:59:59.999';

  return "$year-$month-$day $time";
}