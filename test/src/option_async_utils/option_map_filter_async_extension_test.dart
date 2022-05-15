// ignore_for_file: prefer_const_constructors

import 'package:oxidized/oxidized.dart';
import 'package:test/test.dart';

void main() {
  test('mapping values async', () async {
    expect(
      await Option.some(5).mapAsync((v) async => v * 2).then((v) => v.unwrap()),
      equals(10),
    );
    expect(
      await Option.some(5).mapOrAsync((v) async => v * 2, 2),
      equals(10),
    );
    expect(
      await Option.some(5)
          .mapOrElseAsync((v) async => v * 2, () => Future.value(2)),
      equals(10),
    );
    expect(
      await Option.none().mapAsync((v) => fail('oh no')),
      isA<None>(),
    );
    expect(
      await Option<int>.none().mapOrAsync((v) => fail('oh no'), 2),
      equals(2),
    );
    expect(
      await None<int>().mapOrElseAsync((v) => fail('oh no'), () async => 2),
      equals(2),
    );
  });

  test('filtering options async', () async {
    expect(
      await Option.some(2).filterAsync((v) async => v.isEven),
      isA<Some>(),
    );
    expect(
      await Option.some(3).filterAsync((v) async => v.isEven),
      isA<None>(),
    );
    expect(
      await Option.none().filterAsync((v) => fail('oh no')),
      isA<None>(),
    );
  });
}
