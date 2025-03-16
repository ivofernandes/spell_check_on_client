import 'dart:math';

/// Generate possible words from a misspelled word using the following operations
/// delete, swap, insert, replace
class WordGeneration {
  /// Find possible words if the user missed a letter
  static List<String> delete(String wordMisspelled) {
    if (wordMisspelled.length <= 1) {
      return [];
    }

    final List<String> deletes = [];

    for (int i = 0; i < wordMisspelled.length; i++) {
      final String prefix = wordMisspelled.substring(0, i);
      final String suffix =
          wordMisspelled.substring(i + 1, wordMisspelled.length);

      final String block = prefix + suffix;
      deletes.add(block);
    }

    return deletes;
  }

  /// Find possible words if user swapped some chars
  static List<String> swap(String wordMisspelled) {
    if (wordMisspelled.length <= 1) {
      return [];
    }

    final List<String> swaps = [];

    for (int i = 0; i < wordMisspelled.length - 1; i++) {
      final String prefix = wordMisspelled.substring(0, max(i, 0));
      final String suffix = wordMisspelled.substring(
          min(wordMisspelled.length, i + 2), wordMisspelled.length);

      final String newWord =
          prefix + wordMisspelled[i + 1] + wordMisspelled[i] + suffix;
      swaps.add(newWord);
    }

    return swaps;
  }

  /// Find possible words if user missed some char
  static List<String> insert(String wordMisspelled, List<String> letters) {
    if (wordMisspelled.isEmpty) {
      return [];
    }

    final List<String> inserted = [];
    for (int i = 0; i < wordMisspelled.length + 1; i++) {
      for (final String letter in letters) {
        String prefix = wordMisspelled;
        String suffix = '';

        if (i < wordMisspelled.length) {
          prefix = wordMisspelled.substring(0, i);
          suffix = wordMisspelled.substring(i, wordMisspelled.length);
        }

        final String possibleMisspell = prefix + letter + suffix;
        inserted.add(possibleMisspell);
      }
    }
    return inserted;
  }
}
