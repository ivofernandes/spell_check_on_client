import 'package:spell_check_on_client/src/core/find_words/word_generation.dart';
import 'package:spell_check_on_client/src/core/find_words/words_filter.dart';

class FindClosestWord {
  /// Find a list of closest words
  static List<String> list(
    Map<String, dynamic> allWords,
    String word,
    List<String> letters,
    int iterations,
    bool useMapValuesAsRelevance,
    int maxWords,
  ) {
    word = word.toLowerCase();
    // Get the closest blocks from the input word
    List<List<String>> closeBlocks = edit(word, iterations, 1, letters);
    List<String> bestWords = [];
    int i = 0;

    for (List<String> closeWords in closeBlocks) {
      bestWords = WordsFilter.pickBestWords(
          closeWords, allWords, useMapValuesAsRelevance, maxWords);

      int remainingSpace = maxWords - bestWords.length;
      if (remainingSpace <= 0) {
        break;
      } else if (i == 0) {
        // Try the replace this is a last resort mechanism
        // As it can quite easily find words
        // in a next iteration the replace can take in consideration the keyboard configuration
        List<String> replaces = WordGeneration.replace(word, letters);
        bestWords.addAll(WordsFilter.pickBestWords(
            replaces, allWords, useMapValuesAsRelevance, remainingSpace));

        if (bestWords.length >= maxWords) {
          break;
        }
      }
      i++;
    }

    return bestWords;
  }

  /// Find the searched word
  static String find(
    Map<String, dynamic> allWords,
    String word,
    List<String> letters,
    int iterations,
    bool useMapValuesAsRelevance,
  ) {
    final listWords =
        list(allWords, word, letters, iterations, useMapValuesAsRelevance, 1);

    return listWords.isNotEmpty ? listWords[0] : '';
  }

  /// Get a list of words with all the edits
  /// @param iterations number of edits that will do
  /// @param currentStep current step of edits
  static List<List<String>> edit(
    String word,
    int iterations,
    int currentStep,
    List<String> letters,
  ) {
    List<List<String>> result = [];
    List<String> list = [];

    list.addAll(WordGeneration.delete(word));
    list.addAll(WordGeneration.insert(word, letters));
    list.addAll(WordGeneration.swap(word));

    result.add(list);

    // If there are more embedded edits, do a recursive call
    if (iterations > currentStep) {
      currentStep++;
      List<String> newEditsList = [];

      for (String wordInList in list) {
        newEditsList.addAll(WordGeneration.delete(wordInList));
        newEditsList.addAll(WordGeneration.insert(wordInList, letters));
        newEditsList.addAll(WordGeneration.swap(wordInList));
      }

      result.add(newEditsList);
    }

    return result;
  }
}
