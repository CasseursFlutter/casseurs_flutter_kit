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
    return y <= max(s.p1.y, s.p2.y)
      && y >= min(s.p1.y, s.p2.y)
      && x <= max(s.p1.x, s.p2.x)
      && x >= min(s.p1.x, s.p2.x);
  }

  Line2D getPerpendicularToLine(Line2D l) {
  return l.getPerpendicularByPoint(this);
  }

  Point2D? getPerdendicularPoint2DOnSegment2D(Segment2D s) {
    final segmentLine = Line2D.fromSegment2D(s);
    final intersectionPerpendicularPoint = segmentLine.getIntersectionPoint2D(segmentLine.getPerpendicularByPoint(this));
    return (intersectionPerpendicularPoint?.isOnSegment2D(s) ?? false)
      ? intersectionPerpendicularPoint
      : null;
  }
}


class Segment2D {
  final Point2D p1;
  final Point2D p2;

  const Segment2D(this.p1, this.p2);

  bool intersect(Line2D l) => getIntersectionPoint2DWithLine2D(l) != null;

  Point2D? getIntersectionPoint2D(Segment2D s) {    
    final point = Line2D.fromSegment2D(s).getIntersectionPoint2D(Line2D.fromSegment2D(this));
    return point?.isOnSegment2D(this) == true && point?.isOnSegment2D(s) == true ? point : null;
  }

  Point2D? getIntersectionPoint2DWithLine2D(Line2D l) {
    return l.getIntersectionPoint2DWithSegment2D(this);    
  }    
}


// y = ax + b
abstract class Line2D {
  const Line2D();

  factory Line2D.fromPoint2Ds(Point2D p1, Point2D p2) {    
    if (p2.x == p1.x) {
      return VerticalLine2D(p2.x);
    }

    final a = ((p2.y-p1.y)/(p2.x-p1.x));
    final b = p2.y-a*p2.x;

    return BasicLine2D(a, b);
  }

  factory Line2D.fromSegment2D(Segment2D s) {
    return Line2D.fromPoint2Ds(s.p1, s.p2);
  }

  Point2D? getIntersectionPoint2D(Line2D l) {
    if (this is VerticalLine2D) {
      
      if (l is VerticalLine2D) return null;

      final vLine = this as VerticalLine2D;
      final bLine = l as BasicLine2D;

      return Point2D(vLine.x, bLine.a*vLine.x+bLine.b);
    } else {
      final bLine = this as BasicLine2D;
      if (l is VerticalLine2D) {
        final vLine  = l as VerticalLine2D;
        return Point2D(vLine.x, bLine.a*vLine.x+bLine.b);                
      }

      final bLinePrime = l as BasicLine2D;
      final crossx = (bLinePrime.b-bLine.b)/(bLine.a-bLinePrime.a);
      final crossy = bLine.a*crossx+bLine.b;

      return Point2D(crossx, crossy);
    }
  }    
  
  Point2D? getIntersectionPoint2DWithSegment2D(Segment2D s) {    
    final crossPoint2D = getIntersectionPoint2D(Line2D.fromSegment2D(s));    
    return crossPoint2D?.isOnSegment2D(s) == true ? crossPoint2D! : null;    
  }
  
  Line2D getPerpendicularByPoint(Point2D p) {
    if (this is VerticalLine2D) {
      final double a = 0;
      final b = p.y;

      return BasicLine2D(a, b);      
    } else {
      final basicLine = this as BasicLine2D;
      
      if (basicLine.a == 0) {
        return VerticalLine2D(p.x);
      }

      final a = -1/basicLine.a;
      final b = p.y-a*p.x;

      return BasicLine2D(a, b);  
    }
  }
}

class BasicLine2D extends Line2D {
  final double a;
  final double b;

  const BasicLine2D(this.a, this.b) : super();
}

class VerticalLine2D extends Line2D {
  final double x;

  const VerticalLine2D(this.x) : super();  
}


class Vector2Utils {
  static Vector2 fromPoint2Ds(Point2D p1, Point2D p2) {
    return Vector2(
      p2.x-p1.x,
      p2.y-p1.y
    );
  }
}


// (x - center.x)^2 + (y - center.y)^2 = r^2
// class Circle2D {
//   final Point2D center;
//   final double radius;

//   const Circle2D(this.center, this.radius);

//   void intersectLine() {
//     // double cx = center.x + (radius * )

//   }
// }