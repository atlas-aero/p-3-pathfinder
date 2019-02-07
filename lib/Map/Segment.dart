import 'dart:math';

class Segment
{
  final Position position;
  final Point start;
  final Point end;
  final double geoAltitude;

  double _absoluteAltitude = 0;

  Segment(this.position, this.start, this.end, this.geoAltitude);

  Point get center {
    double halfSize = this.size / 2;
    
    return new Point(
      start.x + halfSize,
      start.y + halfSize,
    );
  }
  
  double get size => end.x - start.x;
  double get absoluteAltitude => _absoluteAltitude >= geoAltitude ? _absoluteAltitude : 0;
  double get relativeAltitude => _absoluteAltitude - geoAltitude;

  set absoluteAltitude(double value) {
    _absoluteAltitude = value;
  }

}

class Position
{
  final int x;
  final int y;

  Position(this.x, this.y);
}