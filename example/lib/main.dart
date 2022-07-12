import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spell_check_on_client/spell_check_on_client.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Spell check',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LanguageSelection(),
    );
  }
}

class LanguageSelection extends StatefulWidget {
  const LanguageSelection({Key? key}) : super(key: key);

  @override
  State<LanguageSelection> createState() => _LanguageSelectionState();
}

class _LanguageSelectionState extends State<LanguageSelection> {
  final Map<String, String> languages = {
    'English': 'en',
    'Portuguese': 'pt',
    'Español': 'es'
  };

  String language = 'English';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Spell check'),
          actions: [
            DropdownButton<String>(
              dropdownColor: Theme.of(context).primaryColor,
              icon: Icon(
                Icons.arrow_drop_down,
                color: Theme.of(context).canvasColor,
              ),
              value: language,
              items: languages.keys.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: TextStyle(color: Theme.of(context).canvasColor),
                  ),
                );
              }).toList(),
              onChanged: (String? language) {
                this.language = language!;
                setState(() {});
              },
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
}

class SpellCheckExample extends StatefulWidget {
  final String language;
  const SpellCheckExample({required this.language, Key? key}) : super(key: key);

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
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.all(10),
        child: Column(
          children: [
            TextFormField(
              maxLines: 4,
              controller: controller,
              decoration: InputDecoration(
                  focusColor: Theme.of(context).textTheme.bodyText1!.color,
                  contentPadding: const EdgeInsets.all(10.0),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.primary)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                          color:
                              Theme.of(context).textTheme.bodyText1!.color!))),
            ),
            MaterialButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 10,
                color: Theme.of(context).colorScheme.primary,
                child: const Text('Spell check'),
                onPressed: () => spellCheckValidate()),
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
              maxLines: 10,
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
  }

  void initSpellCheck() async {
    DateTime start = DateTime.now();
    String content =
        await rootBundle.loadString('assets/${widget.language}_words.txt');

    spellCheck = SpellCheck.fromWordsContent(content,
        letters: LanguageLetters.getLanguageForLanguage(widget.language));
    DateTime parsed = DateTime.now();

    int timeSpent =
        parsed.millisecondsSinceEpoch - start.millisecondsSinceEpoch;
    logController.text += 'Load ${timeSpent}ms\n';
    print('Time spent');
  }

  void spellCheckValidate() {
    DateTime start = DateTime.now();
    String text = controller.text;
    didYouMean = spellCheck.didYouMean(text);
    DateTime end = DateTime.now();

    int timeSpent = end.millisecondsSinceEpoch - start.millisecondsSinceEpoch;
    logController.text += 'Checked ${timeSpent}ms\n';
    setState(() {});
  }

  void clearLogs() {
    logController.text = '';
  }
}
