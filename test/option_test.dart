//
// Copyright (c) 2020 Nathan Fiedler
//
// ignore_for_file: prefer_const_constructors

import 'package:oxidized/oxidized.dart';
import 'package:test/test.dart';

void main() {
  group('Option', () {
    test('some has a value', () {
      expect(Option.some(1), isA<Some>());
      expect(Some(1), isA<Some>());
    });

    test('none has nothing', () {
      expect(Option.none(), isA<None>());
      expect(None(), isA<None>());
      expect(None(), equals(None()));
      expect(None() == None(), isTrue);
    });

    test('from nullable', () {
      expect(Option.from(1).isSome(), isTrue);
      expect(Option<int>.from(null).isNone(), isTrue);
    });

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
  });
}
