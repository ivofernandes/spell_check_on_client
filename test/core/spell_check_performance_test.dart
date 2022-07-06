import 'package:collection/collection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spell_check_on_client/src/core/spell_check.dart';

void main() {
  Function eq = const ListEquality().equals;

  test('Tests on entire english dictionary test to find unknown words', () {
    //TODO load the english dictionary
    SpellCheck spellCheck = SpellCheck.fromWordsList(['cat', 'bat', 'hat']);

    List<String> unknown = spellCheck.unKnownWords('a cat and bat');

    assert(eq(unknown, ['a', 'and']));
  });

  test('Spell check mistyped an extra letter test', () {
    //TODO load the english dictionary
    SpellCheck spellCheck = SpellCheck.fromWordsList(['cat', 'bat', 'hat']);

    String didYouMean = spellCheck.didYouMean('brat');

    assert(didYouMean == 'bat');
  });
}
