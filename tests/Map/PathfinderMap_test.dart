import 'dart:math';

import 'package:p3pathfinder/Map/PathfinderMap.dart';
import 'package:p3pathfinder/Map/Segment.dart';
import "package:test/test.dart";

void main() {
  test("Not a square map => exception thrown", () {
    List<Segment> segments = new List(6);
    SemanticException exception;

    try {
      PathfinderMap map = new PathfinderMap(segments);
    } on SemanticException catch(e) {
      exception = e;
    }

    expect(exception, isNotNull);
    expect(exception.message, 'Invalid segment count => unable to build square map.');
  });

  test("Not center segment possible  => exception thrown", () {
    List<Segment> segments = new List(4);
    SemanticException exception;

    try {
      PathfinderMap map = new PathfinderMap(segments);
    } on SemanticException catch(e) {
      exception = e;
    }

    expect(exception, isNotNull);
    expect(exception.message, 'Dimension size is not odd. Only maps with center segment are supported.');
  });

  test("correct center", () {
    List<Segment> segments = new List();
    for (int x = 0; x < 5; x++) {
      for (int y = 0; y < 5; y++) {
        segments.add(new Segment(new Position(x, y), new Point(1, 2), new Point(3, 4), 100.0));
      }
    }

    PathfinderMap map = new PathfinderMap(segments);
    Segment center = map.getCenter();

    expect(center.position.x, 2);
    expect(center.position.y, 2);
  });

  test("correct center ring", () {
    List<Segment> segments = new List();
    for (int x = 0; x < 9; x++) {
      for (int y = 0; y < 9; y++) {
        segments.add(new Segment(new Position(x, y), new Point(1, 2), new Point(3, 4), 100.0));
      }
    }
    
    PathfinderMap map = new PathfinderMap(segments);
    List<Segment> ring = map.getCenterRing(3);
    
    Map<String, Segment> sortedRing =  new Map();
    for(Segment segment in ring) {
      String key = segment.position.x.toString() + '|' + segment.position.y.toString();
      sortedRing[key] = segment;
    }
    
    List<Position> expectedPositions = [
      new Position(1, 1), new Position(1, 2), new Position(1, 3), new Position(1, 4), new Position(1, 5), new Position(1, 6), new Position(1, 7),
      new Position(7, 1), new Position(7, 2), new Position(7, 3), new Position(7, 4), new Position(7, 5), new Position(7, 6), new Position(7, 7),
      new Position(1, 2), new Position(1, 3), new Position(1, 4), new Position(1, 5), new Position(1, 6),
      new Position(7, 2), new Position(7, 3), new Position(7, 4), new Position(7, 5), new Position(7, 6),
    ];

    for(Position expectedPosition in expectedPositions) {
      String key = expectedPosition.x.toString() + '|' + expectedPosition.y.toString();
      expect(sortedRing.containsKey(key), equals(true), reason: "Expected positon " + key + " not found");
    }
  });

  test("correct neighbours - center", () {
    List<Segment> segments = new List();
    for (int x = 0; x < 5; x++) {
      for (int y = 0; y < 5; y++) {
        segments.add(new Segment(new Position(x, y), new Point(1, 2), new Point(3, 4), 100.0));
      }
    }

    PathfinderMap map = new PathfinderMap(segments);
    List<Segment> result = map.getNeighbours(map.getCenter());

    Map<String, Segment> sortedRing =  new Map();
    for(Segment segment in result) {
      String key = segment.position.x.toString() + '|' + segment.position.y.toString();
      sortedRing[key] = segment;
    }

    List<Position> expectedPositions = [
      new Position(1, 1), new Position(2, 1), new Position(3, 1),
      new Position(1, 2),                     new Position(3, 1),
      new Position(1, 3), new Position(2, 3), new Position(3, 3),
    ];

    expect(result.length, equals(8));
    for(Position expectedPosition in expectedPositions) {
      String key = expectedPosition.x.toString() + '|' + expectedPosition.y.toString();
      expect(sortedRing.containsKey(key), equals(true), reason: "Expected positon " + key + " not found");
    }
  });

  test("correct neighbours - edge", () {
    List<Segment> segments = new List();
    for (int y = 0; y < 5; y++) {
      for (int x = 0; x < 5; x++) {
        segments.add(new Segment(new Position(x, y), new Point(1, 2), new Point(3, 4), 100.0));
      }
    }

    PathfinderMap map = new PathfinderMap(segments);
    List<Segment> result = map.getNeighbours(segments[1]); // 1|0

    Map<String, Segment> sortedRing =  new Map();
    for(Segment segment in result) {
      String key = segment.position.x.toString() + '|' + segment.position.y.toString();
      sortedRing[key] = segment;
    }

    List<Position> expectedPositions = [
      new Position(0, 0),                     new Position(2, 0),
      new Position(0, 1), new Position(1, 1), new Position(2, 1),
    ];

    expect(result.length, equals(5));
    for(Position expectedPosition in expectedPositions) {
      String key = expectedPosition.x.toString() + '|' + expectedPosition.y.toString();
      expect(sortedRing.containsKey(key), equals(true), reason: "Expected positon " + key + " not found");
    }
  });

  test("correct ring count", () {
    List<Segment> segments = new List();
    for (int y = 0; y < 5; y++) {
      for (int x = 0; x < 5; x++) {
        segments.add(new Segment(new Position(x, y), new Point(1, 2), new Point(3, 4), 100.0));
      }
    }

    PathfinderMap map = new PathfinderMap(segments);
    expect(map.ringCount, equals(2));
  });
}