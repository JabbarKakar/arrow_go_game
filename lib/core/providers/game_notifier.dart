/// Exposes game state operations and delegates path logic to the controller.
library;

import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../engine/path_tracing_controller.dart';
import '../models/cell.dart';
import '../models/game_state.dart';
import '../models/level.dart';

class GameNotifier extends ChangeNotifier {
  GameNotifier({required Level level})
      : _controller = PathTracingController(level: level),
        _state = GameState(level: level);

  final PathTracingController _controller;
  GameState _state;

  GameState get state => _state;

  void startPath(Cell startCell) {
    if (!startCell.isActive) {
      return;
    }
    _controller.startPath(startCell);
    _state = _state.copyWith(
      currentPath: _controller.currentPath,
      isCompleted: false,
    );
    notifyListeners();
  }

  bool extendPath(int x, int y) {
    final bool added = _controller.tryExtendPath(x, y);
    if (added) {
      final bool complete = _controller.isComplete();
      _state = _state.copyWith(
        currentPath: _controller.currentPath,
        isCompleted: complete,
      );
      notifyListeners();
    }
    return added;
  }

  void undoStep() {
    _controller.undoLastStep();
    _state = _state.copyWith(
      currentPath: _controller.currentPath,
      isCompleted: false,
    );
    notifyListeners();
  }

  void resetPath() {
    _controller.resetPath();
    _state = _state.copyWith(
      currentPath: _controller.currentPath,
      isCompleted: false,
    );
    notifyListeners();
  }

  void useHint() {
    if (_state.hintsRemaining <= 0) {
      return;
    }
    _state = _state.copyWith(hintsRemaining: _state.hintsRemaining - 1);
    notifyListeners();
  }

  void loseLife() {
    if (_state.livesRemaining <= 0) {
      return;
    }
    final int nextLives = _state.livesRemaining - 1;
    _state = _state.copyWith(
      livesRemaining: nextLives,
      isFailed: nextLives <= 0,
    );
    notifyListeners();
  }
}

ChangeNotifierProvider<GameNotifier> createGameNotifierProvider({
  Key? key,
  required Level level,
  required Widget child,
}) {
  return ChangeNotifierProvider<GameNotifier>(
    key: key,
    create: (_) => GameNotifier(level: level),
    child: child,
  );
}
