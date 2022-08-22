import '../casseurs_flutter_kit.dart';

class MapUtils {
  static writeNotNull(Map<String, dynamic> data, String key, dynamic value) {
    if (value != null) {
      data[key] = value;
    }
  }

  static writeNotNullNullable(Map<String, dynamic> data, String key, Nullable? nullable) {
    if (nullable != null) {
      data[key] = nullable.value;
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