import 'dart:io';

import 'package:spell_check_on_client/src/core/language_letters.dart';
import 'package:spell_check_on_client/src/core/spell_check.dart';
import 'package:test/test.dart';

void main() {
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
    assert(didYouMean == 'mammals can have babies');

    print('timeSpentLoading: $timeSpentLoading');
    assert(timeSpentLoading < 200);

    print('timeSpentChecking: $timeSpentChecking');
    assert(timeSpentChecking < 200);
  });

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
    assert(didYouMean == 'mamíferos podem ter bébés');

    print('timeSpentLoading: $timeSpentLoading');
    assert(timeSpentLoading < 200);

    print('timeSpentChecking: $timeSpentChecking');
    assert(timeSpentChecking < 200);
  });
}
