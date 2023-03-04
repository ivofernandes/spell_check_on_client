import 'package:flutter_test/flutter_test.dart';
import 'package:spell_check_on_client/src/core/spell_check.dart';

void main() {
  const Map<String, int?> words = {
    'teste': null,
    'testei': null,
    'testeis': null,
    'testem': null,
    'testemo': null,
    'testemos': null,
    'testemunha': null,
    'tese': null,
    'teses': null,
    'tesla': null,
    'teso': null,
    'tesoura': null,
    'tesouraria': null,
    'tesoureiro': null,
    'tesourinho': null,
    'tesourinhas': null,
  };

  test('Basic test to find closest word', () {
    const SpellCheck spellCheck = SpellCheck(words: words);

    String didYouMean = spellCheck.didYouMeanWord('tes');

    assert(didYouMean == 'aes');
  });

  test('Test to find 5 close words', () {
    const SpellCheck spellCheck = SpellCheck(words: words);

    List<String> options = spellCheck.didYouMeanAny('tes', maxWords: 5);

    assert(options.isNotEmpty);
    assert(options.length == 5);
  });
}
