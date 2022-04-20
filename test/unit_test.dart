// ignore_for_file: prefer_const_constructors

import 'package:oxidized/oxidized.dart';
import 'package:test/test.dart';

void main() {
  test('basic behaviour', () {
    expect(unit, isA<Unit>());
    expect(unit.toString(), equals('()'));
    expect(unit, equals(unit));
    expect(unit, isNot(equals(2)));
  });

  test('Result<Unit, T> behaviour', () {
    expect(Ok(unit).toString(), equals('Ok<Unit, Object>(())'));
    expect(Ok<Unit, String>(unit).toString(), equals('Ok<Unit, String>(())'));

    expect(Ok(unit), equals(Ok(unit)));
    expect(Ok<Unit, String>(unit), isNot(equals(Ok<Unit, bool>(unit))));
  });
}
