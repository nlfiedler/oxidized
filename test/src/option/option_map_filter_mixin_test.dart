// ignore_for_file: prefer_const_constructors

import 'package:oxidized/oxidized.dart';
import 'package:test/test.dart';

void main() {
  test('mapping values', () {
    expect(Option.some(5).map((v) => v * 2).unwrap(), equals(10));
    expect(Option.some(5).mapOr((v) => v * 2, 2), equals(10));
    expect(Option.some(5).mapOrElse((v) => v * 2, () => 2), equals(10));
    expect(Option.none().map((v) => fail('oh no')), isA<None>());
    expect(Option<int>.none().mapOr((v) => fail('oh no'), 2), equals(2));
    expect(None<int>().mapOrElse((v) => fail('oh no'), () => 2), equals(2));
  });

  test('filtering options', () {
    expect(Option.some(2).filter((v) => v.isEven), isA<Some>());
    expect(Option.some(3).filter((v) => v.isEven), isA<None>());
    expect(Option.none().filter((v) => fail('oh no')), isA<None>());
  });
}
