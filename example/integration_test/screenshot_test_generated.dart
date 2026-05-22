// ignore_for_file: avoid_relative_lib_imports
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import '../lib/main.dart' as app;

void main() {
  final IntegrationTestWidgetsFlutterBinding binding =
      IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  Future<void> waitForAppFrame(WidgetTester tester) async {
    final Finder startupMessage = find.text('Test starting...');
    final Finder appShell = find.byWidgetPredicate(
      (Widget widget) => widget is MaterialApp || widget is WidgetsApp,
      description: 'MaterialApp or WidgetsApp',
    );
    for (int attempt = 0; attempt < 40; attempt++) {
      await tester.pump(const Duration(milliseconds: 100));
      if (startupMessage.evaluate().isEmpty && appShell.evaluate().isNotEmpty) {
        await tester.pumpAndSettle();
        return;
      }
    }
    await tester.pumpAndSettle();
    if (startupMessage.evaluate().isNotEmpty) {
      throw TestFailure(
        'AutoTest app did not replace the Flutter test startup screen.',
      );
    }
  }

  Future<void> launchApp(WidgetTester tester) async {
    await Future<void>.sync(app.main);
    await waitForAppFrame(tester);
  }

  testWidgets('screenshot', (WidgetTester tester) async {
    await launchApp(tester);

    // First screenshot after the app render/setup.
    await binding.takeScreenshot('screenshot-00-init');
  });
}
