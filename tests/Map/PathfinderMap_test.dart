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
}