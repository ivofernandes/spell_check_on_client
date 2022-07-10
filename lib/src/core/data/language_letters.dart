class LanguageLetters {
  static List<String> getLanguageForLanguage(String language) {
    if (language == 'pt') {
      return portugueseLetters();
    } else {
      return englishLetters();
    }
  }

  static List<String> englishLetters() => [
        'a',
        'b',
        'c',
        'd',
        'e',
        'f',
        'g',
        'h',
        'i',
        'j',
        'k',
        'l',
        'm',
        'n',
        'o',
        'p',
        'q',
        'r',
        's',
        't',
        'u',
        'v',
        'x',
        'z',
        '\''
      ];

  static portugueseLetters() {
    return [
      'a',
      'b',
      'c',
      'd',
      'e',
      'f',
      'g',
      'h',
      'i',
      'j',
      'k',
      'l',
      'm',
      'n',
      'o',
      'p',
      'q',
      'r',
      's',
      't',
      'u',
      'v',
      'x',
      'z',
      'ç',
      'á',
      'é',
      'í',
      'ó',
      'ú',
      'â',
      'ê',
      'î',
      'ô',
      'û'
    ];
  }
}
