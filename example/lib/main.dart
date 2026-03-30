import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spell_check_on_client/spell_check_on_client.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Spell check',
        theme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
          colorScheme: ColorScheme.fromSeed(
            brightness: Brightness.dark,
            seedColor: const Color(0xFF4B8BFF),
          ),
          scaffoldBackgroundColor: const Color(0xFF0F172A),
        ),
        home: const LanguageSelection(),
      );
}

class LanguageSelection extends StatefulWidget {
  const LanguageSelection({
    super.key,
  });

  @override
  State<LanguageSelection> createState() => _LanguageSelectionState();
}

class _LanguageSelectionState extends State<LanguageSelection> {
  final Map<String, String> languages = {
    'English': 'en',
    'Portuguese': 'pt',
    'Español': 'es',
    'Italiano': 'it',
    'Deutsch': 'de',
    'Français': 'fr',
    'Norsk': 'no',
    'Svenska': 'sv',
    'Amharic': 'am',
    'Arabic': 'ar',
    'Chinese': 'zh',
    'Japanese': 'ja'
  };

  String language = 'English';

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Spell check'),
              Text(
                'On-device • configurable',
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: language,
                  borderRadius: BorderRadius.circular(12),
                  icon: const Icon(Icons.keyboard_arrow_down_rounded),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        language = newValue;
                      });
                    }
                  },
                  items: languages.keys
                      .map<DropdownMenuItem<String>>(
                        (String selectedLanguage) => DropdownMenuItem<String>(
                          value: selectedLanguage,
                          child: Text(selectedLanguage),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          ],
        ),
        body: SpellCheckExample(
          language: languages[language]!,
          key: ValueKey(language),
        ),
      );
}

enum DictionarySource {
  assets,
  rankedMap,
}

class SpellCheckExample extends StatefulWidget {
  final String language;

  const SpellCheckExample({
    required this.language,
    super.key,
  });

  @override
  State<SpellCheckExample> createState() => _SpellCheckExampleState();
}

class _SpellCheckExampleState extends State<SpellCheckExample> {
  final TextEditingController suggestionController = TextEditingController();
  final TextEditingController controller = TextEditingController();
  final TextEditingController logController = TextEditingController();
  final TextEditingController singleWordController =
      TextEditingController(text: 'example');

  String didYouMean = '';
  String unknownWords = '';
  String similarityResult = '';
  bool isLoadingDictionary = true;

  DictionarySource dictionarySource = DictionarySource.assets;
  bool useLanguageLetters = true;
  bool? useMapValuesAsRelevance;
  int iterations = 2;
  double maxSuggestions = 8;

  SpellCheck spellCheck = SpellCheck.fromWordsList(['cat', 'bat', 'hat']);

  @override
  void initState() {
    super.initState();
    initSpellCheck();
  }

