import 'dart:io';

import 'package:spell_check_on_client/src/core/language_letters.dart';
import 'package:spell_check_on_client/src/core/spell_check.dart';
import 'package:test/test.dart';

void main() {
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
    expect(timeSpentChecking < 2000, isTrue);
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
    spellCheck.didYouMean('Mamiferos podemm ter bébés');
    final DateTime checked = DateTime.now();

    final int timeSpentLoading =
        loaded.millisecondsSinceEpoch - start.millisecondsSinceEpoch;
    final int timeSpentChecking =
        checked.millisecondsSinceEpoch - loaded.millisecondsSinceEpoch;

    print('didYouMean: $didYouMean');
    expect(didYouMean, equals('mamíferos podem ter bébés'));
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
    final String didYouMean = spellCheck.didYouMean('hundar är söota');
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

}