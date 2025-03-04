import 'package:spell_check_on_client/src/core/spell_check.dart';
import 'package:test/test.dart';

void main() {

  test('Simple test', () {
    SpellCheck spellCheck = SpellCheck.fromWordsList(
      ['cat', 'bat', 'hat'],
      letters: 'abcdefghijklmnopqrstuvwxyz'.split(''),
    );

    String didYouMean = spellCheck.didYouMeanWord('rat');

    expect(didYouMean, 'cat');
  });
}
