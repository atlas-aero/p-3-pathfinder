import 'dart:math';

import 'package:p3pathfinder/Export/SnapshotJsonExporter.dart';
import 'package:p3pathfinder/Map/PathfinderMap.dart';
import 'package:p3pathfinder/Map/Segment.dart';
import "package:test/test.dart";

void main() {
  test("correct JSON encoding", () {
    List<Segment> segments = new List();
    for (int x = 0; x < 3; x++) {
      for (int y = 0; y < 3; y++) {
        segments.add(new Segment(new Position(x, y), new Point(x * 101.33, x * 246.31), new Point(x * 4979.281, x * 4697.231), 100.0));
      }
    }

    PathfinderMap map = new PathfinderMap(segments);

    SnapshotJSONExporter exporter = new SnapshotJSONExporter();
    exporter.onStarted(map);
    exporter.onSegmentChanged(segments[2]);

    expect(exporter.export(), equals('{"initial":[{"position":{"x":0,"y":0},"start":{"x":0.0,"y":0.0},"end":{"x":0.0,"y":0.0},"geoAltitude":100.0,"absoluteAltitude":0.0},{"position":{"x":0,"y":1},"start":{"x":0.0,"y":0.0},"end":{"x":0.0,"y":0.0},"geoAltitude":100.0,"absoluteAltitude":0.0},{"position":{"x":0,"y":2},"start":{"x":0.0,"y":0.0},"end":{"x":0.0,"y":0.0},"geoAltitude":100.0,"absoluteAltitude":0.0},{"position":{"x":1,"y":0},"start":{"x":101.33,"y":246.31},"end":{"x":4979.281,"y":4697.231},"geoAltitude":100.0,"absoluteAltitude":0.0},{"position":{"x":1,"y":1},"start":{"x":101.33,"y":246.31},"end":{"x":4979.281,"y":4697.231},"geoAltitude":100.0,"absoluteAltitude":0.0},{"position":{"x":1,"y":2},"start":{"x":101.33,"y":246.31},"end":{"x":4979.281,"y":4697.231},"geoAltitude":100.0,"absoluteAltitude":0.0},{"position":{"x":2,"y":0},"start":{"x":202.66,"y":492.62},"end":{"x":9958.562,"y":9394.462},"geoAltitude":100.0,"absoluteAltitude":0.0},{"position":{"x":2,"y":1},"start":{"x":202.66,"y":492.62},"end":{"x":9958.562,"y":9394.462},"geoAltitude":100.0,"absoluteAltitude":0.0},{"position":{"x":2,"y":2},"start":{"x":202.66,"y":492.62},"end":{"x":9958.562,"y":9394.462},"geoAltitude":100.0,"absoluteAltitude":0.0}],"changes":[{"position":{"x":0,"y":2},"start":{"x":0.0,"y":0.0},"end":{"x":0.0,"y":0.0},"geoAltitude":100.0,"absoluteAltitude":0.0}]}'));
  });
}