import 'package:flutter/material.dart';

const _defaultSeparator = ":";

class TimeUtils {
  static String format(int hour, int minute, int second, { String? separator, bool showHour = true, bool showMinute = true, bool showSecond = true }) {
    final List<String> elements = [];
    if (showHour) {
      elements.add(hour.toString().padLeft(2, '0'));
    }

    if (showMinute) {
      elements.add(minute.toString().padLeft(2, '0'));
    }

    if (showSecond) {
      elements.add(second.toString().padLeft(2, '0'));
    }


    return elements.join(separator ?? _defaultSeparator);
  }

  static String formatDateTime(DateTime date, { String? separator }) {
    return format(date.hour, date.minute, date.second, separator: separator, showSecond: false);
  }

  static String formatTimeOfDay(TimeOfDay time, { String? separator }) {
    return format(time.hour, time.minute, 0, separator: separator, showSecond: false);
  }

  static String formatDuration(Duration duration, { String? separator, bool showHour = true, bool showMinute = true, bool showSecond = true }) {
    final hour = duration.inHours;
    int minute = duration.inMinutes;
    
    if (showHour) {
      minute -= hour*60;
    }

    int second = duration.inSeconds;
    if (showMinute) {
      second -= duration.inMinutes*60;
    }

    return format(hour, minute, second, separator: separator, showHour: showHour, showMinute: showMinute, showSecond: showSecond);
  }

  static TimeOfDay parseDateTime(DateTime date) {
    return TimeOfDay(
      hour: date.hour,
      minute: date.minute
    );
  }

  static Duration difference(TimeOfDay a, TimeOfDay b) {
    final aMinutes = a.hour*60+a.minute;
    final bMinutes = b.hour*60+b.minute;

    return Duration(minutes: bMinutes-aMinutes);
  }
}