// ignore_for_file: prefer_const_constructors

import 'package:oxidized/oxidized.dart';
import 'package:test/test.dart';

void main() {
  test('option as a result', () {
    expect(Option.some(5).okOr(Exception()), isA<Ok>());
    expect(Option.some(null).okOr(Exception()), isA<Ok>());
    expect(Option.none().okOr(Exception()), isA<Err>());

    expect(Option.some(5).okOrElse(() => fail('oh no')), isA<Ok>());
    expect(Option.some(null).okOrElse(() => fail('oh no')), isA<Ok>());
    expect(Option.none().okOrElse(Exception.new), isA<Err>());
  });
}
