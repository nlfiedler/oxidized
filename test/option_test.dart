//
// Copyright (c) 2020 Nathan Fiedler
//
import 'package:oxidized/oxidized.dart';
import 'package:test/test.dart';

void main() {
  group('Option', () {
    test('some has a value', () {
      expect(Option.some(1), isA<Some>());
      expect(Some(1), isA<Some>());
    });

    test('null some is considered none', () {
      var option = Option.some(null);
      expect(option, isA<None>());
    });

    test('none has nothing', () {
      expect(Option.none(), isA<None>());
      expect(None(), isA<None>());
    });

    test('expectations', () {
      expect(Option.some(2).expect('foo'), equals(2));
      expect(() => Option.none().expect('oh no'), throwsException);
    });

    test('equal values are equal', () {
      expect(Option.some(2) == Option.some(2), isTrue);
      expect(Option.some(2) == Option.some(3), isFalse);
      expect(Option.none() == Option.none(), isTrue);
      expect(Option.some(2) == Option.none(), isFalse);
    });

    test('unwrapping the present', () {
      expect(() => Option.none().unwrap(), throwsException);
      expect(Option.some(2).unwrap(), equals(2));
    });

    test('unwrapping with a default', () {
      expect(Option.none().unwrapOr(2), equals(2));
      expect(Option.none().unwrapOrElse(() => 2), equals(2));
    });

    test('matching options', () {
      var called = 0;
      Option.some(3).match((v) {
        expect(v, equals(3));
        called++;
      }, () => fail('oh no'));
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

    test('mapping values', () {
      expect(Option.some(5).map((v) => v * 2).unwrap(), equals(10));
      expect(Option.some(5).mapOr((v) => v * 2, 2), equals(10));
      expect(Option.some(5).mapOrElse((v) => v * 2, () => 2), equals(10));
      expect(Option.none().map((v) => fail('oh no')), isA<None>());
    });

    test('option as a result', () {
      expect(Option.some(5).okOr(Exception()), isA<Ok>());
      expect(Option.none().okOr(Exception()), isA<Err>());
      expect(Option.some(5).okOrElse(() => fail('oh no')), isA<Ok>());
      expect(Option.none().okOrElse(() => Exception()), isA<Err>());
    });

    test('filtering options', () {
      expect(Option.some(2).filter((v) => v % 2 == 0), isA<Some>());
      expect(Option.some(3).filter((v) => v % 2 == 0), isA<None>());
      expect(Option.none().filter((v) => fail('oh no')), isA<None>());
    });

    test('this and that', () {
      expect(Option.some(2).and(Option.some(1)), isA<Some>());
      expect(Option.some(2).and(Option.none()), isA<None>());
      expect(Option.none().and(Option.some(2)), isA<None>());
      expect(Option.some(2).andThen((v) => Option.some(v * 2)).unwrap(),
          equals(4));
      expect(Option.none().andThen((v) => fail('oh no')), isA<None>());
    });

    test('this or that', () {
      expect(Option.some(2).or(Option.none()), isA<Some>());
      expect(Option.none().or(Option.some(2)), isA<Some>());
      expect(Option.some(2).orElse(() => fail('oh no')), isA<Some>());
      expect(Option.none().orElse(() => Option.none()), isA<None>());
      expect(Option.none().orElse(() => Option.some(1)), isA<Some>());
    });

    test('either this or that', () {
      expect(Option.some(2).xor(Option.none()), isA<Some>());
      expect(Option.none().xor(Option.some(2)), isA<Some>());
      expect(Option.none().xor(Option.none()), isA<None>());
      expect(Option.some(1).xor(Option.some(2)), isA<None>());
    });
  });
}
