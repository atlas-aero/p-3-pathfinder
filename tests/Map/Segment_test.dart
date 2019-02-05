import 'dart:math';

import 'package:p3pathfinder/Map/Segment.dart';
import "package:test/test.dart";

void main() {
  test("absoluteAltitude getter returns 0 if below geo altitude", () {
    Segment segment = new Segment(new Position(1, 2), new Point(1, 2), new Point(3, 4), 500);
    segment.absoluteAltitude = 499;

    expect(segment.absoluteAltitude, equals(0));
  });

  test("absoluteAltitude getter returns correct value if euqal to geo altitude", () {
    Segment segment = new Segment(new Position(1, 2), new Point(1, 2), new Point(3, 4), 500);
    segment.absoluteAltitude = 500;

    expect(segment.absoluteAltitude, equals(500));
  });

  test("absoluteAltitude getter returns correct value if above to geo altitude", () {
    Segment segment = new Segment(new Position(1, 2), new Point(1, 2), new Point(3, 4), 500);
    segment.absoluteAltitude = 501;

    expect(segment.absoluteAltitude, equals(501));
  });
}