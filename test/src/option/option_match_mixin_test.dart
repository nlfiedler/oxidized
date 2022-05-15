// ignore_for_file: prefer_const_constructors

import 'package:oxidized/oxidized.dart';
import 'package:test/test.dart';

void main() {
  test('matching options', () {
    var called = 0;
    Option.some(3).match(
      (v) {
        expect(v, equals(3));
        called++;
      },
      () => fail('oh no'),
    );
    expect(called, equals(1));
    Option.none().match((v) => fail('oh no'), () => called++);
    expect(called, equals(2));
  });

  test('when matching options', () {
    var called = 0;
    Option.some(3).when(
      some: (v) {
        expect(v, equals(3));
        called++;
      },
      none: () => fail('oh no'),
    );
    expect(called, equals(1));
    Option.none().when(
      some: (v) => fail('oh no'),
      none: () => called++,
    );
    expect(called, equals(2));
  });
}
