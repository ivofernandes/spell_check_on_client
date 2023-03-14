# Context
Spell check is something that tends to be done in server side, but it actually don't need to be like that.

With an extra 1.5Mb of words in a text file you will be able to deliver a spell check with below 200ms response time and save cloud costs.

![Spell check](https://raw.githubusercontent.com/ivofernandes/spell_check_on_client/master/doc/screenshot.png?raw=true)

# How this package works
This package uses an hashset comparison algorithm to deliver a spell check that can work offline in the client side 

## Features
- Tokenize a string with multiple words into single word tokens
- Let the programmer configure what are the words so it can work in a multi language way
- Find words in your text that are not in the dictionary
- apply operations to find what are the possible words similar enough that belong to the dictionary
- operations supported to find words: addition, deletion, swap, replace
# Future features

## Getting started

In this video I show how to run the example app of this package:
https://www.youtube.com/watch?v=YbMR9CEbvCE

Add the dependency to your `pubspec.yaml`:

```
spell_check_on_client: ^0.0.3
```

## Usage

To use this package you will need to add the list of words as an asset inside your app
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