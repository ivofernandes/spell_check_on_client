import 'package:spell_check_on_client/src/core/find_words/word_generation.dart';

class FindClosestWord {
  /// Find the searched word
  static String find(Map<String, int> allWords, String word,
      List<String> letters, int iterations) {
    word = word.toLowerCase();
    // Get the closest blocks from the input word
    List<List<String>> closeBlocks = edit(word, iterations, 1, letters);
    String bestWord = '';
    int i = 0;

    for (List<String> closeWords in closeBlocks) {
      bestWord = pickBestWord(closeWords, allWords);

      if (bestWord != '') {
        break;
      } else if (i == 0) {
        // Try the replace
        List<String> replaces = WordGeneration.replace(word, letters);
        bestWord = pickBestWord(replaces, allWords);

        if (bestWord != '') {
          break;
        }
      }
      i++;
    }

    return bestWord;
  }

  static String pickBestWord(List<String> closeBlocks, Map<String, int> words) {
    // Check what are the close blocks that exist in dictionary
    Map<String, int> closeWordsFound = {};
    for (String block in closeBlocks) {
      int? relevance = words[block];
      if (relevance != null) {
        closeWordsFound[block] = relevance;
      }
    }

    // Pick the most relevant word
    int bestRelevance = 0;
    String bestWord = '';
    for (String word in closeWordsFound.keys) {
      int relevance = closeWordsFound[word]!;

      if (relevance > bestRelevance) {
        bestRelevance = relevance;
        bestWord = word;
      }
    }

    return bestWord;
  }

  /// Get a list of words with all the edits
  /// @param iterations number of edits that will do
  /// @param currentStep current step of edits
  static List<List<String>> edit(
      String word, int iterations, int currentStep, List<String> letters) {
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
