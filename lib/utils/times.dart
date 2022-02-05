import 'package:flutter/material.dart';

const _defaultSeparator = ":";

class TimeUtils {
  static String format(int hour, int minute, { String? separator }) {
    return "${hour.toString().padLeft(2, '0')}${separator ?? _defaultSeparator}${minute.toString().padLeft(2, '0')}";
  }

  static String formatDateTime(DateTime date, { String? separator }) {
    return format(date.hour, date.minute, separator: separator);
  }

  static String formatTimeOfDay(TimeOfDay time, { String? separator }) {
    return format(time.hour, time.minute, separator: separator);
  }

  static String formatDuration(Duration duration, { String? separator }) {
    final hour = duration.inHours;
    final minute = duration.inMinutes - hour*60;

    return format(hour, minute, separator: separator);
  }

  static TimeOfDay parseDateTime(DateTime date) {
    return TimeOfDay(
      hour: date.hour,
      minute: date.minute
    );
  }
}