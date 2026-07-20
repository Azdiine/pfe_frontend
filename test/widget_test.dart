// Smoke test : l'application démarre et affiche l'écran de splash
// sans lever d'exception.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:projet_pfe_front/main.dart';

void main() {
  testWidgets('App boots and renders the splash screen', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: MyApp()));

    expect(find.byType(MaterialApp), findsOneWidget);

    // Avance le temps au-delà du délai du splash (2s) pour purger les
    // timers en attente et laisser la navigation initiale se faire.
    await tester.pump(const Duration(seconds: 3));
    await tester.pump(const Duration(seconds: 1));
  });
}
