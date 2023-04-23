import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';

class LanguagePage extends StatefulWidget {
  @override
  _LanguagePageState createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        title: const LocaleText("localization"),
      ),
      body: Column(
        children: [
          ListTile(
            title: const Text("English"),
            onTap: () => LocaleNotifier.of(context)?.change('en'),
          ),
          ListTile(
            title: const Text("Tagalog"),
            onTap: () => LocaleNotifier.of(context)?.change('fil'),
          )
        ],
      ),
    );
  }
}
