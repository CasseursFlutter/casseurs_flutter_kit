class DurationUtils {
  static String format(Duration duration, { String dayUnit = "j", String hourUnit = "h", String minuteUnit = "m"}) {    
    final List<String> elements = [];

    final day = duration.inDays;
    final hour = duration.inHours - duration.inDays*24;
    final minute = duration.inMinutes - duration.inHours*60;

    if (day > 0) elements.add("${day}$dayUnit");
    if (hour > 0 || day > 0) elements.add("${hour}$hourUnit");
    elements.add("${minute}$minuteUnit");

    return elements.join(" ");
  }
}