class WordsFilter {
  /// Pick the best word based on the relevance of each word
  static List<String> pickBestWords(
    List<String> closeBlocks,
    Map<String, dynamic> words,
    bool useMapValuesAsRelevance,
    int maxWords,
  ) {
    final Map<String, int> closeWordsFound =
        _getRelevanceMap(closeBlocks, words, useMapValuesAsRelevance);

    // Reverse the map to get the words with the most relevance
    final Map<int, List<String>> relevanceMap = {};

    for (final String word in closeWordsFound.keys) {
      final int relevance = closeWordsFound[word]!;
      if (relevanceMap[relevance] == null) {
        relevanceMap[relevance] = [];
      }
      relevanceMap[relevance]!.add(word);
    }

    // Sort the relevance map
    final List<int> relevanceList = relevanceMap.keys.toList();
    relevanceList.sort((a, b) => b.compareTo(a));

    // Get the best words
    final List<String> bestWords = [];
    for (final int relevance in relevanceList) {
      final List<String> words = relevanceMap[relevance]!;
      words.sort();
      bestWords.addAll(words);

      if (bestWords.length >= maxWords) {
        break;
      }
    }

    return bestWords;
  }

  /// Get a map of found words to it's relevance in the dictionary
  static Map<String, int> _getRelevanceMap(
    List<String> closeBlocks,
    Map<String, dynamic> words,
    bool useMapValuesAsRelevance,
  ) {
    // Check what are the close blocks that exist in dictionary
    final Map<String, int> closeWordsFound = {};
    for (final String block in closeBlocks) {
      int relevance = 0;

      // If the word exists in the dictionary
      if (words.containsKey(block)) {
        if (useMapValuesAsRelevance) {
          relevance = words[block] as int;
        }

        closeWordsFound[block] = relevance;
      }
    }

    return closeWordsFound;
  }
}
