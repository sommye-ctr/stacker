import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:simple_time_range_picker/simple_time_range_picker.dart';

class DateHelper {
  static String convertTimeRangeString(TimeRangeValue v) {
    return "${formatTimeOfDay(v.startTime!)} - ${formatTimeOfDay(v.endTime!)}";
  }

  static String formatTimeOfDay(TimeOfDay d) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, d.hour, d.minute);
    final format = DateFormat.jm();
    return format.format(dt);
  }

  static String convertTimeOfDayToPostgres(TimeOfDay time) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return "${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}:00";
  }

  static TimeOfDay convertPostgresStringToTimeOfDay(String time) {
    final parts = time.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    return TimeOfDay(hour: hour, minute: minute);
  }

  static TimeOfDay convertIso8601ToTimeOfDay(String s) {
    DateTime dateTime = DateTime.parse(s).toLocal();
    return TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);
  }
}
