import 'package:spell_check_on_client/src/core/find_words/word_generation.dart';

class FindClosestWord {
  /*
def edit1(word):
  return set(delete(word) + swap(word) + replace(word) + insert(word))

print(edit1("trash"))
def edit2(word):
  return set(e2 for e1 in edit1(word) for e2 in edit1(e1))

     */

  /// Find the searched word
  ///
  static String find(Map<String, int> words, String word) {
    // Get the closest blocks from the input word
    List<String> closeBlocks = [];
    closeBlocks.addAll(edit(word, 2, 1));

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
  static List<String> edit(String word, int iterations, int currentStep) {
    List<String> list = [];

    list.addAll(WordGeneration.delete(word));
    list.addAll(WordGeneration.insert(word));
    list.addAll(WordGeneration.swap(word));
    list.addAll(WordGeneration.replace(word));

    // If there are more embedded edits, do a recursive call
    if (iterations > currentStep) {
      currentStep++;
      List<String> newEditsList = [];

      for (String wordInList in list) {
        newEditsList.addAll(edit(wordInList, iterations, currentStep));
      }

      list.addAll(newEditsList);
    }

    return list;
  }
}
