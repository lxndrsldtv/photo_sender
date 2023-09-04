import 'package:domain/domain.dart';

abstract class ReporterState {
  final bool cameraVisibility;
  final bool reportVisibility;

  ReporterState(
      {required this.reportVisibility, required this.cameraVisibility});
}

class ReporterCameraState extends ReporterState {
  bool imageProcessingInProgress = false;

  ReporterCameraState()
      : super(reportVisibility: false, cameraVisibility: true);

  @override
  String toString() =>
      '<ReporterCameraState> cameraVisibility: $cameraVisibility, '
      'reportVisibility: $reportVisibility, '
      'imageProcessingInProgress: $imageProcessingInProgress';
}

class ReporterReportState extends ReporterState {
  final Report report;
  bool reportSendingInProgress = false;
  String reportSendingErrorText = '';

  ReporterReportState({required this.report})
      : super(reportVisibility: true, cameraVisibility: false);

  @override
  String toString() =>
      '<ReporterReportState> cameraVisibility: $cameraVisibility, '
      'reportVisibility: $reportVisibility, '
      'reportSendingInProgress: $reportSendingInProgress, '
      'sendingErrorText: $reportSendingErrorText'
      'report = ${report.toString()}';
}
