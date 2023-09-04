import 'package:flutter_test/flutter_test.dart';

import 'package:domain/domain.dart';

void main() {
  group('Domain model tests', () { });
  test('Coordinates values are NaN, when created empty object', () {
    final coordinates = Coordinates.empty();
    expect(coordinates.latitude.isNaN, true);
    expect(coordinates.longitude.isNaN, true);
  });
}
