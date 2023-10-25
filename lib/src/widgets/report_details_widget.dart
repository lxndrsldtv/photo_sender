import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_texts.dart';
import 'package:logging/logging.dart';

import '../blocs/reporter_bloc.dart';
import '../blocs/reporter_events.dart';
import '../blocs/reporter_states.dart';
import '../settings.dart';

class ReportDetailsWidget extends StatelessWidget {
  const ReportDetailsWidget({super.key, required this.bloc});

  final ReporterBloc bloc;

  @override
  Widget build(BuildContext context) {
    final logger = Logger('ReportDetailsWidget');
    logger.info('build start');
    final screenSize = MediaQuery.of(context).size;
    final state = bloc.state as ReporterReportState;
    final image = state.report.photo.encoded;

    return BlocListener<ReporterBloc, ReporterState>(
      listener: (context, state) {
        if (state is! ReporterReportState) return;
        final sendingErrorText = state.reportSendingErrorText;
        if (sendingErrorText.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(sendingErrorText),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            color: Colors.black,
            child: Card(
              color: Colors.white70,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Flexible(
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0),
                      child: image != null
                          ? Image.memory(image)
                          : const Placeholder(),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(8.0),
                    child: TextField(
                      key: const ValueKey<String>('ReportDetailsTextFieldKey'),
                      maxLength: Settings.noteMaxLength,
                      maxLines: Settings.noteMaxLines,
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)
                                ?.noteTextField_HintText ??
                            'Comment to photo',
                        hintStyle: Theme.of(context).textTheme.headlineSmall,
                      ),
                      onChanged: (text) =>
                          bloc.add(ReportCommentTextChanged(commentText: text)),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: screenSize.width / 3,
                          child: ElevatedButton(
                            onPressed: () =>
                                bloc.add(CancelReportButtonPressed()),
                            child: Text(
                              AppLocalizations.of(context)?.btnCancel_Label ??
                                  'Cancel',
                              style: Theme.of(context).textTheme.labelLarge,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: screenSize.width / 3,
                          child: ElevatedButton(
                            onPressed: () {
                              bloc.add(SendReportButtonPressed());
                            },
                            child: Text(
                              AppLocalizations.of(context)?.btnSend_Label ??
                                  'Send',
                              style: Theme.of(context).textTheme.labelLarge,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Visibility(
            visible: state.reportSendingInProgress,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.black54,
              child: Center(
                child: Text(
                  AppLocalizations.of(context)?.txtSending ??
                      'Sending photo...',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
