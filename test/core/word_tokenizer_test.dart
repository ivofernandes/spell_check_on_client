import 'package:collection/collection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spell_check_on_client/src/core/word_tokenizer.dart';

void main() {
  Function eq = const ListEquality().equals;
  List<String> sharedValidation = [
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

  test('Tokenizer spaced test', () {
    List<String> words = WordTokenizer.tokenize('spaced text for test');

    assert(eq(words, ['spaced', 'text', 'for', 'test']));
  });

  test('Tokenizer with punctuation', () {
    List<String> words = WordTokenizer.tokenize(
        'Now! We will do, a more complex test...Will it work? Hope so :)');

    assert(eq(words, sharedValidation));
  });

  test('Tokenizer with exaggerated punctuation', () {
    List<String> words = WordTokenizer.tokenize(
        'Now! (We) <will> [do], &a #more %complex test...Will: it; work? \\Hope+* so :)');

    assert(eq(words, sharedValidation));
  });
}
