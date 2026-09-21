/// Paints the maze as thin orthogonal strokes with sharp 90-degree turns.
library;

import 'package:flutter/material.dart';

import '../../core/models/cell.dart';
import '../../core/models/direction.dart';

class MazePainter extends CustomPainter {
  MazePainter({
    required this.grid,
    required this.currentPath,
    required this.cellSize,
    this.cellColor = const Color(0xFF6E4C34),
    this.pathColor = const Color(0xFF4A90D9),
    this.backgroundColor = Colors.transparent,
  });

  final List<List<Cell>> grid;
  final List<Cell> currentPath;
  final double cellSize;
  final Color cellColor;
  final Color pathColor;
  final Color backgroundColor;

  static const double _kArrowHeadSize = 3.0;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    if (backgroundColor.a > 0) {
      final Paint backgroundPaint = Paint()..color = backgroundColor;
      canvas.drawRect(Offset.zero & size, backgroundPaint);
    }

    final Paint mazePaint = Paint()
      ..color = cellColor
      ..strokeCap = StrokeCap.square
      ..strokeWidth = _baseLineWidth
      ..style = PaintingStyle.stroke;

    final Paint pathPaint = Paint()
      ..color = pathColor
      ..strokeCap = StrokeCap.square
      ..strokeWidth = _baseLineWidth
      ..style = PaintingStyle.stroke;

    final Paint startPaint = Paint()
      ..color = const Color(0xFF5DB075)
      ..strokeCap = StrokeCap.square
      ..strokeWidth = _baseLineWidth
      ..style = PaintingStyle.stroke;

    final Paint endPaint = Paint()
      ..color = const Color(0xFFE05C5C)
      ..strokeCap = StrokeCap.square
      ..strokeWidth = _baseLineWidth
      ..style = PaintingStyle.stroke;

    for (final List<Cell> row in grid) {
      for (final Cell cell in row) {
        if (!cell.isActive) {
          continue;
        }
        _paintCellSegments(canvas, cell, mazePaint);
      }
    }

    if (currentPath.length > 1) {
      for (int i = 0; i < currentPath.length; i++) {
        final Cell cell = currentPath[i];
        if (!cell.isActive) {
          continue;
        }
        final Paint activePaint;
        if (cell.isStart) {
          activePaint = startPaint;
        } else if (cell.isEnd) {
          activePaint = endPaint;
        } else {
          activePaint = pathPaint;
        }
        _paintCellSegments(canvas, cell, activePaint);
      }
    }

    _paintPathConnectors(canvas, pathPaint, startPaint, endPaint);
    canvas.restore();
  }

  double get _baseLineWidth => (cellSize * 0.05).clamp(1.0, 1.9);

  void _paintCellSegments(Canvas canvas, Cell cell, Paint paint) {
    canvas.save();
    final Offset center = _cellCenter(cell);
    final Set<Direction> segments = <Direction>{
      ..._incomingDirections(cell),
      if (cell.direction != Direction.none) cell.direction,
    };

    for (final Direction segmentDirection in segments) {
      final Offset endpoint = _directionEndpoint(segmentDirection, center);
      canvas.drawLine(center, endpoint, paint);
    }

    if (cell.direction != Direction.none) {
      final Offset outgoingTip = _directionEndpoint(cell.direction, center);
      _paintArrowHead(canvas, outgoingTip, cell.direction, paint.color);
    }
    canvas.restore();
  }

  void _paintPathConnectors(
    Canvas canvas,
    Paint pathPaint,
    Paint startPaint,
    Paint endPaint,
  ) {
    for (int i = 0; i < currentPath.length - 1; i++) {
      final Cell from = currentPath[i];
      final Cell to = currentPath[i + 1];
      final Offset fromCenter = _cellCenter(from);
      final Offset toCenter = _cellCenter(to);

      final Paint connectorPaint;
      if (from.isStart) {
        connectorPaint = startPaint;
      } else if (to.isEnd) {
        connectorPaint = endPaint;
      } else {
        connectorPaint = pathPaint;
      }
      canvas.drawLine(fromCenter, toCenter, connectorPaint);
    }
  }

  Offset _cellCenter(Cell cell) {
    return Offset(
      (cell.x * cellSize) + (cellSize / 2),
      (cell.y * cellSize) + (cellSize / 2),
    );
  }

  Offset _directionEndpoint(Direction direction, Offset center) {
    final double segmentLength = cellSize * 0.5;
    final Offset vector = direction.toOffset();
    return center + (vector * segmentLength);
  }

  Iterable<Direction> _incomingDirections(Cell cell) sync* {
    if (_pointsTo(cell.x, cell.y - 1, Direction.down)) {
      yield Direction.up;
    }
    if (_pointsTo(cell.x, cell.y + 1, Direction.up)) {
      yield Direction.down;
    }
    if (_pointsTo(cell.x - 1, cell.y, Direction.right)) {
      yield Direction.left;
    }
    if (_pointsTo(cell.x + 1, cell.y, Direction.left)) {
      yield Direction.right;
    }
  }

  bool _pointsTo(int x, int y, Direction direction) {
    if (y < 0 || y >= grid.length || x < 0 || x >= grid[y].length) {
      return false;
    }
    final Cell cell = grid[y][x];
    return cell.isActive && cell.direction == direction;
  }

  void _paintArrowHead(
    Canvas canvas,
    Offset tip,
    Direction direction,
    Color color,
  ) {
    final Offset vector = direction.toOffset();
    final Offset perpendicular = Offset(-vector.dy, vector.dx);
    final Offset baseCenter = tip - (vector * _kArrowHeadSize);
    final Offset p1 = tip;
    final Offset p2 = baseCenter + (perpendicular * (_kArrowHeadSize * 0.6));
    final Offset p3 = baseCenter - (perpendicular * (_kArrowHeadSize * 0.6));

    final Paint chevronPaint = Paint()
      ..color = color
      ..strokeWidth = (_baseLineWidth * 0.9).clamp(0.9, 1.6)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(p1, p2, chevronPaint);
    canvas.drawLine(p1, p3, chevronPaint);
  }

  @override
  bool shouldRepaint(covariant MazePainter oldDelegate) {
    return !_isSamePath(oldDelegate.currentPath, currentPath);
  }

  bool _isSamePath(List<Cell> a, List<Cell> b) {
    if (identical(a, b)) {
      return true;
    }
    if (a.length != b.length) {
      return false;
    }
    for (int i = 0; i < a.length; i++) {
      final Cell left = a[i];
      final Cell right = b[i];
      if (left.x != right.x || left.y != right.y) {
        return false;
      }
    }
    return true;
  }
}
