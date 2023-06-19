// ignore_for_file: prefer_const_constructors

import 'package:oxidized/oxidized.dart';
import 'package:test/test.dart';

final throwsAnOptionUnwrapException =
    throwsA(isA<OptionUnwrapException<int>>());

void main() {
  test('expectations', () {
    expect(Option.some(2).expect('foo'), equals(2));
    expect(() => Option.none().expect('oh no'), throwsAnOptionUnwrapException);
  });

  test('unwrapping the present', () {
    expect(() => Option.none().unwrap(), throwsAnOptionUnwrapException);
    expect(Option.some(2).unwrap(), equals(2));
  });

  test('unwrapping with a default', () {
    expect(Option.some(5).unwrapOr(2), equals(5));
    expect(Option.some(5).unwrapOrElse(() => 2), equals(5));

    expect(Option.none().unwrapOr(2), equals(2));
    expect(Option.none().unwrapOrElse(() => 2), equals(2));
  });

  group('OptionUnwrapException', () {
    test('toString', () {
      expect(
        OptionUnwrapException<int>().toString().contains('None<int>'),
        isTrue,
      );

      expect(
        OptionUnwrapException<int>('oh no').toString().contains('oh no'),
        isTrue,
      );
    });
  });
}
