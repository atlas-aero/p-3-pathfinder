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
}

class SemanticException implements Exception
{
  final String message;
  SemanticException(this.message);
}