import 'dart:math';

import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';

enum GeoCoordinateType {
  latitude,
  longitude
}

class GeoUtils {
  static double earthRadius = 6378000;

  static String convertDecimalToDegrees(double decimal, GeoCoordinateType type) {
    final absDecimal = decimal.abs();

    final degree = decimal.truncate();
    final minutes = ((decimal - degree)*60).truncate();
    final secondes = 3600*(decimal-degree)-60*minutes;

    late String letter;
    if (type == GeoCoordinateType.latitude) {
      letter = degree > 0 ? "N" : "S";
    } else {
      letter = degree > 0 ? "E" : "O";
    }    

    return "${degree.abs()}°${letter} ${minutes.abs()}' ${secondes.abs().toStringAsFixed(3)}''";
  }

  static LatLng translate(LatLng latLng, {double dLat = 0, double dLong = 0}) {
    final latitude = latLng.latitude + (dLat / earthRadius) * (180 / pi);
    final longitude = latLng.longitude + (dLong / earthRadius) * (180 / pi) / cos(latLng.latitude * pi/180);

    return LatLng(latitude, longitude);
  }  
}