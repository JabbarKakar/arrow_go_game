/// Represents a single grid cell used by an arrow maze level.
library;

import 'direction.dart';

class Cell {
  const Cell({
    required this.x,
    required this.y,
    required this.direction,
    required this.isActive,
    this.isPath = false,
    this.isStart = false,
    this.isEnd = false,
  });

  final int x;
  final int y;
  final Direction direction;
  final bool isActive;
  final bool isPath;
  final bool isStart;
  final bool isEnd;

  Cell copyWith({
    int? x,
    int? y,
    Direction? direction,
    bool? isActive,
    bool? isPath,
    bool? isStart,
    bool? isEnd,
  }) {
    return Cell(
      x: x ?? this.x,
      y: y ?? this.y,
      direction: direction ?? this.direction,
      isActive: isActive ?? this.isActive,
      isPath: isPath ?? this.isPath,
      isStart: isStart ?? this.isStart,
      isEnd: isEnd ?? this.isEnd,
    );
  }

  factory Cell.fromJson(Map<String, dynamic> json) {
    return Cell(
      x: json['x'] as int,
      y: json['y'] as int,
      direction: Direction.fromJson(json['direction'] as String),
      isActive: json['isActive'] as bool,
      isPath: (json['isPath'] as bool?) ?? false,
      isStart: (json['isStart'] as bool?) ?? false,
      isEnd: (json['isEnd'] as bool?) ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'x': x,
      'y': y,
      'direction': direction.toJson(),
      'isActive': isActive,
      'isPath': isPath,
      'isStart': isStart,
      'isEnd': isEnd,
    };
  }
}
