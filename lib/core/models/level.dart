/// Stores metadata and grid data for a playable puzzle level.
library;

import 'cell.dart';

class Level {
  Level({
    required this.id,
    required this.name,
    required this.shape,
    required this.gridWidth,
    required this.gridHeight,
    required List<List<Cell>> grid,
    required this.startX,
    required this.startY,
    required this.endX,
    required this.endY,
    required this.difficulty,
    required this.pack,
  }) : grid = List<List<Cell>>.unmodifiable(
          grid.map((List<Cell> row) => List<Cell>.unmodifiable(row)),
        );

  final String id;
  final String name;
  final String shape;
  final int gridWidth;
  final int gridHeight;
  final List<List<Cell>> grid;
  final int startX;
  final int startY;
  final int endX;
  final int endY;
  final int difficulty;
  final int pack;

  Cell? getCell(int x, int y) {
    if (x < 0 || y < 0 || y >= grid.length || x >= grid[y].length) {
      return null;
    }
    return grid[y][x];
  }

  factory Level.fromJson(Map<String, dynamic> json) {
    final List<dynamic> rawGrid = json['grid'] as List<dynamic>;
    final List<List<Cell>> parsedGrid = rawGrid
        .map(
          (dynamic row) => (row as List<dynamic>)
              .map((dynamic cellJson) => Cell.fromJson(cellJson as Map<String, dynamic>))
              .toList(),
        )
        .toList();

    return Level(
      id: json['id'] as String,
      name: json['name'] as String,
      shape: json['shape'] as String,
      gridWidth: json['gridWidth'] as int,
      gridHeight: json['gridHeight'] as int,
      grid: parsedGrid,
      startX: json['startX'] as int,
      startY: json['startY'] as int,
      endX: json['endX'] as int,
      endY: json['endY'] as int,
      difficulty: json['difficulty'] as int,
      pack: json['pack'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'shape': shape,
      'gridWidth': gridWidth,
      'gridHeight': gridHeight,
      'grid': grid
          .map((List<Cell> row) => row.map((Cell cell) => cell.toJson()).toList())
          .toList(),
      'startX': startX,
      'startY': startY,
      'endX': endX,
      'endY': endY,
      'difficulty': difficulty,
      'pack': pack,
    };
  }
}
