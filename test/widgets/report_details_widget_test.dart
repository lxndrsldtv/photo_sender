import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_texts.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:photo_sender/src/blocs/reporter_bloc.dart';
import 'package:photo_sender/src/blocs/reporter_events.dart';
import 'package:photo_sender/src/blocs/reporter_states.dart';
import 'package:photo_sender/src/widgets/report_details_widget.dart';

import 'fake_reporter_bloc_impl.dart';

void main() {
  group('ReportDetailsWidget tests', () {
    Future<void> init(WidgetTester tester) async {
      // instantiate fake bloc, set it to imitate error of sending report
      final reporterBloc = FakeReporterBlocImpl()..sendingResultSuccess = false;
      // initialise bloc, imitate changing state from camera to report
      reporterBloc.add(PhotoPrepared(reportPhoto: Photo.empty()));

      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider<ReporterBloc>(
              create: (_) => reporterBloc,
            ),
          ],
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            // locale: Locale('ru'),
            home: Scaffold(
              appBar: AppBar(
                title: const Text('Report Details Demo'),
              ),
              body: BlocBuilder<ReporterBloc, ReporterState>(
                builder: (_, state) => ReportDetailsWidget(
                  bloc: reporterBloc,
                ),
              ),
            ),
          ),
        ),
      );
    }

    testWidgets('ReportDetailsWidget must provide ability to comment photo',
        (WidgetTester tester) async {
      await init(tester);
      await tester.enterText(find.byType(TextField), 'comment');
      await tester.pump();
      expect(find.text('comment'), findsOneWidget);
    });

    testWidgets('ReportDetailsWidget must inform, that photo is sending',
        (WidgetTester tester) async {
      await init(tester);
      await tester.tap(find.text('Send'));
      await tester.pump();
      expect(find.text('Sending photo...'), findsOneWidget);
      await tester.pump(const Duration(seconds: 3));
    });

    testWidgets('ReportDetailsWidget must inform, if sending fails',
        (WidgetTester tester) async {
      await init(tester);
      await tester.tap(find.text('Send'));
      await tester.pump();
      // wait till sending finishes
      await tester.pump(const Duration(seconds: 3));
      expect(find.text('Sending failed'), findsOneWidget);
    });
  });
}
