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
    // New languages:
    'am': 'ሀለሐመሠረቀበተኀነዐዘዠገጠጨፈፐ', // Amharic (sample set)
    'ar': 'ابتثجحخدذرزسشصضطظعغفقكلمنهوي', // Arabic
    'zh': '的一是在不了有和', // Chinese (sample common characters)
    'ja':
        'あいうえおかきくけこさしすせそたちつてとなにぬねのはひふへほまみむめもやゆよらりるれろわをん', // Japanese (hiragana)
  };

  static final List<String> _allLetters =
      letters.values.expand((s) => s.split('')).toSet().toList();

  /// Retrieves the list of letters for a given language.
  /// Defaults to English if the language is not found.
  static List<String> getLanguageForLanguage(String language) =>
      letters[language]?.split('') ?? letters['en']!.split('');

  /// Returns a list of letters for each language.
  static List<String> germanLetters() => letters['de']!.split('');
  static List<String> englishLetters() => letters['en']!.split('');
  static List<String> spanishLetters() => letters['es']!.split('');
  static List<String> frenchLetters() => letters['fr']!.split('');
  static List<String> italianLetters() => letters['it']!.split('');
  static List<String> norwegianLetters() => letters['no']!.split('');
  static List<String> portugueseLetters() => letters['pt']!.split('');
  static List<String> swedishLetters() => letters['sv']!.split('');

  // New helper methods for the additional languages:
  static List<String> amharicLetters() => letters['am']!.split('');
  static List<String> arabicLetters() => letters['ar']!.split('');
  static List<String> chineseLetters() => letters['zh']!.split('');
  static List<String> japaneseLetters() => letters['ja']!.split('');

  /// Retrieves all letters from the supported languages combined.
  static List<String> get getAllLetters => _allLetters;
}
