/// Captures drag gestures and updates traced path with validation feedback.
library;

import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/models/cell.dart';
import '../../core/models/game_state.dart';
import '../../core/models/level.dart';
import '../../core/providers/game_notifier.dart';
import 'maze_widget.dart';

class MazeGestureHandler extends StatefulWidget {
  const MazeGestureHandler({super.key});

  @override
  State<MazeGestureHandler> createState() => _MazeGestureHandlerState();
}

class _MazeGestureHandlerState extends State<MazeGestureHandler> {
  Cell? _invalidFlashCell;
  Timer? _invalidFlashTimer;
  String? _lastDragCellKey;

  @override
  void dispose() {
    _invalidFlashTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final GameState gameState = context.select<GameNotifier, GameState>(
      (GameNotifier notifier) => notifier.state,
    );
    final Level level = gameState.level;

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final _MazeLayout layout = _computeLayout(level, constraints.biggest);
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onPanStart: (DragStartDetails details) {
            _handlePanStart(
              context: context,
              localPosition: details.localPosition,
              layout: layout,
              level: level,
            );
          },
          onPanUpdate: (DragUpdateDetails details) {
            _handlePanUpdate(
              context: context,
              localPosition: details.localPosition,
              layout: layout,
              level: level,
            );
          },
          onPanEnd: (_) => _handlePanEnd(context),
          child: Stack(
            children: <Widget>[
              Positioned.fill(
                child: MazeWidget(
                  level: level,
                  currentPath: gameState.currentPath,
                ),
              ),
              if (_invalidFlashCell != null)
                Positioned(
                  left: layout.offsetX + (_invalidFlashCell!.x * layout.cellSize),
                  top: layout.offsetY + (_invalidFlashCell!.y * layout.cellSize),
                  child: IgnorePointer(
                    child: Container(
                      width: layout.cellSize,
                      height: layout.cellSize,
                      decoration: BoxDecoration(
                        color: const Color(0x66E05C5C),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  void _handlePanStart({
    required BuildContext context,
    required Offset localPosition,
    required _MazeLayout layout,
    required Level level,
  }) {
    _lastDragCellKey = null;
    final Cell? touchedCell = _cellFromPosition(
      localPosition: localPosition,
      layout: layout,
      level: level,
    );
    if (touchedCell == null || !touchedCell.isActive) {
      return;
    }
    context.read<GameNotifier>().startPath(touchedCell);
    _lastDragCellKey = '${touchedCell.x}:${touchedCell.y}';
  }

  void _handlePanUpdate({
    required BuildContext context,
    required Offset localPosition,
    required _MazeLayout layout,
    required Level level,
  }) {
    final Cell? touchedCell = _cellFromPosition(
      localPosition: localPosition,
      layout: layout,
      level: level,
    );
    if (touchedCell == null) {
      return;
    }

    final String key = '${touchedCell.x}:${touchedCell.y}';
    if (_lastDragCellKey == key) {
      return;
    }
    _lastDragCellKey = key;

    final GameNotifier notifier = context.read<GameNotifier>();
    final bool isValid = notifier.extendPath(touchedCell.x, touchedCell.y);
    if (!isValid) {
      _flashInvalidCell(notifier.state.currentPath.lastOrNull);
    }
  }

  void _handlePanEnd(BuildContext context) {
    _lastDragCellKey = null;
    final GameNotifier notifier = context.read<GameNotifier>();
    if (notifier.state.isCompleted) {
      return;
    }
    if (notifier.state.currentPath.isNotEmpty) {
      _flashInvalidCell(notifier.state.currentPath.lastOrNull);
      notifier.loseLife();
    }
  }

  void _flashInvalidCell(Cell? cell) {
    if (cell == null) {
      return;
    }
    _invalidFlashTimer?.cancel();
    setState(() => _invalidFlashCell = cell);
    _invalidFlashTimer = Timer(const Duration(milliseconds: 180), () {
      if (mounted) {
        setState(() => _invalidFlashCell = null);
      }
    });
  }

  Cell? _cellFromPosition({
    required Offset localPosition,
    required _MazeLayout layout,
    required Level level,
  }) {
    final double localX = localPosition.dx - layout.offsetX;
    final double localY = localPosition.dy - layout.offsetY;
    if (localX < 0 || localY < 0) {
      return null;
    }

    final int x = (localX / layout.cellSize).floor();
    final int y = (localY / layout.cellSize).floor();
    if (x >= level.gridWidth || y >= level.gridHeight) {
      return null;
    }
    return level.getCell(x, y);
  }

  _MazeLayout _computeLayout(Level level, Size availableSize) {
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
    final double mazeWidth = level.gridWidth * cellSize;
    final double mazeHeight = level.gridHeight * cellSize;
    return _MazeLayout(
      cellSize: cellSize,
      offsetX: (maxWidth - mazeWidth) / 2,
      offsetY: (maxHeight - mazeHeight) / 2,
    );
  }
}

class _MazeLayout {
  const _MazeLayout({
    required this.cellSize,
    required this.offsetX,
    required this.offsetY,
  });

  final double cellSize;
  final double offsetX;
  final double offsetY;
}

extension on List<Cell> {
  Cell? get lastOrNull => isEmpty ? null : last;
}
