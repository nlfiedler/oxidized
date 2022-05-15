// ignore_for_file: prefer_const_constructors

import 'package:oxidized/oxidized.dart';
import 'package:test/test.dart';

void main() {
  test('option logic async extension ...', () async {
    test('this and that async', () async {
      expect(
        await Option.some(2)
            .andThenAsync((v) async => Option.some(v * 2))
            .then((v) => v.unwrap()),
        equals(4),
      );
      expect(
        await Option.none().andThenAsync((v) => fail('oh no')),
        isA<None>(),
      );
    });

    test('this or that async', () async {
      expect(
        await Option.some(2).orElseAsync(() => fail('oh no')),
        isA<Some>(),
      );
      expect(
        await Option.none().orElseAsync(() async => Option.none()),
        isA<None>(),
      );
      expect(
        await Option.none().orElseAsync(() async => Option.some(1)),
        isA<Some>(),
      );
    });
  });
}
