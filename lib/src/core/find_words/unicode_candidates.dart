import 'dart:math';

/// Dictionary search avoids enumerating enormous non-Latin alphabets.
class UnicodeCandidates {
  static bool applies(String word) => word.runes.any((r) => r > 0x024f);

  static List<String> find(Map<String, dynamic> words, String input,
      int iterations, bool ranked, int limit) {
    if (limit <= 0) {
      return [];
    }
    final source = input.toLowerCase().runes.toList();
    final distances = <String, int>{};
    for (final word in words.keys) {
      final target = word.toLowerCase().runes.toList();
      if ((source.length - target.length).abs() > iterations) {
        continue;
      }
      final distance = _distance(source, target);
      if (distance <= iterations) {
        distances[word] = distance;
      }
    }
    final candidates = distances.keys.toList()
      ..sort((a, b) {
        final distance = distances[a]!.compareTo(distances[b]!);
        if (distance != 0) {
          return distance;
        }
        if (ranked) {
          final relevance = (words[b] as int).compareTo(words[a] as int);
          if (relevance != 0) {
            return relevance;
          }
        }
        return a.compareTo(b);
      });
    return candidates.take(limit).toList();
  }

  // Optimal string alignment distance: insert, delete, replace, adjacent swap.
  static int _distance(List<int> a, List<int> b) {
    var previous = List<int>.generate(b.length + 1, (i) => i);
    var beforePrevious = previous;
    for (var i = 1; i <= a.length; i++) {
      final current = List<int>.filled(b.length + 1, 0)..[0] = i;
      for (var j = 1; j <= b.length; j++) {
        current[j] = min(min(current[j - 1] + 1, previous[j] + 1),
            previous[j - 1] + (a[i - 1] == b[j - 1] ? 0 : 1));
        if (i > 1 && j > 1 && a[i - 1] == b[j - 2] && a[i - 2] == b[j - 1]) {
          current[j] = min(current[j], beforePrevious[j - 2] + 1);
        }
      }
      beforePrevious = previous;
      previous = current;
    }
    return previous.last;
  }
}
