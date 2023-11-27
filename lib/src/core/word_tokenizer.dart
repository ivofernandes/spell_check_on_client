class WordTokenizer {
  /// Divides a string into words
  static List<String> tokenize(String content) {
    final String separators = '[ .*+!)?,:;@£§€\\{\\[\\]\\}\\\\\\?«» ºª\$%&/()=\\|!\'\\"#<>-]+';
    final RegExp regExp = RegExp(separators);

    final List<String> words = content.split(regExp);

    return words.where((String element) => element.isNotEmpty).toList();
  }
}
