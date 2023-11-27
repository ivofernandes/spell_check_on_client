import 'package:spell_check_on_client/src/core/spell_check.dart';
import 'package:test/test.dart';

void main() {
  group('SpellCheck Tests', () {
    late SpellCheck spellCheck;

    setUp(() {
      // Initialize SpellCheck with a common set of words for all tests
      spellCheck = SpellCheck.fromWordsList(['cat', 'bat', 'hat']);
    });

    test('Find unknown words in a phrase', () {
      final List<String> unknownWords = spellCheck.unKnownWords('a cat and bat');
      expect(unknownWords, equals(['a', 'and']));
    });

    test('Correct a word with an extra letter', () {
      final String correction = spellCheck.didYouMean('crat');
      expect(correction, equals('cat'));
    });

    test('Correct a word with a missing letter', () {
      final String correction = spellCheck.didYouMean('ca');
      expect(correction, equals('cat'));
    });

    test('Correct a word with a replaced letter', () {
      // Re-initialize with a different iteration setting for this specific test
      spellCheck = SpellCheck.fromWordsList(['cat', 'bat', 'hat'], iterations: 1);

      final String correction = spellCheck.didYouMean('bar');
      expect(correction, equals('bat'));
    });
  });
}
