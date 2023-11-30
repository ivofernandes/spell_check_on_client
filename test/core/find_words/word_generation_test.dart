import 'package:spell_check_on_client/src/core/find_words/word_generation.dart';
import 'package:test/test.dart';

void main() {
  // Utilize the built-in 'expect' function for assertions in tests
  group('WordGeneration Tests', () {
    test('Delete Letter', () {
      final List<String> deletes = WordGeneration.delete('cat');
      expect(deletes, equals(['at', 'ct', 'ca']));
    });

    test('Swap Letters', () {
      final List<String> swaps = WordGeneration.swap('cat');
      expect(swaps, equals(['act', 'cta']));
    });

    test('Insert Letters', () {
      final List<String> inserted = WordGeneration.insert('cat', ['a', 'b']);
      expect(
          inserted,
          equals([
            'acat',
            'bcat',
            'caat',
            'cbat',
            'caat',
            'cabt',
            'cata',
            'catb'
          ]));
    });

    test('Replace Letters', () {
      final List<String> replace = WordGeneration.replace('cat', ['a', 'b']);
      expect(replace, equals(['aat', 'bat', 'cat', 'cbt', 'caa', 'cab']));
    });
  });
}
