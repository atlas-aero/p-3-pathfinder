import 'dart:math';

class Segment
{
  final Position position;
  final Point start;
  final Point end;
  final double geoAltitude;

  double _absoluteAltitude = 0;
  bool _touched = false;

  Segment(this.position, this.start, this.end, this.geoAltitude);

  Point get center {
    double halfSize = this.size / 2;
    
    return new Point(
      start.x + halfSize,
      start.y + halfSize,
    );
  }
  
  double get size => end.x - start.x;
  double get absoluteAltitude => _absoluteAltitude;
  double get relativeAltitude => _absoluteAltitude - geoAltitude;
  bool get isTouched => _touched;

  set absoluteAltitude(double value) {
    _absoluteAltitude = value;
  }

  void touch()
  {
    _touched = true;
  }

  Segment clone()
  {
    Segment segment = new Segment(position, start, end, geoAltitude);
    segment.absoluteAltitude = absoluteAltitude;

    return segment;
  }

  Map toMap()
  {
    return {
      'position': position.toMap(),
      'start': {'x': start.x, 'y': start.y},
      'end': {'x': end.x, 'y': end.y},
      'touched': _touched,
      'geoAltitude': geoAltitude,
      'absoluteAltitude': absoluteAltitude
    };
  }
}

class Position
{
  final int x;
  final int y;

  Position(this.x, this.y);

  Map toMap()
  {
    return {'x': x, 'y': y};
  }
}