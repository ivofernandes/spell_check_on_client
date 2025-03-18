import 'package:spell_check_on_client/src/core/spell_check.dart';
import 'package:test/test.dart';

void main() {
  test('Simple Japanese test', () {
    final SpellCheck spellCheck = SpellCheck.fromWordsList(
      ['こんにちは', '平和', 'ハレルヤ'], // ['Hello', 'Peace', 'Hallelujah']
      letters: 'こにちは平和ハレルヤ'.split(''), // Japanese characters
    );

    // Test for exact match
    String didYouMean = spellCheck.didYouMeanWord('平和'); // 'Peace'
    expect(didYouMean, '平和'); // 'Peace'

    // Test for a close match
    didYouMean =
        spellCheck.didYouMeanWord('平和平'); // 'Peace' with an extra character
    expect(didYouMean, '平和'); // 'Peace'

    // Test for a completely different word
    didYouMean = spellCheck.didYouMeanWord('日本語'); // 'Japanese'
    expect(didYouMean, isNot('平和')); // 'Peace'

    // Test for a word with similar spelling
    didYouMean = spellCheck.didYouMeanWord('ハレルヤ'); // 'Hallelujah'
    expect(didYouMean, 'ハレルヤ'); // 'Hallelujah'
  });
}
