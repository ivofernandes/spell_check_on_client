import 'package:collection/collection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spell_check_on_client/src/core/spell_check.dart';

void main() {
  Function eq = const ListEquality().equals;

  test('Basic test to find unknown words', () {
    SpellCheck spellCheck = SpellCheck.fromWordsList(['cat', 'bat', 'hat']);

    List<String> unknown = spellCheck.unKnownWords('a cat and bat');

    assert(eq(unknown, ['a', 'and']));
  });

  test('Spell check mistyped an extra letter test', () {
    SpellCheck spellCheck = SpellCheck.fromWordsList(['cat', 'bat', 'hat']);

    String didYouMean = spellCheck.didYouMean('crat');

    assert(didYouMean == 'cat');
  });

  test('Spell check missing letter test', () {
    SpellCheck spellCheck = SpellCheck.fromWordsList(['cat', 'bat', 'hat']);

    String didYouMean = spellCheck.didYouMean('ca');

    assert(didYouMean == 'cat');
  });

  test('Spell check replace letter test', () {
    SpellCheck spellCheck =
        SpellCheck.fromWordsList(['cat', 'bat', 'hat'], iterations: 1);

    String didYouMean = spellCheck.didYouMean('bar');

    assert(didYouMean == 'bat');
  });
}
