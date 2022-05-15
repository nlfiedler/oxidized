// ignore_for_file: prefer_const_constructors

import 'package:oxidized/oxidized.dart';
import 'package:test/test.dart';

void main() {
  test('option as a result async', () async {
    expect(
      await Option.some(5).okOrElseAsync(() => fail('oh no')),
      isA<Ok>(),
    );
    expect(
      await Option.none().okOrElseAsync(() async => Exception()),
      isA<Err>(),
    );
  });
}
