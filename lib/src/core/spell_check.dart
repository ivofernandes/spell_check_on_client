import 'dart:convert';

import 'package:spell_check_on_client/src/core/data/letters.dart';
import 'package:spell_check_on_client/src/core/find_words/find_closest_word.dart';
import 'package:spell_check_on_client/src/core/word_tokenizer.dart';

class SpellCheck {
  final Map<String, int> words;
  final List<String> letters;
  final int iterations;

  const SpellCheck(
      {required this.words, required this.letters, this.iterations = 2});

  /// Returns a list of words in the text that were not found in the dictionary
  List<String> unKnownWords(String text) {
    List<String> unknownWords = [];

    List<String> blocks = WordTokenizer.tokenize(text);
    for (String word in blocks) {
      if (!words.containsKey(word)) {
        unknownWords.add(word);
      }
    }

    return unknownWords;
  }

  /// Returns empty string if thinks the content is fine
  /// or some text if it thinks you mean something else
  String didYouMean(String contentToCheck) {
    String didYouMean = '';

    bool corrected = false;
    List<String> blocks = WordTokenizer.tokenize(contentToCheck);
    List<String> checkedBlocks = [];
    for (String word in blocks) {
      String correctWord = didYouMeanWord(word);
      checkedBlocks.add(correctWord);

      if (correctWord != '') {
        corrected = true;
      }
    }

    if (corrected) {
      for (int i = 0; i < checkedBlocks.length; i++) {
        String separator = ' ';
        if (checkedBlocks[i] == '') {
          didYouMean += blocks[i] + separator;
        } else {
          didYouMean += checkedBlocks[i] + separator;
        }
      }
    }

    return didYouMean.trim();
  }

  /// Check a single word
  String didYouMeanWord(String word) {
    if (words[word] == null) {
      return FindClosestWord.find(words, word, letters, iterations);
    } else {
      return '';
    }
  }

  /// Constructor that will basically transform your list into an hashset
  static SpellCheck fromWordsList(List<String> wordsList,
      {List<String>? letters, int iterations = 2}) {
    Map<String, int> words = {};
    int value = wordsList.length;

    for (String word in wordsList) {
      words[word] = value;
      value--;
    }

    letters ??= Letters.englishLetters();

    return SpellCheck(words: words, letters: letters, iterations: iterations);
  }

  /// Constructor that receive a file content and generate the words
  static SpellCheck fromWordsContent(String content,
      {List<String>? letters, int iterations = 2}) {
    List<String> words = const LineSplitter().convert(content);

    letters ??= Letters.englishLetters();

    return fromWordsList(words, letters: letters, iterations: 2);
  }
}
