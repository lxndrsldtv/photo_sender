import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_sender/src/blocs/reporter_bloc.dart';
import 'package:photo_sender/src/blocs/reporter_events.dart';
import 'package:photo_sender/src/blocs/reporter_states.dart';

class FakeReporterBloc extends ReporterBloc {
  bool sendingResultSuccess = true;

  FakeReporterBloc() : super(ReporterCameraState()) {
    on<ImageProcessingInProgress>(_onImageProcessingInProgress);
    on<PhotoPrepared>(_onPhotoPrepared);
    on<ReportCommentTextChanged>(_onReportCommentTextChanged);
    on<SendReportButtonPressed>(_onSendReportButtonPressed);
    on<CancelReportButtonPressed>(_onCancelReportButtonPressed);
  }

  _onImageProcessingInProgress(
      ImageProcessingInProgress event, Emitter<ReporterState> emit) async {
    //print(
    //     'FakeReporterBloc: <_onImageProcessingInProgress> Received event: $event');
    //print(
    //     'FakeReporterBloc: <_onImageProcessingInProgress> Current state: $state');

    if (state is! ReporterCameraState) return;
    emit(ReporterCameraState()..imageProcessingInProgress = true);
    //print(
    //     'FakeReporterBloc: <_onImageProcessingInProgress> Emitted state: $state');
  }

  _onPhotoPrepared(PhotoPrepared event, Emitter<ReporterState> emit) async {
    // print('FakeReporterBloc: <_onPhotoPrepared> Received event: $event');
    // print('FakeReporterBloc: <_onPhotoPrepared> Current state: $state');
    //
    // print('FakeReporterBloc: <_onPhotoPrepared> '
    //     'event.reportPhoto.fileName ${event.reportPhoto.fileName}');
    // print('FakeReporterBloc: <_onPhotoPrepared> '
    //     'event.reportPhoto.bytes.length ${event.reportPhoto.bytes.length}');
    if (state is! ReporterCameraState) return;

    final report =
        Report(photo: event.reportPhoto, coordinates: Coordinates.empty());
    // print('FakeReporterBloc: <_onPhotoPrepared> report: ${report.toString()}');

    emit(ReporterCameraState()..imageProcessingInProgress = false);
    // print('FakeReporterBloc: <_onPhotoPrepared> Emitted state: $state');

    emit(ReporterReportState(report: report));
    // print('FakeReporterBloc: <_onPhotoPrepared> Emitted state: $state');
  }

  _onReportCommentTextChanged(
      ReportCommentTextChanged event, Emitter<ReporterState> emit) async {
    //print(
    //     'FakeReporterBloc: <_onReportCommentTextChanged> Received event: $event');
    //print(
    //     'FakeReporterBloc: <_onReportCommentTextChanged> Current state: $state');

    (state as ReporterReportState).report.comment = event.commentText;
    //print('FakeReporterBloc: <_onReportCommentTextChanged> New state: $state');
  }

  _onSendReportButtonPressed(
      SendReportButtonPressed event, Emitter<ReporterState> emit) async {
    // print(
    //     'FakeReporterBloc: <_onSendReportButtonPressed> Received event: $event');
    // print(
    //     'FakeReporterBloc: <_onSendReportButtonPressed> Current state: $state');

    if (state is! ReporterReportState) return;

    final report = (state as ReporterReportState).report;
    emit(ReporterReportState(report: report)..reportSendingInProgress = true);
    // print(
    //     'FakeReporterBloc: <_onSendReportButtonPressed> Emitted state: $state');
    await Future.delayed(const Duration(seconds: 3));

    if (sendingResultSuccess) {
      emit(ReporterCameraState());
    } else {
      emit(ReporterReportState(report: report)
        ..reportSendingErrorText = 'Sending failed');
    }
    // print(
    //     'FakeReporterBloc: <_onSendReportButtonPressed> Emitted state: $state');
  }

  _onCancelReportButtonPressed(
      CancelReportButtonPressed event, Emitter<ReporterState> emit) async {
    //print(
    //     'FakeReporterBloc: <_onCancelReportButtonPressed> Received event: $event');
    //print(
    //     'FakeReporterBloc: <_onCancelReportButtonPressed> Current state: $state');

    if (state is! ReporterReportState) return;

    emit(ReporterCameraState());
    //print(
    //     'FakeReporterBloc: <_onCancelReportButtonPressed> Emitted state: $state');
  }
}
