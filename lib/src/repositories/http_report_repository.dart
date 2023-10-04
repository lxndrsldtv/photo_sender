import 'package:domain/domain.dart';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import 'package:photo_sender/src/repositories/command_result.dart';
import 'package:photo_sender/src/repositories/report_repository.dart';

import '../settings.dart';

class HttpReportRepository implements ReportRepository {
  final logger = Logger('HttpReportRepository');

  // curl
  // -H "Content-Type: application/javascript"
  // -X POST https://flutter-sandbox.free.beeceptor.com/upload_photo/
  // -F comment="A photo from the phone camera."
  // -F latitude=38.897675
  // -F longitude=-77.036547
  // -F photo=@test.png
  // curl -H "Content-Type: application/javascript" -X POST https://flutter-sandbox.free.beeceptor.com/upload_photo/ -F comment="tst" -F latitude=0.0 -F longitude=0.0 -F photo=@tst.png

  Future<http.Response> _postReport(Report report) async {
    final request = http.MultipartRequest(
        'POST', Uri.parse(Settings.baseURL + Settings.uploadPhotoEndPoint))
      ..headers['Content-Type'] = Settings.contentType
      ..fields['comment'] = report.comment
      ..fields['latitude'] = report.coordinates.latitude.toString()
      ..fields['longitude'] = report.coordinates.longitude.toString()
      ..files.add(http.MultipartFile.fromBytes('photo', report.photo.bytes));

    logger.info('URL: request.url');

    request.headers.forEach((key, value) {
      logger.info('header: $key: $value');
    });

    request.fields.forEach((key, value) {
      logger.info('field: $key: $value');
    });

    return http.Response.fromStream(await request.send());
  }

  @override
  Future<CommandResult> add({required Report report}) async {
    final result = await _postReport(report);
    return CommandResult(
      code: result.statusCode == 201
          ? CommandResultCode.success
          : CommandResultCode.fail,
      description: result.body,
    );
  }
}
