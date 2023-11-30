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
        theme: ThemeData(),
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
    'Norsk': 'no', // Norwegian
    'Svenska': 'sv' // Swedish
  };

  String language = 'English';

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: const Text('Spell check'),
        actions: [
          DropdownButton<String>(
            value: language,
            icon: const Icon(Icons.arrow_drop_down),
            underline: Container(height: 0, color: Colors.transparent),
            onChanged: (String? newValue) {
              if (newValue != null) {
                setState(() {
                  language = newValue;
                });
              }
            },
            items: languages.keys
                .map<DropdownMenuItem<String>>(
                    (String language) => DropdownMenuItem<String>(
                          value: language,
                          child: Text(language),
                        ))
                .toList(),
          ),
          const SizedBox(
            width: 10,
          )
        ],
      ),
      body: SpellCheckExample(
        language: languages[language]!,
        key: UniqueKey(),
      ));
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
  String didYouMean = '';
  SpellCheck spellCheck = SpellCheck.fromWordsList(['cat', 'bat', 'hat']);
  TextEditingController controller = TextEditingController();
  TextEditingController logController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initSpellCheck();
  }

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(10),
          child: Column(
            children: [
              TextFormField(
                maxLines: 4,
                controller: controller,
                decoration: InputDecoration(
                    focusColor: Theme.of(context).textTheme.bodyLarge!.color,
                    contentPadding: const EdgeInsets.all(10.0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.primary)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                            color: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .color!))),
              ),
              MaterialButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 10,
                color: Theme.of(context).colorScheme.primary,
                child: const Text('Spell check'),
                onPressed: () => spellCheckValidate(),
              ),
              didYouMean == ''
                  ? const SizedBox()
                  : Column(
                      children: [
                        Text('Did you mean $didYouMean?'),
                      ],
                    ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                enabled: false,
                minLines: 10,
                maxLines: 1000,
                controller: logController,
              ),
              MaterialButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  elevation: 10,
                  color: Theme.of(context).colorScheme.primary,
                  child: const Text('Clear logs'),
                  onPressed: () => clearLogs())
            ],
          ),
        ),
      );

  void initSpellCheck() async {
    final DateTime start = DateTime.now();
    final String content =
        await rootBundle.loadString('assets/${widget.language}_words.txt');

    spellCheck = SpellCheck.fromWordsContent(content,
        letters: LanguageLetters.getLanguageForLanguage(widget.language));
    final DateTime parsed = DateTime.now();

    // Update the text controller with the sample text for the selected language
    final Map<String, String> sampleTexts = {
      'en': 'This is an exammple sentence in English.',
      'pt': 'Este é um exemmplo de frase em Português.',
      'es': 'Esta es una frasse de ejemplo en Español.',
      'it': 'Questa è una frasse di esempio in Italiano.',
      'de': 'Dies ist ein Beispielllsatz auf Deutsch.',
      'fr': 'Ceci est une frase d\'exemple en Français.',
      'no': 'Dette er en eksemppelsetning på Norsk.',
      'sv': 'Detta är en exempellmening på Svenska.'
    };

    controller.text = sampleTexts[widget.language] ?? '';

    final int timeSpent =
        parsed.millisecondsSinceEpoch - start.millisecondsSinceEpoch;
    logController.text += 'Load ${timeSpent}ms\n';
    debugPrint('Time spent');
  }

  void spellCheckValidate() {
    final DateTime start = DateTime.now();
    final String text = controller.text;
    didYouMean = spellCheck.didYouMean(text);
    final DateTime end = DateTime.now();

    final int timeSpent =
        end.millisecondsSinceEpoch - start.millisecondsSinceEpoch;
    logController.text += 'Checked ${timeSpent}ms\n';
    setState(() {});
  }

  void clearLogs() {
    logController.text = '';
  }
}
