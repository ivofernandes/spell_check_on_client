import 'dart:convert';

import 'package:spell_check_on_client/src/core/find_words/find_closest_word.dart';
import 'package:spell_check_on_client/src/core/language_letters.dart';
import 'package:spell_check_on_client/src/core/word_tokenizer.dart';

/// Class that performs the and highly configurable spell check
/// After receiving a word will perform: delete, swap, insert, replace
/// in order to find the closest word in the dictionary
class SpellCheck {
  const SpellCheck({
    required this.words,
    this.letters,
    this.iterations = 2,
    this.useMapValuesAsRelevance,
  });

  /// Possible words pointing to their relevance
  /// If is a different kind of map,
  /// you can use [useMapValuesAsRelevance] as false
  /// to don't use the map values to sort words by relevance
  final Map<String, dynamic> words;

  /// Use map values as relevance that is only useful if the map is not a Map<String, int> from word text to it's relevance
  /// If it's null will use the default value depending on the type of the map,
  /// if the map is a Map<String, int> will use true, otherwise will use false
  final bool? useMapValuesAsRelevance;

  /// The letters that are allowed in the language
  /// If not provided will use a generic combination of all letters
  /// So this parameter is optional and only related to performance
  final List<String>? letters;

  /// The number of iterations to run the spell check
  /// Meaning that will perform multiple iterations of delete, swap, insert, replace in the same word
  final int iterations;

  bool get hasRelevance => useMapValuesAsRelevance ?? words is Map<String, int>;

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
    if (words[word.toLowerCase()] == null) {
      return FindClosestWord.find(words, word,
          letters ?? LanguageLetters.getAllLetters, iterations, hasRelevance);
    } else {
      return '';
    }
  }

  /// Returns a list of words that are similar to the word input
  List<String> didYouMeanAny(
    String wordInput, {
    int maxWords = 50,
  }) {
    return FindClosestWord.list(
        words,
        wordInput,
        letters ?? LanguageLetters.getAllLetters,
        iterations,
        hasRelevance,
        maxWords);
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

    letters ??= LanguageLetters.getAllLetters;

    return SpellCheck(words: words, letters: letters, iterations: iterations);
  }

  /// Constructor that receive a file content and generate the words
  static SpellCheck fromWordsContent(String content,
      {List<String>? letters, int iterations = 2}) {
    List<String> words = const LineSplitter().convert(content);

    letters ??= LanguageLetters.getAllLetters;

    return fromWordsList(words, letters: letters, iterations: 2);
  }
}
