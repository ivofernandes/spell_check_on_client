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

  /// Uses map values as relevance. This is only useful if the map is not a `Map<String, int>`,
  /// where the key is the word text and the value represents its relevance.
  /// If it's null will use the default value depending on the type of the map,
  /// If the map is a `Map<String, int>`, it will use `true`; otherwise, it will use `false`.
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
    final List<String> unknownWords = [];

    final List<String> blocks = WordTokenizer.tokenize(text);
    for (final String word in blocks) {
      if (!words.containsKey(word)) {
        unknownWords.add(word);
      }
    }

    return unknownWords;
  }

  /// Returns percentage of words that were found in the dictionary
  double getPercentageCorrect(String text) {
    final List<String> blocks = WordTokenizer.tokenize(text);
    int correctWords = 0;
    for (final String word in blocks) {
      if (words.containsKey(word)) {
        correctWords++;
      }
    }

    return correctWords / blocks.length;
  }

  /// Check if the word exists
  bool isCorrect(String word) => words.containsKey(word);

  /// Returns empty string if thinks the content is fine
  /// or some text if it thinks you mean something else
  String didYouMean(String contentToCheck) {
    String didYouMean = '';

    bool corrected = false;
    final List<String> blocks = WordTokenizer.tokenize(contentToCheck);
    final List<String> checkedBlocks = [];
    for (final String word in blocks) {
      final String correctWord = didYouMeanWord(word);
      checkedBlocks.add(correctWord);

      if (correctWord != '') {
        corrected = true;
      }
    }

    if (corrected) {
      for (int i = 0; i < checkedBlocks.length; i++) {
        const String separator = ' ';
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
      return word;
    }
  }

  /// Returns a list of words that are similar to the word input
  List<String> didYouMeanAny(
    String wordInput, {
    int maxWords = 50,
  }) {
    List<String> result = FindClosestWord.list(
      words,
      wordInput,
      letters ?? LanguageLetters.getAllLetters,
      iterations,
      hasRelevance,
      maxWords,
    );

    if (result.length > maxWords) {
      result = result.sublist(0, maxWords);
    }

    return result;
  }

  /// Constructor that will basically transform your list into an hashset
  static SpellCheck fromWordsList(
    List<String> wordsList, {
    List<String>? letters,
    int iterations = 2,
  }) {
    final Map<String, int> words = {};
    int value = wordsList.length;

    for (final String word in wordsList) {
      words[word] = value;
      value--;
    }

    letters ??= LanguageLetters.getAllLetters;

    return SpellCheck(words: words, letters: letters, iterations: iterations);
  }

  /// Constructor that receive a file content and generate the words
  static SpellCheck fromWordsContent(
    String content, {
    List<String>? letters,
    int iterations = 2,
  }) {
    final List<String> words = const LineSplitter().convert(content);

    letters ??= LanguageLetters.getAllLetters;

    return fromWordsList(words, letters: letters, iterations: iterations);
  }
}
