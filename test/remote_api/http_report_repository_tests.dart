import 'package:domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:photo_sender/src/repositories/command_result.dart';
import 'package:photo_sender/src/repositories/http_report_repository.dart';

void main() {
  group('HttpReportRepository tests', () {});

  test('HttpReportRepository.add sends report to server', () async {
    final report = Report(
      photo: Photo.empty(),
      comment: 'tst',
      coordinates: Coordinates.empty(),
    );

    final result = await HttpReportRepository().add(report: report);

    expect(result.code, CommandResultCode.success);
    expect(result.description, '{ "status": "Created."}');
  });
}
