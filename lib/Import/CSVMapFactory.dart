import 'dart:math';

import 'package:p3pathfinder/Map/PathfinderMap.dart';
import 'package:p3pathfinder/Map/Segment.dart';

class CSVMapFactory
{
  PathfinderMap create(List<String> lines, Point mapStart, double mapSize)
  {
    List<Segment> segments = new List();

    double segmentSize = mapSize / lines.length;

    for (var y = 0; y < lines.length; y++) {
      List<String> items = lines[y].split(';');

      for (var x = 0; x < items.length; x++) {
        Point start = new Point((x * segmentSize) + mapStart.x, (y * segmentSize) + mapStart.y);
        Point end = new Point(start.x + segmentSize, start.y + segmentSize);
        Position position = new Position(x, y);

        segments.add(new Segment(position, start, end, double.parse(items[x])));
      }
    }

    return new PathfinderMap(segments);
  }
}