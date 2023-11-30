import 'package:spell_check_on_client/src/core/word_tokenizer.dart';
import 'package:test/test.dart';

void main() {
  group('WordTokenizer Tests', () {
    const List<String> expectedTokens = [
      'Now',
      'We',
      'will',
      'do',
      'a',
      'more',
      'complex',
      'test',
      'Will',
      'it',
      'work',
      'Hope',
      'so'
    ];

    test('Tokenize text with spaces', () {
      final List<String> tokens =
          WordTokenizer.tokenize('spaced text for test');
      expect(tokens, equals(['spaced', 'text', 'for', 'test']));
    });

    test('Tokenize text with standard punctuation', () {
      final List<String> tokens = WordTokenizer.tokenize(
          'Now! We will do, a more complex test...Will it work? Hope so :)');
      expect(tokens, equals(expectedTokens));
    });

    test('Tokenize text with exaggerated punctuation', () {
      final List<String> tokens = WordTokenizer.tokenize(
          r'Now! (We) <will> [do], &a #more %complex test...Will: it; work? \Hope+* so :)');
      expect(tokens, equals(expectedTokens));
    });
  });
}
