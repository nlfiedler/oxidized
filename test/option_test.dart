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

    test('expectations', () {
      expect(Option.some(2).expect('foo'), equals(2));
      expect(() => Option.none().expect('oh no'), throwsException);
    });

    test('unwrapping the present', () {
      expect(() => Option.none().unwrap(), throwsException);
      expect(Option.some(2).unwrap(), equals(2));
    });

    test('unwrapping with a default', () {
      expect(Option.some(5).unwrapOr(2), equals(5));
      expect(Option.some(5).unwrapOrElse(() => 2), equals(5));

      expect(Option.none().unwrapOr(2), equals(2));
      expect(Option.none().unwrapOrElse(() => 2), equals(2));
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

    test('mapping values async', () async {
      expect(
        await Option.some(5)
            .mapAsync((v) async => v * 2)
            .then((v) => v.unwrap()),
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

    test('option as a result', () {
      expect(Option.some(5).okOr(Exception()), isA<Ok>());
      expect(Option.none().okOr(Exception()), isA<Err>());
      expect(Option.some(5).okOrElse(() => fail('oh no')), isA<Ok>());
      expect(Option.none().okOrElse(Exception.new), isA<Err>());
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

    test('this and that', () async {
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
