// ignore_for_file: avoid_print

import 'dart:io';

import 'package:spell_check_on_client/src/core/language_letters.dart';
import 'package:spell_check_on_client/src/core/spell_check.dart';
import 'package:test/test.dart';

void main() {
  setUpAll(() async {
    // Warm-up rep
    const String filePath = 'example/assets/en_words.txt';
    final String content = await File(filePath).readAsString();
    final SpellCheck spellCheck = SpellCheck.fromWordsContent(content);
    spellCheck.didYouMean('Mammalls can have babiis');
  });

  // English test
  test('English test', () async {
    final DateTime start = DateTime.now();
    const String filePath = 'example/assets/en_words.txt';
    final String content = await File(filePath).readAsString();
    final SpellCheck spellCheck = SpellCheck.fromWordsContent(content);

    final DateTime loaded = DateTime.now();
    final String didYouMean = spellCheck.didYouMean('Mammalls can have babiis');
    final DateTime checked = DateTime.now();

    final int timeSpentLoading =
        loaded.millisecondsSinceEpoch - start.millisecondsSinceEpoch;
    final int timeSpentChecking =
        checked.millisecondsSinceEpoch - loaded.millisecondsSinceEpoch;

    print('didYouMean: $didYouMean');
    expect(didYouMean, equals('mammals can have babies'));
    print('timeSpentLoading: $timeSpentLoading');
    expect(timeSpentLoading < 200, isTrue);
    print('timeSpentChecking: $timeSpentChecking');
    expect(timeSpentChecking < 3000, isTrue);
  });

  // Portuguese test
  test('Portuguese test', () async {
    final DateTime start = DateTime.now();
    const String filePath = 'example/assets/pt_words.txt';
    final String content = await File(filePath).readAsString();
    final SpellCheck spellCheck = SpellCheck.fromWordsContent(
      content,
      letters: LanguageLetters.portugueseLetters(),
    );

    final DateTime loaded = DateTime.now();
    final String didYouMean =
        spellCheck.didYouMean('Mamiferos podemm ter bebês');
    final DateTime checked = DateTime.now();

    final int timeSpentLoading =
        loaded.millisecondsSinceEpoch - start.millisecondsSinceEpoch;
    final int timeSpentChecking =
        checked.millisecondsSinceEpoch - loaded.millisecondsSinceEpoch;

    print('didYouMean: $didYouMean');
    expect(didYouMean, equals('mamíferos podem ter bebês'));
    print('timeSpentLoading: $timeSpentLoading');
    expect(timeSpentLoading < 200, isTrue);
    print('timeSpentChecking: $timeSpentChecking');
    expect(timeSpentChecking < 200, isTrue);
  });

  // Swedish test
  test('Swedish test', () async {
    final DateTime start = DateTime.now();
    const String filePath = 'example/assets/sv_words.txt';
    final String content = await File(filePath).readAsString();
    final SpellCheck spellCheck = SpellCheck.fromWordsContent(
      content,
      letters: LanguageLetters.swedishLetters(),
    );

    final DateTime loaded = DateTime.now();
    final String didYouMean = spellCheck.didYouMean('hundär är söta');
    final DateTime checked = DateTime.now();

    final int timeSpentLoading =
        loaded.millisecondsSinceEpoch - start.millisecondsSinceEpoch;
    final int timeSpentChecking =
        checked.millisecondsSinceEpoch - loaded.millisecondsSinceEpoch;

    print('didYouMean: $didYouMean');
    expect(didYouMean, equals('hundar är söta'));
    print('timeSpentLoading: $timeSpentLoading');
    expect(timeSpentLoading < 200, isTrue);
    print('timeSpentChecking: $timeSpentChecking');
    expect(timeSpentChecking < 200, isTrue);
  });

  // Spanish test
  test('Spanish test', () async {
    final DateTime start = DateTime.now();
    const String filePath = 'example/assets/es_words.txt';
    final String content = await File(filePath).readAsString();
    final SpellCheck spellCheck = SpellCheck.fromWordsContent(
      content,
      letters: LanguageLetters.spanishLetters(),
    );

    final DateTime loaded = DateTime.now();
    final String didYouMean =
        spellCheck.didYouMean('Los niñoss juegan en el patio');
    final DateTime checked = DateTime.now();

    final int timeSpentLoading =
        loaded.millisecondsSinceEpoch - start.millisecondsSinceEpoch;
    final int timeSpentChecking =
        checked.millisecondsSinceEpoch - loaded.millisecondsSinceEpoch;

    print('didYouMean: $didYouMean');
    expect(didYouMean, equals('Los niños juegan en el patio'));
    print('timeSpentLoading: $timeSpentLoading');
    expect(timeSpentLoading < 200, isTrue);
    print('timeSpentChecking: $timeSpentChecking');
    expect(timeSpentChecking < 200, isTrue);
  });
}
