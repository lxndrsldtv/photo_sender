import 'package:domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:photo_sender/src/repositories/command_result.dart';
import 'package:photo_sender/src/repositories/report_repository_impl.dart';

void main() {
  group('ReportRepositoryImpl tests', () {});

  test('ReportRepositoryImpl.add sends report to server', () async {
    final report = Report(
      photo: Photo.empty(),
      comment: 'tst',
      coordinates: Coordinates.empty(),
    );

    final result = await ReportRepositoryImpl().add(report: report);

    expect(result.code, CommandResultCode.success);
    expect(result.description, '{ "status": "Created."}');
  });
}
