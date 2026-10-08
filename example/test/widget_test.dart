import 'package:example/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  for (final language in ['zh', 'ja', 'ar', 'am']) {
    testWidgets('$language loads and uses a localized ranked dictionary', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(1200, 1800));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.runAsync(() async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: SpellCheckExample(language: language)),
          ),
        );
        // Asset decoding uses an isolate and needs real asynchronous execution.
        for (var attempt = 0; attempt < 100; attempt++) {
          await Future<void>.delayed(const Duration(milliseconds: 20));
          await tester.pump();
          if (find.text('Loading dictionary…').evaluate().isEmpty) {
            break;
          }
        }
      });
      await tester.pumpAndSettle();
      await tester.tap(find.text('SpellCheck(words: ...)'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Run spell-check methods'));
      await tester.pumpAndSettle();
      expect(find.text('No suggestions'), findsNothing);
      final expected = const {
        'zh': '世界',
        'ja': 'こんにちは',
        'ar': 'مرحبا',
        'am': 'ሀሳብ',
      }[language]!;
      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is SelectableText &&
              widget.data!.split(', ').first == expected,
        ),
        findsOneWidget,
      );
      expect(find.textContaining('source: rankedMap'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }
}