  @override
  void dispose() {
    suggestionController.dispose();
    controller.dispose();
    logController.dispose();
    singleWordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<String> languageLetters =
        LanguageLetters.getLanguageForLanguage(widget.language);

    return SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 860),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildConfigCard(languageLetters),
                const SizedBox(height: 16),
                Text(
                  'Text to spell check',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  minLines: 5,
                  maxLines: 8,
                  controller: controller,
                  decoration: InputDecoration(
                    hintText:
                        'Type a sentence with mistakes to test suggestions…',
                    filled: true,
                    fillColor: const Color(0xFF111827),
                    contentPadding: const EdgeInsets.all(14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                ElevatedButton.icon(
                  onPressed: isLoadingDictionary ? null : spellCheckValidate,
                  icon: isLoadingDictionary
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.spellcheck_rounded),
                  label: Text(
                    isLoadingDictionary
                        ? 'Loading dictionary…'
                        : 'Run spell-check methods',
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
                const SizedBox(height: 14),
                _resultCard(
                  title: 'didYouMean()',
                  value: didYouMean,
                ),
                const SizedBox(height: 12),
                _resultCard(
                  title: 'unKnownWords()',
                  value: unknownWords,
                ),
                const SizedBox(height: 12),
                _resultCard(
                  title:
                      'didYouMeanAny("${singleWordController.text.trim()}", maxWords: ${maxSuggestions.round()})',
                  value: similarityResult,
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Performance logs',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: clearLogs,
                      icon: const Icon(Icons.delete_outline_rounded),
                      label: const Text('Clear'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                TextField(
                  enabled: false,
                  minLines: 8,
                  maxLines: 14,
                  controller: logController,
                  style: const TextStyle(fontFamily: 'monospace'),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFF020617),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildConfigCard(List<String> languageLetters) => Card(
        color: const Color(0xFF1E293B),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Package configuration',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              const Text(
                'Configure constructor options and run multiple API methods.',
              ),
              const SizedBox(height: 12),
              SegmentedButton<DictionarySource>(
                segments: const [
                  ButtonSegment<DictionarySource>(
                    value: DictionarySource.assets,
                    label: Text('fromWordsContent'),
                    icon: Icon(Icons.description_outlined),
                  ),
                  ButtonSegment<DictionarySource>(
                    value: DictionarySource.rankedMap,
                    label: Text('SpellCheck(words: ...)'),
                    icon: Icon(Icons.map_outlined),
                  ),
                ],
                selected: {dictionarySource},
                onSelectionChanged: (Set<DictionarySource> newSelection) {
                  setState(() {
                    dictionarySource = newSelection.first;
                  });
                  initSpellCheck();
                },
              ),
              const SizedBox(height: 10),
              SwitchListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                title: const Text('Use language-specific letters optimization'),
                subtitle: Text(
                  useLanguageLetters
                      ? 'letters: LanguageLetters.getLanguageForLanguage(...) '
                          '(${languageLetters.length} chars)'
                      : 'letters: null (uses all available letters)',
                ),
                value: useLanguageLetters,
                onChanged: (bool value) {
                  setState(() {
                    useLanguageLetters = value;
                  });
                  initSpellCheck();
                },
              ),
              const SizedBox(height: 8),
              Text('iterations: $iterations'),
              Slider(
                min: 1,
                max: 4,
                divisions: 3,
                value: iterations.toDouble(),
                label: '$iterations',
                onChanged: (double value) {
                  setState(() {
                    iterations = value.round();
                  });
                },
                onChangeEnd: (_) => initSpellCheck(),
              ),
              const SizedBox(height: 8),
              Text('didYouMeanAny maxWords: ${maxSuggestions.round()}'),
              Slider(
                min: 3,
                max: 20,
                divisions: 17,
                value: maxSuggestions,
                label: '${maxSuggestions.round()}',
                onChanged: (double value) {
                  setState(() {
                    maxSuggestions = value;
                  });
                },
              ),
              if (dictionarySource == DictionarySource.rankedMap) ...[
                const SizedBox(height: 8),
                DropdownButtonFormField<bool?>(
                  initialValue: useMapValuesAsRelevance,
                  decoration: const InputDecoration(
                    labelText: 'useMapValuesAsRelevance',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem<bool?>(
                      child: Text('null (auto-detect)'),
                    ),
                    DropdownMenuItem<bool?>(
                      value: true,
                      child: Text('true'),
                    ),
                    DropdownMenuItem<bool?>(
                      value: false,
                      child: Text('false'),
                    ),
                  ],
                  onChanged: (bool? value) {
                    setState(() {
                      useMapValuesAsRelevance = value;
                    });
                    initSpellCheck();
                  },
                ),
              ],
              const SizedBox(height: 10),
              TextFormField(
                controller: singleWordController,
                decoration: const InputDecoration(
                  labelText: 'Word input for didYouMeanAny()',
                  border: OutlineInputBorder(),
                ),
                onChanged: (_) {
                  if (!isLoadingDictionary) {
                    spellCheckValidate();
                  }
                },
              ),
            ],
          ),
        ),
      );

  Widget _resultCard({
    required String title,
    required String value,
  }) =>
      Card(
        color: const Color(0xFF1E293B),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              SelectableText(
                value.isEmpty ? '-' : value,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      );

  Future<void> initSpellCheck() async {
    setState(() {
      isLoadingDictionary = true;
      didYouMean = '';
      unknownWords = '';
      similarityResult = '';
      logController.text = '';
    });

    final DateTime start = DateTime.now();
    final List<String>? letters = useLanguageLetters
        ? LanguageLetters.getLanguageForLanguage(widget.language)
        : null;

    if (dictionarySource == DictionarySource.assets) {
      final String content =
          await rootBundle.loadString('assets/${widget.language}_words.txt');
      spellCheck = SpellCheck.fromWordsContent(
        content,
        letters: letters,
        iterations: iterations,
      );
    } else {
      spellCheck = SpellCheck(
        words: _rankedWordsMap(widget.language),
        letters: letters,
        iterations: iterations,
        useMapValuesAsRelevance: useMapValuesAsRelevance,
      );
    }

    final DateTime parsed = DateTime.now();

    final Map<String, String> sampleTexts = {
      'en': 'This is an exammple senttence in English.',
      'pt': 'Este é um exemmplo de frase em Português.',
      'es': 'Esta es una frasse de ejemplo en Español.',
      'it': 'Questa è una frasse di esempio in Italiano.',
      'de': 'Dies ist ein Beispielllsatz auf Deutsch.',
      'fr': "Ceci est une frase d'exemple en Français.",
      'no': 'Dette er en eksemppelsetning på Norsk.',
      'sv': 'Detta är en exempellmening på Svenska.',
      'am': 'ይህ በአማርኛ የተጻፈ ምሳሌ ዐረፍተ ነገር ነው።',
      'ar': 'هذه جملة مثال باللغة العربية.',
      'zh': '这是一个中文示例句子。',
      'ja': 'これは日本語の例文です。'
    };

    controller.text = sampleTexts[widget.language] ?? '';

    final int timeSpent =
        parsed.millisecondsSinceEpoch - start.millisecondsSinceEpoch;

    setState(() {
      isLoadingDictionary = false;
      logController.text +=
          'Init ${timeSpent}ms • source: ${dictionarySource.name} • '
          'iterations: $iterations • letters: ${letters?.length ?? 'all'}\n';
    });
  }

  void spellCheckValidate() {
    final DateTime start = DateTime.now();
    final String text = controller.text;
    final String suggestion = spellCheck.didYouMean(text);
    final List<String> unKnown = spellCheck.unKnownWords(text);
    final double percentage = spellCheck.getPercentageCorrect(text);
    final String wordInput = singleWordController.text.trim();
    final List<String> similar = wordInput.isEmpty
        ? const []
        : spellCheck.didYouMeanAny(
            wordInput,
            maxWords: maxSuggestions.round(),
          );
    final DateTime end = DateTime.now();

    final int timeSpent =
        end.millisecondsSinceEpoch - start.millisecondsSinceEpoch;

    setState(() {
      didYouMean = suggestion;
      unknownWords =
          unKnown.isEmpty ? 'All words are known.' : unKnown.join(', ');
      similarityResult =
          similar.isEmpty ? 'No suggestions' : similar.join(', ');
      suggestionController.text = 'Did you mean: $didYouMean';
      logController.text +=
          'Checked ${timeSpent}ms • correctness: ${(percentage * 100).toStringAsFixed(1)}%\n';
    });
  }

  Map<String, int> _rankedWordsMap(String languageCode) {
    if (languageCode == 'pt') {
      return {
        'este': 30,
        'é': 29,
        'um': 28,
        'exemplo': 27,
        'de': 26,
        'frase': 25,
        'em': 24,
        'português': 23,
      };
    }

    if (languageCode == 'es') {
      return {
        'esta': 30,
        'es': 29,
        'una': 28,
        'frase': 27,
        'de': 26,
        'ejemplo': 25,
        'en': 24,
        'español': 23,
      };
    }

    return {
      'this': 30,
      'is': 29,
      'an': 28,
      'example': 27,
      'sentence': 26,
      'in': 25,
      'english': 24,
      'spell': 23,
      'check': 22,
      'package': 21,
      'configurable': 20,
    };
  }

  void clearLogs() {
    setState(() {
      logController.text = '';
    });
  }
}
