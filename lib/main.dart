import 'package:flutter/material.dart';
import 'ui/screens/test_screen.dart';

void main() {
  runApp(const ArrowsGoApp());
}

class ArrowsGoApp extends StatelessWidget {
  const ArrowsGoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
      home: const TestScreen(),
    );
  }
}
