/// Defines all valid arrow directions and movement helpers.
library;

import 'dart:ui';

enum Direction {
  up,
  down,
  left,
  right,
  none;

  Direction get opposite {
    switch (this) {
      case Direction.up:
        return Direction.down;
      case Direction.down:
        return Direction.up;
      case Direction.left:
        return Direction.right;
      case Direction.right:
        return Direction.left;
      case Direction.none:
        return Direction.none;
    }
  }

  Offset toOffset() {
    switch (this) {
      case Direction.up:
        return const Offset(0, -1);
      case Direction.down:
        return const Offset(0, 1);
      case Direction.left:
        return const Offset(-1, 0);
      case Direction.right:
        return const Offset(1, 0);
      case Direction.none:
        return Offset.zero;
    }
  }

  static Direction fromJson(String value) {
    switch (value) {
      case 'up':
        return Direction.up;
      case 'down':
        return Direction.down;
      case 'left':
        return Direction.left;
      case 'right':
        return Direction.right;
      case 'none':
      default:
        return Direction.none;
    }
  }

  String toJson() => name;
}
