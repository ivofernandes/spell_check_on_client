/// This class is used to get the letters of a language
/// This is quite important to addiction and replace edits
class LanguageLetters {
  /// List of letters for each language
  static const Map<String, String> letters = {
    'en': '-abcdefghijklmnopqrstuvwxyzàáâãäæçèéêìíîòóôõöùúûü',
    'pt': '-abcdefghijklmnopqrstuvwxyzàáâãçèéêíóôõú',
    'es': '-abcdefghijklmnopqrstuvwxyzàáçèéíîóöúü',
    'it': 'abcdefghijklmnopqrstuvwxyzàáâãäçèéêìíîòóõöùúü',
    'de': 'abcdefghijklmnopqrstuvwxyzàáâäæçèéêíîóôöûü',
    'fr': 'abcdefghijklmnopqrstuvwxyzàáâãäæçèéêìíîòóôõöùúûü'
  };

  static final List<String> _allLetters = letters.values.join().split('').toSet().toList();

  static List<String> getLanguageForLanguage(String language) {
    final languageLetters = letters[language] ?? letters['en']!;
    return convertToList(languageLetters);
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

  static get getAllLetters => _allLetters;
}
