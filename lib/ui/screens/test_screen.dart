/// Simple preview screen to validate basic maze grid rendering.
library;

import 'package:flutter/material.dart';

import '../../core/models/cell.dart';
import '../../core/models/direction.dart';
import '../../core/models/level.dart';
import '../../core/providers/game_notifier.dart';
import '../widgets/maze_gesture_handler.dart';

class TestScreen extends StatelessWidget {
  const TestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Level level = _buildPreviewLevel();

    return createGameNotifierProvider(
      level: level,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Maze Preview'),
        ),
        body: const Padding(
          padding: EdgeInsets.all(16),
          child: MazeGestureHandler(),
        ),
      ),
    );
  }

  Level _buildPreviewLevel() {
    final List<List<Cell>> grid = <List<Cell>>[
      _row(0, '000000000000', 'nnnnnnnnnnnn'),
      _row(1, '000111110000', 'nnnrrddlunnn'),
      _row(2, '001111111000', 'nnrdruldlunn'),
      _row(3, '001111111000', 'nndrrulddlunn'),
      _row(4, '011111111100', 'nrruldrulddln'),
      _row(5, '011111111100', 'nrdlurdrulddn'),
      _row(6, '001111111000', 'nndrruldrulnn'),
      _row(7, '001111111000', 'nnrdlurdrulnn'),
      _row(8, '000111110000', 'nnnrruulldnnn'),
      _row(9, '000011000000', 'nnnnrulnnnnn'),
      _row(10, '000011000000', 'nnnndrunnnnn'),
      _row(11, '000000000000', 'nnnnnnnnnnnn'),
    ];

    return Level(
      id: 'preview_level',
      name: 'Preview Level',
      shape: 'anchor',
      gridWidth: 12,
      gridHeight: 12,
      grid: grid,
      startX: 3,
      startY: 2,
      endX: 8,
      endY: 8,
      difficulty: 1,
      pack: 1,
    );
  }

  List<Cell> _row(int y, String activeMask, String dirMask) {
    return List<Cell>.generate(activeMask.length, (int x) {
      final bool isActive = activeMask[x] == '1';
      return Cell(
        x: x,
        y: y,
        direction: _parseDirection(dirMask[x]),
        isActive: isActive,
        isStart: x == 3 && y == 2,
        isEnd: x == 8 && y == 8,
      );
    });
  }

  Direction _parseDirection(String value) {
    switch (value) {
      case 'u':
        return Direction.up;
      case 'd':
        return Direction.down;
      case 'l':
        return Direction.left;
      case 'r':
        return Direction.right;
      default:
        return Direction.none;
    }
  }
}
