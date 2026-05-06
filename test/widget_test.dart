import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:testing_bloc/main.dart';

void main() {
  testWidgets('renders arrow puzzle game shell', (WidgetTester tester) async {
    await tester.pumpWidget(const ArrowsGoApp());
    await tester.pumpAndSettle();

    expect(find.textContaining('Level'), findsOneWidget);
    expect(find.byIcon(Icons.lightbulb_outline), findsOneWidget);
  });
}
