import 'package:spell_check_on_client/src/core/spell_check.dart';
import 'package:test/test.dart';

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

    final String didYouMean = spellCheck.didYouMeanWord('tes');

    assert(didYouMean == 'tese');
  });

  test('Test to find 5 close words', () {
    const SpellCheck spellCheck = SpellCheck(words: words);

    final List<String> options = spellCheck.didYouMeanAny('tes', maxWords: 5);

    assert(options.isNotEmpty);
    assert(options.length == 5);
  });

  test('Test the order of results', () {
    const SpellCheck spellCheck = SpellCheck(words: {
      'on': 0,
      'oi': 0,
      'ni': 0,
      'ji': 0,
      'joia': 0,
      'ovni': 0,
      'joio': 0,
      'comi': 0,
    });

    final List<String> options = spellCheck.didYouMeanAny('soni', maxWords: 10);

    assert(options.isNotEmpty);
    assert(options.length == 5);
    assert(options[0] == 'comi');
  });
}
