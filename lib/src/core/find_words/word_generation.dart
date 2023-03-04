import 'dart:math';

/// Generate possible words from a misspelled word using the following operations
/// delete, swap, insert, replace
class WordGeneration {
  static const String vowels = 'aeiouáéíóúàèìòùâêîôûäöüãõyåøæı';

  /// Find possible words if the user missed a letter
  static List<String> delete(String wordMisspelled) {
    if (wordMisspelled.length <= 1) {
      return [];
    }

    List<String> deletes = [];

    for (int i = 0; i < wordMisspelled.length; i++) {
      String prefix = wordMisspelled.substring(0, i);
      String suffix = wordMisspelled.substring(i + 1, wordMisspelled.length);

      String block = prefix + suffix;
      deletes.add(block);
    }

    return deletes;
  }

  /// Find possible words if user swapped some chars
  static List<String> swap(String wordMisspelled) {
    if (wordMisspelled.length <= 1) {
      return [];
    }

    List<String> swaps = [];

    for (int i = 0; i < wordMisspelled.length - 1; i++) {
      String prefix = wordMisspelled.substring(0, max(i, 0));
      String suffix = wordMisspelled.substring(min(wordMisspelled.length, i + 2), wordMisspelled.length);

      String newWord = prefix + wordMisspelled[i + 1] + wordMisspelled[i] + suffix;
      swaps.add(newWord);
    }

    return swaps;
  }

  /// Find possible words if user missed some char
  static List<String> insert(String wordMisspelled, List<String> letters) {
    if (wordMisspelled.isEmpty) {
      return [];
    }

    List<String> inserted = [];
    for (int i = 0; i < wordMisspelled.length + 1; i++) {
      for (String letter in letters) {
        String prefix = wordMisspelled;
        String suffix = '';

        if (i < wordMisspelled.length) {
          prefix = wordMisspelled.substring(0, i);
          suffix = wordMisspelled.substring(i, wordMisspelled.length);
        }

        String possibleMisspell = prefix + letter + suffix;
        inserted.add(possibleMisspell);
      }
    }
    return inserted;
  }

  /// Find possible words if user replaced some char
  static List<String> replace(String wordMisspelled,
      List<String> letters, {
        bool replaceVowels = true,
      }) {
    if (wordMisspelled.length <= 1) {
      return [];
    }

    List<String> replaced = [];
    for (int i = 0; i < wordMisspelled.length; i++) {
      // If the user don't want to replace vowels
      if (!replaceVowels) {
        // Check if the current char is a vowel
        String currentChar = wordMisspelled[i];
        bool isVowel = vowels.contains(currentChar);
        if (isVowel) {
          continue;
        }
      }

      // Do the replace
      String prefix = wordMisspelled.substring(0, i);
      String suffix = wordMisspelled.substring(i + 1, wordMisspelled.length);
      for (String letter in letters) {
        if (i == 0 && letter == '-') {
          continue;
        }

        String block = prefix + letter + suffix;
        replaced.add(block);
      }
    }

    return replaced;
  }
}
