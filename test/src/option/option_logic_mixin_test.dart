// ignore_for_file: prefer_const_constructors

import 'package:oxidized/src/option.dart';
import 'package:test/test.dart';

void main() {
  test('this and that', () {
    expect(Option.some(2).and(Option.some(1)), isA<Some>());
    expect(Option.some(2).and(Option.none()), isA<None>());
    expect(Option.none().and(Option.some(2)), isA<None>());
    expect(
      Option.some(2).andThen((v) => Option.some(v * 2)).unwrap(),
      equals(4),
    );
    expect(Option.none().andThen((v) => fail('oh no')), isA<None>());
  });

  test('this or that', () {
    expect(Option.some(2).or(Option.none()), isA<Some>());
    expect(Option.none().or(Option.some(2)), isA<Some>());
    expect(Option.some(2).orElse(() => fail('oh no')), isA<Some>());
    expect(Option.none().orElse(Option.none), isA<None>());
    expect(Option.none().orElse(() => Option.some(1)), isA<Some>());
  });

  test('either this or that', () {
    expect(Option.some(2).xor(Option.none()), isA<Some>());
    expect(Option.none().xor(Option.some(2)), isA<Some>());
    expect(Option.none().xor(Option.none()), isA<None>());
    expect(Option.some(1).xor(Option.some(2)), isA<None>());
  });
}
