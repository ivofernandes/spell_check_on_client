[![pub package](https://img.shields.io/pub/v/spell_check_on_client.svg?label=spell_check_on_client&color=blue)](https://pub.dev/packages/spell_check_on_client)
[![likes](https://img.shields.io/pub/likes/spell_check_on_client?logo=dart)](https://pub.dev/packages/spell_check_on_client/score)
[![pub points](https://img.shields.io/pub/points/sentry?logo=dart)](https://pub.dev/packages/spell_check_on_client/score)

# Context
Traditionally, spell checking is performed server-side; however, this isn't a necessity. The spell_check_on_client package brings efficient, offline spell checking directly to the client side, saving on cloud costs and providing rapid response times.

By embedding a compact 1.5MB dictionary text file, your application can perform spell checks in under 200ms, reducing latency and preserving data privacy.

![Spell check](https://raw.githubusercontent.com/ivofernandes/spell_check_on_client/master/doc/screenshot.png?raw=true)

# How this package works
This package uses an hashset comparison algorithm to deliver a spell check that can work offline in the client side 

## Features
- Tokenize a string with multiple words into single word tokens
- Let the programmer configure what are the words so it can work in a multi language way
- Find words in your text that are not in the dictionary
- apply operations to find what are the possible words similar enough that belong to the dictionary
- operations supported to find words: addition, deletion, swap, replace

## Getting started

In this video I show how to run the example app of this package:

https://www.youtube.com/watch?v=YbMR9CEbvCE

Add the dependency to your `pubspec.yaml`:

```
spell_check_on_client: ^0.0.8
```

## Usage

To use this package you will need to add the list of words as an asset inside your app:
- German - de_words.txt
- English - en_words.txt
- Spanish - es_words.txt
- French - fr_words.txt
- Italian - it_words.txt
- Norwegian - no_words.txt
- Portuguese - pt_words.txt
- Swedish - sv_words.txt

You can find the file assets here:

https://github.com/ivofernandes/spell_check_on_client/tree/master/example/assets


Then you need to init the check spell in an async method:
```dart
 SpellCheck
  void initSpellCheck() async {
      String language = 'en';
      String content = await rootBundle.loadString('assets/${language}_words.txt');
       spellCheck = SpellCheck.fromWordsContent(content,
          letters: LanguageLetters.getLanguageForLanguage(language));
  }
```

Then you just need to call the did you mean method to receive a suggestion or an empty string if every word exists
```dart
  String didYouMean = spellCheck.didYouMean(text);
```

If it looks to hard to use you can always start your app by forking this example app:
https://github.com/ivofernandes/spell_check_on_client/blob/master/example/lib/main.dart


## Like us on pub.dev
Package url:
https://pub.dev/packages/spell_check_on_client


## Instruction to publish the package to pub.dev
dart pub publish