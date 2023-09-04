import 'dart:developer';

import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:photo_sender/src/blocs/reporter_bloc.dart';
import 'package:photo_sender/src/blocs/reporter_states.dart';
import 'package:photo_sender/src/widgets/report_details_widget.dart';

Future<void> main() async {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    log('${record.level.name}: ${record.loggerName}: ${record.message}');
  });

  runApp(const ReportDetailsScreenDemo());
}

class ReportDetailsScreenDemo extends StatelessWidget {
  const ReportDetailsScreenDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ReporterBloc>(
          create: (_) => ReporterBloc(),
        ),
      ],
      child: MaterialApp(
        // localizationsDelegates: AppLocalizations.localizationsDelegates,
        // supportedLocales: AppLocalizations.supportedLocales,
        // locale: Locale('ru'),
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Report Details Demo'),
          ),
          body: ReportDetailsWidget(
            state: ReporterReportState(report: Report.empty()),
          ),
        ),
      ),
    );
  }
}
