import 'package:p3pathfinder/Map/PathfinderMap.dart';
import 'package:p3pathfinder/Map/Segment.dart';

class Pathfinder
{
  final PathfinderMap map;
  final double minAltitude;
  final double glideAngle;

  Pathfinder(this.map, this.minAltitude, this.glideAngle);

  void process(double centerAltitude)
  {
    map.getCenter().absoluteAltitude = centerAltitude;
    bool segmentChanged = true;

    do {
      segmentChanged = _iterate();
    } while (segmentChanged);
  }

  bool _iterate()
  {
    int ringCount = map.ringCount;
    bool segmentChanged = false;

    for (int i = 1; i <= ringCount; i++) {
      List<Segment> ring = map.getCenterRing(i);

      for (Segment segment in ring) {
        if (_checkNeighbours(segment)) {
          segmentChanged = true;
        }
      }
    }

    return segmentChanged;
  }

  bool _checkNeighbours(Segment segment)
  {
    bool segmentChanged = false;
    List<Segment> neighbours = map.getNeighbours(segment);

    for (Segment neighbour in neighbours) {
      if (neighbour.relativeAltitude < minAltitude) {
        continue;
      }

      double distance = segment.center.distanceTo(neighbour.center);
      double newAbsAltitude = neighbour.absoluteAltitude - (distance / glideAngle);

      if (newAbsAltitude > segment.absoluteAltitude) {
        segment.absoluteAltitude = newAbsAltitude;
        segmentChanged = true;
      }
    }

    return segmentChanged;
  }
}