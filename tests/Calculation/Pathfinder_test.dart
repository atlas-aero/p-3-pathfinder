import 'dart:math';

import 'package:p3pathfinder/Calculation/Pathfinder.dart';
import 'package:p3pathfinder/Map/PathfinderMap.dart';
import 'package:p3pathfinder/Map/Segment.dart';
import "package:test/test.dart";
import 'package:mockito/mockito.dart';

class MapMock extends Mock implements PathfinderMap {}

void main()
{
  test("correct altitude calculated for horizontal path", () {
    MapMock map = new MapMock();
    Pathfinder pathfinder = new Pathfinder(map, 40.0, 9.0);

    Segment center = new Segment(new Position(2, 2), new Point(5.0, 5.0), new Point(7.0, 7.0), 0.0);
    Segment ringSegment = new Segment(new Position(1, 2), new Point(3.0, 5.0), new Point(5.0, 7.0), 0.0);
    
    when(map.ringCount).thenReturn(1);
    when(map.getCenter()).thenReturn(center);
    when(map.getCenterRing(1)).thenReturn([ringSegment]);
    when(map.getNeighbours(ringSegment)).thenReturn([center]);

    pathfinder.process(500.0);

    expect(ringSegment.absoluteAltitude, equals(499.77777777777777));
  });

  test("correct altitude calculated for diagonal path", () {
    MapMock map = new MapMock();
    Pathfinder pathfinder = new Pathfinder(map, 40.0, 9.0);

    Segment center = new Segment(new Position(2, 2), new Point(5.0, 5.0), new Point(7.0, 7.0), 0.0);
    Segment ringSegment = new Segment(new Position(1, 3), new Point(3.0, 7.0), new Point(5.0, 9.0), 0.0);

    when(map.ringCount).thenReturn(1);
    when(map.getCenter()).thenReturn(center);
    when(map.getCenterRing(1)).thenReturn([ringSegment]);
    when(map.getNeighbours(ringSegment)).thenReturn([center]);

    pathfinder.process(500.0);

    expect(ringSegment.absoluteAltitude, equals(499.68573031947267));
  });

  test("not updated if below min altitude", () {
    MapMock map = new MapMock();
    Pathfinder pathfinder = new Pathfinder(map, 40.0, 9.0);

    Segment center = new Segment(new Position(2, 2), new Point(5.0, 5.0), new Point(7.0, 7.0), 470.0);
    Segment ringSegment = new Segment(new Position(1, 2), new Point(3.0, 5.0), new Point(5.0, 7.0), 0.0);

    when(map.ringCount).thenReturn(1);
    when(map.getCenter()).thenReturn(center);
    when(map.getCenterRing(1)).thenReturn([ringSegment]);
    when(map.getNeighbours(ringSegment)).thenReturn([center]);

    pathfinder.process(500.0);

    expect(ringSegment.absoluteAltitude, equals(0.0));
  });

  test("alwas best path (highest abs altitude) choosen", () {
    MapMock map = new MapMock();
    Pathfinder pathfinder = new Pathfinder(map, 40.0, 9.0);

    Segment center = new Segment(new Position(2, 2), new Point(5.0, 5.0), new Point(7.0, 7.0), 0.0);
    Segment otherNeighbour = new Segment(new Position(2, 3), new Point(5.0, 7.0), new Point(7.0, 9.0), 0.0);
    Segment ringSegment = new Segment(new Position(1, 2), new Point(3.0, 5.0), new Point(5.0, 7.0), 0.0);

    when(map.ringCount).thenReturn(1);
    when(map.getCenter()).thenReturn(center);
    when(map.getCenterRing(1)).thenReturn([ringSegment]);
    when(map.getNeighbours(ringSegment)).thenReturn([center, otherNeighbour]);

    pathfinder.process(500.0);

    expect(ringSegment.absoluteAltitude, equals(499.77777777777777));
  });

  test("all rings iterrated", () {
    MapMock map = new MapMock();
    Pathfinder pathfinder = new Pathfinder(map, 40.0, 9.0);

    Segment center = new Segment(new Position(2, 2), new Point(5.0, 5.0), new Point(7.0, 7.0), 500.0);
    Segment ringSegment = new Segment(new Position(1, 2), new Point(3.0, 5.0), new Point(5.0, 7.0), 500.0);

    int callCount = 0;

    when(map.ringCount).thenReturn(2);
    when(map.getCenter()).thenReturn(center);
    when(map.getCenterRing(any)).thenAnswer((Invocation invocation) {
      callCount++;
      return [ringSegment];
    });
    when(map.getNeighbours(ringSegment)).thenReturn([center]);

    pathfinder.process(500.0);

    expect(callCount, equals(2));
  });

  test("itteration stopped if no segment changed", () {
    MapMock map = new MapMock();
    Pathfinder pathfinder = new Pathfinder(map, 40.0, 9.0);

    Segment center = new Segment(new Position(2, 2), new Point(5.0, 5.0), new Point(7.0, 7.0), 0.0);
    Segment ringSegment = new Segment(new Position(1, 2), new Point(3.0, 5.0), new Point(5.0, 7.0), 0.0);

    int callCount = 0;

    when(map.ringCount).thenReturn(2);
    when(map.getCenter()).thenReturn(center);
    when(map.getCenterRing(any)).thenAnswer((Invocation invocation) {
      callCount++;
      return [ringSegment];
    });
    when(map.getNeighbours(ringSegment)).thenReturn([center]);

    pathfinder.process(500.0);

    expect(callCount, equals(4));
  });
}