import 'dart:math';

import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
import 'package:vector_math/vector_math.dart';

class Point2D {
  final double x;
  final double y;

  const Point2D(this.x, this.y);

  factory Point2D.fromLatLng(LatLng latLng) {
    return Point2D(latLng.longitude, latLng.latitude);
  }

  LatLng toLatLng() {
    return LatLng(y, x);
  }

  Point2D getCenter(Point2D p2) {
    return Point2D(
      (this.x+p2.x)/2,
      (this.y+p2.y)/2
    );
  }

  bool isOnSegment2D(Segment2D s) {
    return y < max(s.p1.y, s.p2.y)
      && y > min(s.p1.y, s.p2.y)
      && x < max(s.p1.x, s.p2.x)
      && x > min(s.p1.x, s.p2.x);
  }

  Line2D getPerpendicularToLine(Line2D l) {
    return l.getPerpendicularByPoint(this);
  }
}


class Segment2D {
  final Point2D p1;
  final Point2D p2;

  const Segment2D(this.p1, this.p2);

  bool intersect(Line2D l) => getIntersectionPoint2DWithLine2D(l) != null;

  Point2D? getIntersectionPoint2D(Segment2D s) {
    final point = Line2D.fromSegment2D(s).getIntersectionPoint2DWithSegment2D(this);
    return point?.isOnSegment2D(s) == true ? point : null;
  }

  Point2D? getIntersectionPoint2DWithLine2D(Line2D l) {
    return l.getIntersectionPoint2DWithSegment2D(this);    
  }    
}


class Line2D {
  final double a;
  final double b;

  const Line2D(this.a, this.b);

  factory Line2D.fromSegment2D(Segment2D s) {
    final a = ((s.p2.y-s.p1.y)/(s.p2.x-s.p1.x));
    final b = s.p2.y-a*s.p2.x;

    return Line2D(a, b);
  }

  Point2D? getIntersectionPoint2D(Line2D l) {
    Point2D? crossPoint2D;
    if (a != b) {
      final crossx = (l.b-b)/(a-l.a);
      final crossy = l.a*crossx+l.b;

      crossPoint2D = Point2D(crossx, crossy);
    }

    return crossPoint2D;
  }

  Point2D? getIntersectionPoint2DWithSegment2D(Segment2D s) {
    final crossPoint2D = getIntersectionPoint2D(Line2D.fromSegment2D(s));
    return crossPoint2D?.isOnSegment2D(s) == true ? crossPoint2D : null;
  }

  Line2D getPerpendicularByPoint(Point2D p) {
    final a = -1/this.a;
    final b = p.y-a*p.x;

    return Line2D(a, b);
  }

  Point2D? getPerpendicularByPointIntersectionPoint2D(Point2D p) {
    return getIntersectionPoint2D(getPerpendicularByPoint(p));
  }
}


class Vector2Utils {
  static Vector2 fromPoint2Ds(Point2D p1, Point2D p2) {
    return Vector2(
      p2.x-p1.x,
      p2.y-p1.y
    );
  }
}