import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spell_check_on_client/src/core/spell_check.dart';

void main() {
  Function eq = const ListEquality().equals;

  test('Test got from manual test', () async {
    DateTime start = DateTime.now();
    String filePath = 'example/assets/en_words.txt';
    String content = await File(filePath).readAsString();
    SpellCheck spellCheck = SpellCheck.fromWordsContent(content);

    DateTime loaded = DateTime.now();

    String didYouMean = spellCheck.didYouMean('Mammalls Cann have babiis');

    DateTime checked = DateTime.now();

    int timeSpentLoading =
        loaded.millisecondsSinceEpoch - start.millisecondsSinceEpoch;

    int timeSpentChecking =
        checked.millisecondsSinceEpoch - loaded.millisecondsSinceEpoch;

    assert(didYouMean == 'mammals can have babies');

    assert(timeSpentLoading < 200);

    assert(timeSpentChecking < 200);
  });
}
