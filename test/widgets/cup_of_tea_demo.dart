// import 'dart:developer';

import 'package:cup_of_tea/cup_of_tea.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_gen/gen_l10n/app_texts.dart';
// import 'package:logging/logging.dart';

Future<void> main() async {
  // Logger.root.level = Level.ALL;
  // Logger.root.onRecord.listen((record) {
  //   log('${record.level.name}: ${record.loggerName}: ${record.message}');
  // });

  runApp(const CupOfTea());
}

class CupOfTea extends StatelessWidget {
  const CupOfTea({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // localizationsDelegates: AppLocalizations.localizationsDelegates,
      // supportedLocales: AppLocalizations.supportedLocales,
      // // locale: const Locale('ru'),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        useMaterial3: true,
        textTheme: const TextTheme().copyWith(
          headlineMedium: const TextStyle(color: Colors.white),
          headlineSmall: const TextStyle(
              color: Colors.black26, fontSize: 14, fontStyle: FontStyle.italic),
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Cup of Tea Demo'),
        ),
        body: const Steam(),
      ),
    );
  }
}
