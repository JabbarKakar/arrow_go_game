/// Handles path tracing rules for extending and validating maze paths.
library;

import '../models/cell.dart';
import '../models/direction.dart';
import '../models/level.dart';

class PathTracingController {
  PathTracingController({required this.level});

  final Level level;
  final List<Cell> _currentPath = <Cell>[];

  List<Cell> get currentPath => List<Cell>.unmodifiable(_currentPath);

  void startPath(Cell startCell) {
    _currentPath
      ..clear()
      ..add(startCell);
  }

  bool tryExtendPath(int x, int y) {
    if (_currentPath.isEmpty) {
      return false;
    }

    final Cell lastCell = _currentPath.last;
    final Cell? target = level.getCell(x, y);
    if (target == null || !target.isActive) {
      return false;
    }

    if (_containsCell(x, y)) {
      return false;
    }

    if (!_isAdjacent(lastCell, target)) {
      return false;
    }

    if (!_followsDirection(lastCell, target)) {
      return false;
    }

    _currentPath.add(target);
    return true;
  }

  void undoLastStep() {
    if (_currentPath.isNotEmpty) {
      _currentPath.removeLast();
    }
  }

  void resetPath() {
    _currentPath.clear();
  }

  bool isComplete() {
    if (_currentPath.isEmpty) {
      return false;
    }
    final Cell last = _currentPath.last;
    return last.x == level.endX && last.y == level.endY;
  }

  bool _containsCell(int x, int y) {
    return _currentPath.any((Cell cell) => cell.x == x && cell.y == y);
  }

  bool _isAdjacent(Cell from, Cell to) {
    final int dx = (from.x - to.x).abs();
    final int dy = (from.y - to.y).abs();
    return (dx + dy) == 1;
  }

  bool _followsDirection(Cell from, Cell to) {
    final int dx = to.x - from.x;
    final int dy = to.y - from.y;

    switch (from.direction) {
      case Direction.up:
        return dx == 0 && dy == -1;
      case Direction.down:
        return dx == 0 && dy == 1;
      case Direction.left:
        return dx == -1 && dy == 0;
      case Direction.right:
        return dx == 1 && dy == 0;
      case Direction.none:
        return false;
    }
  }
}
