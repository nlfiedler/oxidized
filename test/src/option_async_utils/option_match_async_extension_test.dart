// ignore_for_file: prefer_const_constructors

import 'package:oxidized/oxidized.dart';
import 'package:test/test.dart';

void main() {
  test('matching options async', () async {
    var called = 0;
    await Option.some(3).matchAsync(
      (v) async {
        expect(v, equals(3));
        called++;
      },
      () => fail('oh no'),
    );
    expect(called, equals(1));
    await Option.none().matchAsync(
      (v) => fail('oh no'),
      () async => called++,
    );
    expect(called, equals(2));
  });

  test('when matching options async', () async {
    var called = 0;
    await Option.some(3).whenAsync(
      some: (v) async {
        expect(v, equals(3));
        called++;
      },
      none: () => fail('oh no'),
    );
    expect(called, equals(1));
    await Option.none().whenAsync(
      some: (v) => fail('oh no'),
      none: () async => called++,
    );
    expect(called, equals(2));
  });
}
