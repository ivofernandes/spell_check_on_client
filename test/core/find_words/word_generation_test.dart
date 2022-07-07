import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spell_check_on_client/src/core/find_words/word_generation.dart';

void main() {
  Function eq = const ListEquality().equals;

  test('Test delete letter', () {
    List<String> deletes = WordGeneration.delete('cat');

    assert(eq(deletes, ['at', 'ct', 'ca']));
  });

  test('Test swap letters', () {
    List<String> swaps = WordGeneration.swap('cat');

    assert(eq(swaps, ['act', 'cta']));
  });

  test('Test insert letters', () {
    List<String> inserted = WordGeneration.insert('cat', ['a', 'b']);
    json.encode(inserted);
    assert(eq(inserted,
        ["acat", "bcat", "caat", "cbat", "caat", "cabt", "cata", "catb"]));
  });

  test('Test replace letters', () {
    List<String> replace = WordGeneration.replace('cat', ['a', 'b']);

    assert(eq(replace, ["aat", "bat", "cat", "cbt", "caa", "cab"]));
  });
}
