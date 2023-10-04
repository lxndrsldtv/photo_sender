import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_texts.dart';
import 'package:logging/logging.dart';
import 'package:photo_sender/src/repositories/http_report_repository.dart';

import './src/blocs/reporter_bloc.dart';
import './src/services/location_service.dart';
import './src/widgets/reporter_widget.dart';

void main() async {
  Logger.root.level = Level.SHOUT;
  Logger.root.onRecord.listen((record) {
    log('${record.level.name}: ${record.loggerName}: ${record.message}');
  });

  runApp(const PhotoSender());
}

class PhotoSender extends StatelessWidget {
  const PhotoSender({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ReporterBloc>(
          create: (_) => AppReporterBloc(
              location: PlatformLocationService(),
              reportRepository: HttpReportRepository()),
        ),
      ],
      child: MaterialApp(
        title: 'Photo Sender',
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
        home: const ReporterWidget(),
      ),
    );
  }
}
