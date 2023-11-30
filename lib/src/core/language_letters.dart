/// This class is used to manage the letters of different languages
/// It is essential for operations like addition and replacement in spell checking.
class LanguageLetters {
  /// Map of letters for each supported language
  static const Map<String, String> letters = {
    'de': 'abcdefghijklmnopqrstuvwxyzäöüß', // German
    'en': 'abcdefghijklmnopqrstuvwxyz', // English
    'es': 'abcdefghijklmnopqrstuvwxyzñ', // Spanish
    'fr': 'abcdefghijklmnopqrstuvwxyzàâæçéèêëïîôœùûüÿ', // French
    'it': 'abcdefghijklmnopqrstuvwxyzàèéìîòóù', // Italian
    'no': 'abcdefghijklmnopqrstuvwxyzæøå', // Norwegian
    'pt': 'abcdefghijklmnopqrstuvwxyzáâãàçéêíóôõú', // Portuguese
    'sv': 'abcdefghijklmnopqrstuvwxyzåäö', // Swedish
  };

  static final List<String> _allLetters =
      letters.values.expand((s) => s.split('')).toSet().toList();

  /// Retrieves the list of letters for a given language
  /// Retrieves the list of letters for a specific language, defaulting to English if not found.
  static List<String> getLanguageForLanguage(String language) =>
      letters[language]?.split('') ?? letters['en']!.split('');

  /// Returns a list of German letters.
  static List<String> germanLetters() => letters['de']!.split('');

  /// Returns a list of English letters.
  static List<String> englishLetters() => letters['en']!.split('');

  /// Returns a list of Spanish letters.
  static List<String> spanishLetters() => letters['es']!.split('');

  /// Returns a list of French letters.
  static List<String> frenchLetters() => letters['fr']!.split('');

  /// Returns a list of Italian letters.
  static List<String> italianLetters() => letters['it']!.split('');

  /// Returns a list of Norwegian letters.
  static List<String> norwegianLetters() => letters['no']!.split('');

  /// Returns a list of Portuguese letters.
  static List<String> portugueseLetters() => letters['pt']!.split('');

  /// Returns a list of Swedish letters.
  static List<String> swedishLetters() => letters['sv']!.split('');

  /// Retrieves all letters from the supported languages combined.
  static List<String> get getAllLetters => _allLetters;
}
