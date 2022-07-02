class WordTokenizer {
  static List<String> tokenize(String content) {
    String separators =
        '[ .*+!)?,\:\;@£§€\\{\\[\\]\\}\\\\\\?«» ºª\$%&/()=\\|!\'\\"#\<\>\-]+';
    RegExp regExp = RegExp(separators);

    List<String> words = content.split(regExp);

    return words.where((String element) => element.isNotEmpty).toList();
  }
}
