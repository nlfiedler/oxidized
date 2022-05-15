// ignore_for_file: prefer_const_constructors

import 'package:oxidized/oxidized.dart';
import 'package:test/test.dart';

void main() {
  test('unwrapping with a default async', () async {
    expect(
      await Option.some(5).unwrapOrElseAsync(() async => 2),
      equals(5),
    );
    expect(
      await Option.none().unwrapOrElseAsync(() async => 2),
      equals(2),
    );
  });
}
