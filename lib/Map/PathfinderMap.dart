import 'dart:math';

import 'Segment.dart';

class PathfinderMap
{
  List<List<Segment>> _segments;

  PathfinderMap(List<Segment> segments)
  {
    this.setSegments(segments);
  }

  Segment getCenter()
  {
    int position = (_segments.length / 2).floor();
    return _segments[position][position];
  }

  List<Segment> getCenterRing(int offset)
  {
    List<Segment> result = new List();
    Position center = getCenter().position;

    for (int i = 0 - offset; i <= offset; i++) {
      result.add(_segments[center.x - offset][center.y - i]);
      result.add(_segments[center.x + offset][center.y - i]);
    }

    for (int i = 0 - (offset - 1); i <= (offset - 1); i++) {
      result.add(_segments[center.x - i][center.y - offset]);
      result.add(_segments[center.x - i][center.y + offset]);
    }

    return result;
  }

  List<Segment> getNeighbours(Segment segment)
  {
    List<Segment> result = new List();

    _addSegmentIfExists(segment.position.x, segment.position.y - 1, result);
    _addSegmentIfExists(segment.position.x, segment.position.y + 1, result);
    _addSegmentIfExists(segment.position.x + 1, segment.position.y, result);
    _addSegmentIfExists(segment.position.x - 1, segment.position.y, result);

    _addSegmentIfExists(segment.position.x - 1, segment.position.y - 1, result);
    _addSegmentIfExists(segment.position.x - 1, segment.position.y + 1, result);
    _addSegmentIfExists(segment.position.x + 1, segment.position.y + 1, result);
    _addSegmentIfExists(segment.position.x + 1, segment.position.y - 1, result);

    return result;
  }

  void setSegments(List<Segment> segments)
  {
    int dimensionSize = sqrt(segments.length).floor();

    if (pow(dimensionSize,2) != segments.length) {
      throw new SemanticException('Invalid segment count => unable to build square map.');
    }

    if (!dimensionSize.isOdd) {
      throw new SemanticException('Dimension size is not odd. Only maps with center segment are supported.');
    }


    _segments = new List(dimensionSize);
    for (int i = 0; i < dimensionSize; i++) {
      _segments[i] = new List(dimensionSize);
    }

    for(Segment segment in segments) {
      _segments[segment.position.x][segment.position.y] = segment;
    }
  }

  int get ringCount
  {
    return ((_segments.length - 1) / 2).floor();
  }

  void _addSegmentIfExists(int x, int y, List<Segment> list)
  {
    int dimensionSize = _segments.length;

    if (x < dimensionSize && x >= 0
        && y < dimensionSize && y >= 0) {
      list.add(_segments[x][y]);
    }
  }

  List<Segment> get allSegments
  {
    List<Segment> allSegments = new List();

    for (List<Segment> row in _segments) {
      allSegments.addAll(row);
    }

    return allSegments;
  }

  List<List<Segment>> get segments => _segments;
}

class SemanticException implements Exception
{
  final String message;
  SemanticException(this.message);
}