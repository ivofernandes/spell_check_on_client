import 'package:flutter_test/flutter_test.dart';
import 'package:spell_check_on_client/src/core/spell_check.dart';

void main() {
  test('Spell check first test', () {
    SpellCheck spellCheck = SpellCheck.fromWordsList(['cat', 'bat', 'hat']);

    String didYouMean = spellCheck.didYouMean('brat');

    assert(didYouMean == 'bat');
  });
}
