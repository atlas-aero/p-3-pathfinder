import 'dart:convert';

import 'package:p3pathfinder/Calculation/SnapshotSubscriber.dart';
import 'package:p3pathfinder/Map/PathfinderMap.dart';
import 'package:p3pathfinder/Map/Segment.dart';

class SnapshotJSONExporter implements SnapshotSubscriber
{
  List<Segment> initial;
  List<Segment> changes;

  @override
  void onSegmentChanged(Segment segment)
  {
    changes.add(segment.clone());
  }

  @override
  void onStarted(PathfinderMap map)
  {
    initial = new List();
    changes = new List();

    for (Segment segment in map.allSegments) {
      initial.add(segment.clone());
    }
  }

  String export()
  {
    Map data = new Map<String, dynamic>();

    data['initial'] = new List();
    data['changes'] = new List();

    for (Segment segment in initial) {
      data['initial'].add(segment.toMap());
    }

    for (Segment segment in changes) {
      data['changes'].add(segment.toMap());
    }

    return jsonEncode(data);
  }
}

