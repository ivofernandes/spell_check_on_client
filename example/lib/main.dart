import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spell check',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Spell check'),
          ),
          body: SpellCheckExample()),
    );
  }
}

class SpellCheckExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          TextFormField(
            maxLines: 4,
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
                        color: Theme.of(context).textTheme.bodyText1!.color!))),
          ),
          MaterialButton(
              color: Theme.of(context).colorScheme.primary,
              child: const Text('Spell check'),
              onPressed: () => print('Spell check'))
        ],
      ),
    );
  }
}
