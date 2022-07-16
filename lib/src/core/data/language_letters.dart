class LanguageLetters {
  static const Map<String, String> letters = {
    'en': '-abcdefghijklmnopqrstuvwxyzàáâãäæçèéêìíîòóôõöùúûü',
    'pt': '-abcdefghijklmnopqrstuvwxyzàáâãçèéêíóôõú',
    'es': '-abcdefghijklmnopqrstuvwxyzàáçèéíîóöúü',
    'it': 'abcdefghijklmnopqrstuvwxyzàáâãäçèéêìíîòóõöùúü',
    'de': 'abcdefghijklmnopqrstuvwxyzàáâäæçèéêíîóôöûü',
    'fr': 'abcdefghijklmnopqrstuvwxyzàáâãäæçèéêìíîòóôõöùúûü'
  };

  static List<String> getLanguageForLanguage(String language) {
    if (language == 'pt') {
      return portugueseLetters();
    } else {
      return englishLetters();
    }
  }

  static List<String> convertToList(String text) {
    List<String> result = [];

    for (int i = 0; i < text.length; i++) {
      result.add(text[i]);
    }

    return result;
  }

  static List<String> englishLetters() => convertToList(letters['en']!);
  static List<String> portugueseLetters() => convertToList(letters['pt']!);
}
