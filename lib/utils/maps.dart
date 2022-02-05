class MapUtils {
  static writeNotNull(Map<String, dynamic> data, String key, dynamic value) {
    if (value != null) {
      data[key] = value;
    }
  }

  static writeNotNullAndNotEmpty(Map<String, dynamic> data, String key, String? value) {
    if (value?.isNotEmpty ?? false) {
      writeNotNull(data, key, value);
    }
  }

  static writeNotNullAndNotZero(Map<String, dynamic> data, String key, num? value) {
    if ((value ?? 0) > 0) {
      writeNotNull(data, key, value);
    }
  }
}