import 'package:spell_check_on_client/src/core/spell_check.dart';
import 'package:test/test.dart';

void main() {

  test('Simple Arabic test', () {
    SpellCheck spellCheck = SpellCheck.fromWordsList(
      ['مرحبا', 'سلام', 'هللويا'], // ['Hello', 'Peace', 'Hallelujah']
      letters: 'مرحبا سلام هللويا'.split(''), // Arabic characters
    );

    // Test for exact match
    String didYouMean = spellCheck.didYouMeanWord('سلام'); // 'Peace'
    expect(didYouMean, 'سلام'); // 'Peace'

    // Test for a close match
    didYouMean = spellCheck.didYouMeanWord('سلامم'); // 'Peace' with an extra character
    expect(didYouMean, 'سلام'); // 'Peace'

    // Test for a completely different word
    didYouMean = spellCheck.didYouMeanWord('عربي'); // 'Arabic'
    expect(didYouMean, isNot('سلام')); // 'Peace'

    // Test for a word with similar spelling
    didYouMean = spellCheck.didYouMeanWord('هللويا'); // 'Hallelujah'
    expect(didYouMean, 'هللويا'); // 'Hallelujah'
  });
}