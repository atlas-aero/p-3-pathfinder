import 'dart:math';

import 'package:p3pathfinder/Calculation/SnapshotSubscriber.dart';
import 'package:p3pathfinder/Map/PathfinderMap.dart';
import 'package:p3pathfinder/Map/Segment.dart';

class Pathfinder
{
  final PathfinderMap map;
  final SnapshotSubscriber subscriber;
  
  final double minAltitude;
  final double glideAngle;

  Pathfinder(this.map, {this.subscriber = null, this.minAltitude = 40.0, this.glideAngle = 9.0});

  void process(double centerAltitude)
  {
    map.getCenter().absoluteAltitude = centerAltitude;
    bool segmentChanged = true;

    if (subscriber != null) {
      subscriber.onStarted(map);
    }

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

    List<double> altitudes = new List();

    for (Segment neighbour in neighbours) {
      if (neighbour.relativeAltitude < minAltitude) {
        continue;
      }

      double distance = segment.center.distanceTo(neighbour.center);
      double altitude = neighbour.absoluteAltitude - (distance / glideAngle);
      altitudes.add(altitude);
    }

    double maxAltitude = altitudes.isEmpty ? 0.0 : altitudes.reduce(max);

    if (maxAltitude >= segment.geoAltitude
        && maxAltitude > segment.absoluteAltitude) {
      segment.absoluteAltitude = maxAltitude;
      _snapshot(segment);
      segmentChanged = true;
    }

    return segmentChanged;
  }

  void _snapshot(Segment segment)
  {
    if (subscriber != null) {
      subscriber.onSegmentChanged(segment);
    }
  }
}