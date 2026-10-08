import 'package:spell_check_on_client/spell_check_on_client.dart';
import 'package:test/test.dart';

void main() {
  test('Non-Latin corrections do not require complete alphabets', () {
    for (final pair in [
      ['世界', '世畀'],
      ['こんにちは', 'こんにちわ'],
      ['カメラ', 'カメロ'],
      ['مرحبا', 'مرحباا'],
      ['ሀሳብ', 'ሀሳብብ'],
      ['привет', 'приветт'],
      ['한국', '한굳'],
      ['𠮷野', '𠮷也'],
      ['猫', '描'],
    ]) {
      final checker =
          SpellCheck.fromWordsList([pair[0]], letters: ['a'], iterations: 1);
      expect(checker.didYouMeanWord(pair[1]), pair[0]);
      expect(checker.didYouMeanAny(pair[1]), [pair[0]]);
    }
  });
  test('CJK segmentation and punctuation are preserved', () {
    final checker =
        SpellCheck.fromWordsList(['你好', '世界', 'こんにちは', '日本語', 'です']);
    expect(checker.unKnownWords('你好世界！こんにちは日本語です。'), isEmpty);
    expect(checker.getPercentageCorrect('你好世界！'), 1);
    expect(checker.didYouMean('你好，世畀！'), '你好，世界！');
    expect(checker.didYouMean('こんにちは日本語です。'), 'こんにちは日本語です。');
  });
  test('Unicode whitespace and punctuation split words', () {
    expect(WordTokenizer.tokenize('你好，世界。\n日本語\tです！مرحبا،العالم؟'),
        ['你好', '世界', '日本語', 'です', 'مرحبا', 'العالم']);
  });
  test('Distance precedes relevance, limits and swaps work', () {
    const checker =
        SpellCheck(words: {'世界': 1, '世間': 20, '世界中': 100}, iterations: 1);
    expect(checker.didYouMeanAny('世界', maxWords: 1), ['世界']);
    expect(checker.didYouMeanWord('界世'), '世界');
    expect(checker.didYouMeanAny('全然違う'), isEmpty);
    expect(checker.didYouMeanAny('世畀', maxWords: 0), isEmpty);
  });
  test('Dictionary content trims BOM and blank lines', () {
    final checker = SpellCheck.fromWordsContent('\uFEFF世界\r\n 日本語 \n\n');
    expect(checker.isCorrect('世界'), isTrue);
    expect(checker.isCorrect('日本語'), isTrue);
    expect(checker.words.containsKey(''), isFalse);
  });
}
