abstract class WordGenerationReplace {
  static const String vowels = 'aeiouáéíóúàèìòùâêîôûäöüãõyåøæı';

  static final Map<String, String> _accentMap = {
    'á': 'a', 'à': 'a', 'â': 'a', 'ä': 'a', 'ã': 'a', 'å': 'a',
    'é': 'e', 'è': 'e', 'ê': 'e', 'ë': 'e',
    'í': 'i', 'ì': 'i', 'î': 'i', 'ï': 'i',
    'ó': 'o', 'ò': 'o', 'ô': 'o', 'ö': 'o', 'õ': 'o',
    'ú': 'u', 'ù': 'u', 'û': 'u', 'ü': 'u',
    'Á': 'A', 'À': 'A', 'Â': 'A', 'Ä': 'A', 'Ã': 'A', 'Å': 'A',
    'É': 'E', 'È': 'E', 'Ê': 'E', 'Ë': 'E',
    'Í': 'I', 'Ì': 'I', 'Î': 'I', 'Ï': 'I',
    'Ó': 'O', 'Ò': 'O', 'Ô': 'O', 'Ö': 'O', 'Õ': 'O',
    'Ú': 'U', 'Ù': 'U', 'Û': 'U', 'Ü': 'U',
  };

  static List<String> replace(String wordMisspelled, List<String> letters, {bool replaceVowels = false}) {
    if (wordMisspelled.length <= 1) {
      return [];
    }

    final List<String> replaced = [];

    // Stage 1: Replace vowels with their accent variants
    for (int i = 0; i < wordMisspelled.length; i++) {
      final String originalChar = wordMisspelled[i];
      if (_accentMap.containsKey(originalChar)) {
        final String swapped = _accentMap[originalChar]!;
        if (swapped != originalChar) {
          replaced.add(_replaceChar(wordMisspelled, i, swapped));
        }
      }
    }

    // Stage 2: Replace consonants
    for (int i = 0; i < wordMisspelled.length; i++) {
      final String originalChar = wordMisspelled[i];
      if (!_isVowel(originalChar)) {
        for (final String letter in letters) {
          if (!_isVowel(letter) && letter != originalChar) {
            replaced.add(_replaceChar(wordMisspelled, i, letter));
          }
        }
      }
    }

    // Stage 3: Replace vowels if enabled
    if (replaceVowels) {
      for (int i = 0; i < wordMisspelled.length; i++) {
        final String originalChar = wordMisspelled[i];
        if (_isVowel(originalChar)) {
          for (final String letter in letters) {
            if (letter != originalChar) {
              replaced.add(_replaceChar(wordMisspelled, i, letter));
            }
          }
        }
      }
    }

    return replaced;
  }

  static String _replaceChar(String word, int index, String newChar) {
    return word.substring(0, index) + newChar + word.substring(index + 1);
  }

  static bool _isVowel(String ch) {
    return vowels.contains(_toBaseChar(ch).toLowerCase());
  }

  static String _toBaseChar(String ch) => _accentMap[ch] ?? ch;
}
