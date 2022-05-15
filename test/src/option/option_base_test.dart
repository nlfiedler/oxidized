// ignore_for_file: prefer_const_constructors

import 'package:oxidized/oxidized.dart';
import 'package:test/test.dart';

void main() {
  test('Option.isSome', () async {
    expect(Some(1).isSome(), isTrue);
    expect(None().isSome(), isFalse);
  });

  test('Option.isNone', () async {
    expect(Some(1).isNone(), isFalse);
    expect(None().isNone(), isTrue);
  });

  test('Option.toNullable', () {
    expect(Option.from(1).toNullable(), equals(1));
    expect(Option<int>.from(null).toNullable(), equals(null));
  });

  test('Option.toString', () {
    expect(Some(1).toString(), equals('Some<int>(1)'));
    expect(None<int>().toString(), equals('None<int>()'));
  });

  test('equal values are equal', () {
    expect(Option.some(2) == Option.some(2), isTrue);
    expect(Option.some(2) == Option.some(3), isFalse);
    expect(Option.none() == Option.none(), isTrue);
    expect(Option<int>.none() == Option<int>.none(), isTrue);
    expect(Option.some(2) == Option<int>.none(), isFalse);

    expect(Option.some(2) == Option<double>.some(2), isFalse);
    expect(Option<int>.none() == Option<double>.none(), isFalse);
  });
}
