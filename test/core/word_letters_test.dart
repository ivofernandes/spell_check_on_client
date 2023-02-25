import 'dart:collection';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Generate letters for each language', () async {
    List<String> languages = ['pt', 'en', 'es', 'it', 'de', 'fr'];
    for (String language in languages) {
      HashSet<String> letters = HashSet();

      String filePath = 'example/assets/${language}_words.txt';
      String content = await File(filePath).readAsString();

      for (int i = 0; i < content.length; i++) {
        String c = content[i];

        if (c != ' ' && c != '\n') {
          letters.add(c);
        }
      }

      List<String> lettersList = letters.toList();
      lettersList.sort();
      String lettersString = lettersList.reduce((String a, String b) => '$a$b');
      debugPrint('Letters for $language : $lettersString');
    }
  });
}
