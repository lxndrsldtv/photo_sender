import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';

import './reporter_events.dart';
import './reporter_states.dart';
import '../remote_api.dart';
import '../services/location_service.dart';

class ReporterBloc extends Bloc<ReporterEvent, ReporterState> {
  final logger = Logger('ReporterBloc');

  // final _location = Location();
  final LocationService _location;

  ReporterBloc({required location})
      : _location = location,
        super(ReporterCameraState()) {
    on<ImageProcessingInProgress>(_onImageProcessingInProgress);
    on<PhotoPrepared>(_onPhotoPrepared);
    on<ReportCommentTextChanged>(_onReportCommentTextChanged);
    on<SendReportButtonPressed>(_onSendReportButtonPressed);
    on<CancelReportButtonPressed>(_onCancelReportButtonPressed);
  }

  _onImageProcessingInProgress(
      ImageProcessingInProgress event, Emitter<ReporterState> emit) async {
    logger.info('<_onImageProcessingInProgress> Received event: $event');
    logger.info('<_onImageProcessingInProgress> Current state: $state');

    if (state is! ReporterCameraState) return;
    emit(ReporterCameraState()..imageProcessingInProgress = true);
    logger.info('<_onImageProcessingInProgress> Emitted state: $state');
  }

  _onPhotoPrepared(PhotoPrepared event, Emitter<ReporterState> emit) async {
    logger.info('<_onPhotoPrepared> Received event: $event');
    logger.info('<_onPhotoPrepared> Current state: $state');

    logger.info(
        '<_onPhotoPrepared> event.reportPhoto.fileName ${event.reportPhoto.fileName}');
    logger.info(
        '<_onPhotoPrepared> event.reportPhoto.bytes.length ${event.reportPhoto.bytes.length}');
    if (state is! ReporterCameraState) return;

    final report = Report(
        photo: event.reportPhoto, coordinates: await _location.coordinates);
    logger.info('report: ${report.toString()}');

    emit(ReporterCameraState()..imageProcessingInProgress = false);
    logger.info('<_onPhotoPrepared> Emitted state: $state');

    emit(ReporterReportState(report: report));
    logger.info('<_onPhotoPrepared> Emitted state: $state');
  }

  _onReportCommentTextChanged(
      ReportCommentTextChanged event, Emitter<ReporterState> emit) async {
    logger.info('<_onReportCommentTextChanged> Received event: $event');
    logger.info('<_onReportCommentTextChanged> Current state: $state');

    (state as ReporterReportState).report.comment = event.commentText;
    // logger.info('<_onReportCommentTextChanged> Emitted state: $state');
  }

  _onSendReportButtonPressed(
      SendReportButtonPressed event, Emitter<ReporterState> emit) async {
    logger.info('<_onSendReportButtonPressed> Received event: $event');
    logger.info('<_onSendReportButtonPressed> Current state: $state');

    if (state is! ReporterReportState) return;

    final report = (state as ReporterReportState).report;
    emit(ReporterReportState(report: report)..reportSendingInProgress = true);
    await Future.delayed(const Duration(seconds: 3));
    logger.info('<_onSendReportButtonPressed> Emitted state: $state');

    final response = await RemoteAPI().postReport(report);
    final responseStatusCode = response.statusCode;
    logger.info(
        '<_onSendReportButtonPressed> response.statusCode: $responseStatusCode');

    final sendingIsNotSuccess = responseStatusCode != 201;
    if (sendingIsNotSuccess) {
      emit(ReporterReportState(report: report)
        ..reportSendingErrorText = response.body);
    } else {
      emit(ReporterCameraState());
    }
    logger.info('<_onSendReportButtonPressed> Emitted state: $state');
  }

  _onCancelReportButtonPressed(
      CancelReportButtonPressed event, Emitter<ReporterState> emit) async {
    logger.info('<_onCancelReportButtonPressed> Received event: $event');
    logger.info('<_onCancelReportButtonPressed> Current state: $state');

    if (state is! ReporterReportState) return;

    emit(ReporterCameraState());
    logger.info('<_onCancelReportButtonPressed> Emitted state: $state');
  }
}
