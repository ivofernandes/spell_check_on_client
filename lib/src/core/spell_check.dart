class SpellCheck {
  final Map<String, int> words;

  const SpellCheck({required this.words});

  /// Returns empty string if thinks the content is fine
  /// or some text if it thinks you mean something else
  String didYouMean(String contentToCheck) {
    String didYouMean = 'test';

    return didYouMean;
  }

  /// Constructor that will basically transform your list into an hashset
  static SpellCheck fromWordsList(List<String> wordsList) {
    Map<String, int> words = {};
    int value = words.length;

    for (String word in wordsList) {
      words[word] = value;
      value--;
    }

    return SpellCheck(words: words);
  }
}
