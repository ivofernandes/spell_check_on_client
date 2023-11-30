import 'package:spell_check_on_client/src/core/find_words/word_generation.dart';
import 'package:spell_check_on_client/src/core/find_words/words_filter.dart';

class FindClosestWord {
  /// Find a list of closest words
  static List<String> list(
    Map<String, dynamic> allWords,
    String wordParam,
    List<String> letters,
    int iterations,
    bool useMapValuesAsRelevance,
    int maxWords,
  ) {
    final String word = wordParam.toLowerCase();
    final List<String> bestWords = [];

    // Start by replacing just one consonant
    final List<String> replaceConsonants =
        WordGeneration.replace(word, letters, replaceVowels: false);
    final consonants = WordsFilter.pickBestWords(
        replaceConsonants, allWords, useMapValuesAsRelevance, maxWords);
    bestWords.addAll(consonants);

    int remainingSpace = maxWords - bestWords.length;
    if (remainingSpace <= 0) {
      return bestWords;
    }

    // Then iterate over to replace two consonants
    final List<String> replaceConsonantsSecondIteration = [];
    for (final consonant in replaceConsonants) {
      final List<String> iteration =
          WordGeneration.replace(consonant, letters, replaceVowels: false);
      replaceConsonantsSecondIteration.addAll(iteration);
    }

    final consonantsSecond = WordsFilter.pickBestWords(
        replaceConsonantsSecondIteration,
        allWords,
        useMapValuesAsRelevance,
        maxWords);
    bestWords.addAll(consonantsSecond);

    if (maxWords - bestWords.length <= 0) {
      return bestWords;
    }

    // Then move on to delete, insert and swap edits
    // Get the closest blocks from the input word
    final List<List<String>> closeBlocks = edit(word, iterations, 1, letters);

    int i = 0;

    for (final List<String> closeWords in closeBlocks) {
      final List<String> firstIteration = WordsFilter.pickBestWords(
          closeWords, allWords, useMapValuesAsRelevance, maxWords);
      bestWords.addAll(firstIteration);

      remainingSpace = maxWords - bestWords.length;
      if (remainingSpace <= 0) {
        break;
      } else if (i == 0) {
        // Try the replace this is a last resort mechanism
        // As it can quite easily find words
        // in a next iteration the replace can take in consideration the keyboard configuration
        final List<String> replaces = WordGeneration.replace(word, letters);
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
    int currentStepParam,
    List<String> letters,
  ) {
    final List<List<String>> result = [];
    final List<String> list = [];
    int currentStep = currentStepParam;

    list.addAll(WordGeneration.delete(word));
    list.addAll(WordGeneration.insert(word, letters));
    list.addAll(WordGeneration.swap(word));

    result.add(list);

    // If there are more embedded edits, do a recursive call
    if (iterations > currentStep) {
      currentStep++;
      final List<String> newEditsList = [];

      for (final String wordInList in list) {
        newEditsList.addAll(WordGeneration.delete(wordInList));
        newEditsList.addAll(WordGeneration.insert(wordInList, letters));
        newEditsList.addAll(WordGeneration.swap(wordInList));
      }

      result.add(newEditsList);
    }

    return result;
  }
}
