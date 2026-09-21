/// Lays out and renders the maze centered with dynamic cell sizing.
library;

import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/models/cell.dart';
import '../../core/models/level.dart';
import 'maze_painter.dart';

class MazeWidget extends StatelessWidget {
  const MazeWidget({
    super.key,
    required this.level,
    required this.currentPath,
  });

  final Level level;
  final List<Cell> currentPath;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final Size availableSize = constraints.biggest;
        final double maxWidth = availableSize.width.isFinite
            ? availableSize.width
            : (level.gridWidth * 48.0);
        final double maxHeight = availableSize.height.isFinite
            ? availableSize.height
            : (level.gridHeight * 48.0);

        final double cellSize = math.min(
          maxWidth / level.gridWidth,
          maxHeight / level.gridHeight,
        );

        final Size mazeSize = Size(
          level.gridWidth * cellSize,
          level.gridHeight * cellSize,
        );

        return Center(
          child: SizedBox(
            width: mazeSize.width,
            height: mazeSize.height,
            child: CustomPaint(
              painter: MazePainter(
                grid: level.grid,
                currentPath: currentPath,
                cellSize: cellSize,
              ),
            ),
          ),
        );
      },
    );
  }
}
