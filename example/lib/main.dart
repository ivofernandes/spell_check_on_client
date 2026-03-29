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
                'On-device • fast',
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

  String didYouMean = '';
  bool isLoadingDictionary = true;
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 780),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
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
                      hintText: 'Type a sentence with mistakes to test suggestions…',
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
                          : 'Spell check now',
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                  const SizedBox(height: 14),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 180),
                    child: didYouMean.isEmpty
                        ? const SizedBox.shrink()
                        : Card(
                            key: ValueKey(didYouMean),
                            color: const Color(0xFF1E293B),
                            child: Padding(
                              padding: const EdgeInsets.all(14),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Suggestion',
                                    style:
                                        Theme.of(context).textTheme.titleSmall,
                                  ),
                                  const SizedBox(height: 8),
                                  SelectableText(
                                    didYouMean,
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  ),
                                ],
                              ),
                            ),
                          ),
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

  Future<void> initSpellCheck() async {
    setState(() {
      isLoadingDictionary = true;
      didYouMean = '';
      logController.text = '';
    });

    final DateTime start = DateTime.now();
    final String content =
        await rootBundle.loadString('assets/${widget.language}_words.txt');

    spellCheck = SpellCheck.fromWordsContent(
      content,
      letters: LanguageLetters.getLanguageForLanguage(widget.language),
    );
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
      logController.text += 'Load ${timeSpent}ms\n';
    });
  }

  void spellCheckValidate() {
    final DateTime start = DateTime.now();
    final String text = controller.text;
    final String suggestion = spellCheck.didYouMean(text);
    final DateTime end = DateTime.now();

    final int timeSpent =
        end.millisecondsSinceEpoch - start.millisecondsSinceEpoch;

    setState(() {
      didYouMean = suggestion;
      suggestionController.text = 'Did you mean: $didYouMean';
      logController.text += 'Checked ${timeSpent}ms\n';
    });
  }

  void clearLogs() {
    setState(() {
      logController.text = '';
    });
  }
}
