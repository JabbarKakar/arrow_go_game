/// Represents runtime state for the active level play session.
library;

import 'cell.dart';
import 'level.dart';

class GameState {
  GameState({
    required this.level,
    List<Cell> currentPath = const <Cell>[],
    this.livesRemaining = 3,
    this.hintsRemaining = 3,
    this.isCompleted = false,
    this.isFailed = false,
  }) : currentPath = List<Cell>.unmodifiable(currentPath);

  final Level level;
  final List<Cell> currentPath;
  final int livesRemaining;
  final int hintsRemaining;
  final bool isCompleted;
  final bool isFailed;

  GameState copyWith({
    Level? level,
    List<Cell>? currentPath,
    int? livesRemaining,
    int? hintsRemaining,
    bool? isCompleted,
    bool? isFailed,
  }) {
    return GameState(
      level: level ?? this.level,
      currentPath: currentPath ?? this.currentPath,
      livesRemaining: livesRemaining ?? this.livesRemaining,
      hintsRemaining: hintsRemaining ?? this.hintsRemaining,
      isCompleted: isCompleted ?? this.isCompleted,
      isFailed: isFailed ?? this.isFailed,
    );
  }
}
