import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:photo_sender/src/blocs/reporter_bloc.dart';
import 'package:photo_sender/src/blocs/reporter_states.dart';
import 'package:photo_sender/src/widgets/camera_widget.dart';
import 'package:photo_sender/src/widgets/report_details_widget.dart';

class ReporterWidget extends StatelessWidget {
  const ReporterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final logger = Logger('ReporterWidget');
    logger.info('build start');

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Photo Sender",
        ),
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
      ),
      body: SafeArea(
        child: BlocBuilder<ReporterBloc, ReporterState>(
          builder: (context, state) {
            logger.info(state);

            return state is ReporterCameraState
                ? CameraWidget(bloc: BlocProvider.of<ReporterBloc>(context))
                : ReportDetailsWidget(
                    bloc: BlocProvider.of<ReporterBloc>(context));
          },
        ),
      ),
    );
  }
}
