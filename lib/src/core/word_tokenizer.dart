class WordTokenizer {
  static bool hasCjk(String text) => text.runes.any((r) =>
      (r >= 0x3040 && r <= 0x30ff) ||
      (r >= 0x3400 && r <= 0x9fff) ||
      (r >= 0x20000 && r <= 0x323af));

  /// Divides a string into words
  static List<String> tokenize(String content,
      {Map<String, dynamic>? dictionary}) {
    const String separators =
        '[ .*+!)?,:;@£§€\\{\\[\\]\\}\\\\\\?«» ºª\$%&/()=\\|!\'\\"#<>-]+';
    final RegExp regExp =
        RegExp('$separators|[\\s、。！？：；，‘’“”「」『』（）【】〈〉《》،؛؟።]+');

    final List<String> words = content.split(regExp);

    return words.where((element) => element.isNotEmpty).expand((word) {
      if (dictionary == null || !hasCjk(word)) {
        return [word];
      }
      final chars = word.runes.map(String.fromCharCode).toList();
      final result = <String>[];
      var unknown = '';
      for (var i = 0; i < chars.length;) {
        String? match;
        var end = i;
        for (var j = chars.length; j > i; j--) {
          final candidate = chars.sublist(i, j).join();
          if (dictionary.containsKey(candidate)) {
            match = candidate;
            end = j;
            break;
          }
        }
        if (match == null) {
          unknown += chars[i++];
        } else {
          if (unknown.isNotEmpty) {
            result.add(unknown);
          }
          unknown = '';
          result.add(match);
          i = end;
        }
      }
      if (unknown.isNotEmpty) {
        result.add(unknown);
      }
      return result;
    }).toList();
  }
}
