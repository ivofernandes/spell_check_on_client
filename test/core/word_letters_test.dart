// ignore_for_file: avoid_print

import 'dart:collection';
import 'dart:io';

import 'package:test/test.dart';

void main() {
  test('Generate letters for each language', () async {
    final List<String> languages = ['pt', 'en', 'es', 'it', 'de', 'fr'];
    for (final String language in languages) {
      final HashSet<String> letters = HashSet();

      final String filePath = 'example/assets/${language}_words.txt';
      final String content = await File(filePath).readAsString();

      for (int i = 0; i < content.length; i++) {
        final String c = content[i];

        if (c != ' ' && c != '\n') {
          letters.add(c);
        }
      }

      final List<String> lettersList = letters.toList();
      lettersList.sort();
      final String lettersString =
          lettersList.reduce((String a, String b) => '$a$b');
      print('Letters for $language : $lettersString');
    }
  });
}
