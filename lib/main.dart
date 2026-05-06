import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/game_provider.dart';
import 'screens/game_screen.dart';
import 'services/level_generator_service.dart';

void main() {
  runApp(const ArrowsGoApp());
}

class ArrowsGoApp extends StatelessWidget {
  const ArrowsGoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<GameProvider>(
          create: (_) => GameProvider(
            levelGenerator: LevelGeneratorService(),
          )..initialize(),
        ),
      ],
      child: MaterialApp(
        title: 'Arrow Puzzle',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF8B5A2B),
            surface: const Color(0xFFF1E8D8),
          ),
          scaffoldBackgroundColor: const Color(0xFFF1E8D8),
          useMaterial3: true,
        ),
        home: const GameScreen(),
      ),
    );
  }
}
