import 'dart:math';

import 'package:p3pathfinder/Import/CSVMapFactory.dart';
import 'package:p3pathfinder/Map/PathfinderMap.dart';
import 'package:p3pathfinder/Map/Segment.dart';
import "package:test/test.dart";

void main() {
  test("correct CSV to Segment parsing", () {
    List<String> source = [
      '100.1;100.2;100.3',
      '200.1;200.2;200.3',
      '300.1;300.2;300.3',
    ];

    CSVMapFactory factory = CSVMapFactory();
    PathfinderMap map = factory.create(source, new Point(500.0, 700.0), 900);
    List<Segment> segments = map.allSegments;

    expect(segments.length, equals(9));
    expect(segments[0].position.x, equals(0));
    expect(segments[0].position.y, equals(0));
    expect(segments[0].start.x, equals(500.0));
    expect(segments[0].start.y, equals(700.0));
    expect(segments[0].end.x, equals(800.0));
    expect(segments[0].end.y, equals(1000.0));
    expect(segments[0].geoAltitude, equals(100.1));

    expect(segments[4].position.x, equals(1));
    expect(segments[4].position.y, equals(1));
    expect(segments[4].start.x, equals(800.0));
    expect(segments[4].start.y, equals(1000.0));
    expect(segments[4].end.x, equals(1100.0));
    expect(segments[4].end.y, equals(1300.0));
    expect(segments[4].geoAltitude, equals(200.2));

    expect(segments[8].position.x, equals(2));
    expect(segments[8].position.y, equals(2));
    expect(segments[8].start.x, equals(1100.0));
    expect(segments[8].start.y, equals(1300.0));
    expect(segments[8].end.x, equals(1400.0));
    expect(segments[8].end.y, equals(1600.0));
    expect(segments[8].geoAltitude, equals(300.3));
  });
}