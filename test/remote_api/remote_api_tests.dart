import 'dart:io';

import 'package:domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:photo_sender/src/remote_api.dart';

void main() {

  group('RemoteAPI tests', () {
  });

  test('RemoteApi.postReport sends report to server', () async {

    final bytes = await File('./test/remote_api/tst.png').readAsBytes();
    // print('bytes: ${bytes.length}');

    final report = Report(
        photo: Photo(fileName: 'tst.png', bytes: bytes),
        comment: 'tst',
        coordinates: Coordinates(latitude: 0.0, longitude: 0.0));

    final result = await RemoteAPI().postReport(report);

    // print(result.statusCode);
    // print(result.body);
    
    expect(result.statusCode, 201);
    expect(result.body, '{ "status": "Created."}');
  });
}
