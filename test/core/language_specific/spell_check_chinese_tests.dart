import 'package:spell_check_on_client/src/core/spell_check.dart';
import 'package:test/test.dart';

void main() {
  test('Simple Chinese test', () {
    final SpellCheck spellCheck = SpellCheck.fromWordsList(
      ['你好', '和平', '哈利路亚'], // ['Hello', 'Peace', 'Hallelujah']
      letters: '你和好平哈利路亚'.split(''), // Chinese characters
    );

    // Test for exact match
    String didYouMean = spellCheck.didYouMeanWord('和平'); // 'Peace'
    expect(didYouMean, '和平'); // 'Peace'

    // Test for a close match
    didYouMean =
        spellCheck.didYouMeanWord('和平平'); // 'Peace' with an extra character
    expect(didYouMean, '和平'); // 'Peace'

    // Test for a completely different word
    didYouMean = spellCheck.didYouMeanWord('中文'); // 'Chinese'
    expect(didYouMean, isNot('和平')); // 'Peace'

    // Test for a word with similar spelling
    didYouMean = spellCheck.didYouMeanWord('哈利路亚'); // 'Hallelujah'
    expect(didYouMean, '哈利路亚'); // 'Hallelujah'
  });
}
