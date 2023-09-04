import 'package:domain/domain.dart';

abstract class ReporterEvent {}

class ImageProcessingInProgress extends ReporterEvent {}

class PhotoPrepared extends ReporterEvent {
  final Photo reportPhoto;

  PhotoPrepared({required this.reportPhoto});
}

class ReportCommentTextChanged extends ReporterEvent {
  final String commentText;

  ReportCommentTextChanged({required this.commentText});
}

class SendReportButtonPressed extends ReporterEvent {}

class CancelReportButtonPressed extends ReporterEvent {}
