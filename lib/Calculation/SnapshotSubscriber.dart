import 'package:p3pathfinder/Map/PathfinderMap.dart';
import 'package:p3pathfinder/Map/Segment.dart';

abstract class SnapshotSubscriber
{
  /**
   * Sets the initial state of the map before calculation is started
   */
  void onStarted(PathfinderMap map);

  /**
   * Is called as soon a segment was updated during calculation
   */
  void onSegmentChanged(Segment segment);
}