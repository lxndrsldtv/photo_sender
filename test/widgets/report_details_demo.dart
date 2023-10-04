import 'dart:developer';

import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_texts.dart';
import 'package:logging/logging.dart';
import 'package:photo_sender/src/blocs/reporter_bloc.dart';
import 'package:photo_sender/src/blocs/reporter_events.dart';
import 'package:photo_sender/src/blocs/reporter_states.dart';
import 'package:photo_sender/src/widgets/report_details_widget.dart';

import 'fake_reporter_bloc.dart';

Future<void> main() async {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    log('${record.level.name}: ${record.loggerName}: ${record.message}');
  });

  final reporterBloc = FakeReporterBloc()..sendingResultSuccess = false;
  reporterBloc.add(PhotoPrepared(reportPhoto: Photo.empty()));
  await Future.delayed(const Duration(seconds: 1));

  runApp(ReportDetailsScreenDemo(bloc: reporterBloc));
}

class ReportDetailsScreenDemo extends StatelessWidget {
  const ReportDetailsScreenDemo({super.key, required this.bloc});

  final ReporterBloc bloc;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ReporterBloc>(
          create: (_) => bloc,
        ),
      ],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        // locale: const Locale('ru'),
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
          useMaterial3: true,
          textTheme: const TextTheme().copyWith(
            headlineMedium: const TextStyle(color: Colors.white),
            headlineSmall: const TextStyle(
                color: Colors.black26,
                fontSize: 14,
                fontStyle: FontStyle.italic),
          ),
        ),

        home: Scaffold(
          appBar: AppBar(
            title: const Text('Report Details Demo'),
          ),
          body: BlocBuilder<ReporterBloc, ReporterState>(
            builder: (_, state) => ReportDetailsWidget(
              bloc: bloc,
            ),
          ),
        ),
      ),
    );
  }
}
