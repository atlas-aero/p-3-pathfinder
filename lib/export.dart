library p3_pathfinder;

import 'dart:math';
import 'dart:io';
import 'dart:convert';
import 'dart:async';

import 'package:p3pathfinder/Calculation/Pathfinder.dart';
import 'package:p3pathfinder/Export/SnapshotJsonExporter.dart';
import 'package:p3pathfinder/Import/CSVMapFactory.dart';
import 'package:p3pathfinder/Map/PathfinderMap.dart';
import 'package:p3pathfinder/Map/Segment.dart';

void main(List<String> args)
{
  _Arguments arguments = _parseArguments(args);

  File importFile = new File(arguments.inputFilePath);
  Stream<List<int>> inputStream = importFile.openRead();
  List<String> inputData = new List();

  inputStream
      .transform(utf8.decoder)
      .transform(new LineSplitter())
      .listen((String line) {
        inputData.add(line);
      },
      onDone: () {
        _start(inputData, arguments);
      },
      onError: (e) { print(e.toString()); exit(-1);});
}

void _start(List<String> inputData, _Arguments arguments)
{
  CSVMapFactory factory = new CSVMapFactory();
  SnapshotJSONExporter exporter = new SnapshotJSONExporter();

  PathfinderMap map = factory.create(inputData, arguments.mapStart, arguments.mapSize);

  Pathfinder pathfinder = new Pathfinder(map, subscriber: exporter, minAltitude: arguments.minAltitude);
  pathfinder.process(arguments.centerAltitude);

  String exportData = exporter.export();
  File exportFile = new File(arguments.exportFilePath);
  exportFile.openWrite().write(exportData);

  _printResult(map);
}

void _printResult(PathfinderMap map)
{
  int dimensionSize = map.segments.length;

  List<List<Segment>> segments = new List(dimensionSize);
  for (int i = 0; i < dimensionSize; i++) {
    segments[i] = new List(dimensionSize);
  }

  for(Segment segment in map.allSegments) {
    segments[segment.position.y][segment.position.x] = segment;
  }

  for (List<Segment> row in segments) {
    for (Segment segment in row) {
      String cell = segment.absoluteAltitude.toStringAsFixed(0);
      cell = cell.padLeft(2, ' ');
      stdout.write(cell + '|');
    }

    stdout.writeln();
  }
}

_Arguments _parseArguments(List<String> arguments)
{
  List<String> startValue = arguments[2].split(',');
  Point mapStart = new Point(double.parse(startValue[0]), double.parse(startValue[1]));

  return new _Arguments(arguments[0], arguments[1], mapStart, double.parse(arguments[3]), double.parse(arguments[4]), double.parse(arguments[5]));
}

class _Arguments
{
  final String inputFilePath;
  final String exportFilePath;
  final Point mapStart;
  final double mapSize;
  final double centerAltitude;
  final double minAltitude;

  _Arguments(this.inputFilePath, this.exportFilePath, this.mapStart, this.mapSize, this.centerAltitude, this.minAltitude);
}
