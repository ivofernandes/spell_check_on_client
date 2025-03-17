import 'package:spell_check_on_client/spell_check_on_client.dart';
import 'package:spell_check_on_client/src/core/find_words/word_generation.dart';
import 'package:spell_check_on_client/src/core/find_words/word_generation_replace.dart';
import 'package:test/test.dart';

void main() {
  group('WordGeneration Tests', () {
    test('Delete Letter', () {
      expect(WordGeneration.delete('cat'), equals(['at', 'ct', 'ca']));
    });

    test('Swap Letters', () {
      expect(WordGeneration.swap('cat'), equals(['act', 'cta']));
    });

    test('Insert Letters', () {
      expect(
        WordGeneration.insert('cat', ['a', 'b']),
        equals([
          'acat', 'bcat', 'caat', 'cbat', 'caat', 'cabt', 'cata', 'catb'
        ]),
      );
    });

    test('Replace Letters', () {
      expect(
        WordGenerationReplace.replace('cat', ['a', 'b']),
        equals(['bat', 'cab']),
      );
    });


    test('Replace Punctuation', () {

      final replaced = WordGenerationReplace.replace(
        'patío',
        ['i', 'n'],
        replaceVowels: false,);

      expect(
        replaced,
        equals(['patio', 'natío', 'panío', ]),
      );
    });
  });
}