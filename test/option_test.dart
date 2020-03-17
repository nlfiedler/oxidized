//
// Copyright (c) 2020 Nathan Fiedler
//
import 'package:oxidized/oxidized.dart';
import 'package:test/test.dart';

void main() {
  group('Option', () {
    test('some has a value', () {
      var option = Option.some(1);
      expect(option.isSome, isTrue);
      expect(option.isNone, isFalse);
      expect(option.type(), equals(OptionType.some));
    });

    test('null some is considered none', () {
      var option = Option.some(null);
      expect(option.isSome, isFalse);
      expect(option.isNone, isTrue);
      expect(option.type(), equals(OptionType.none));
    });

    test('none has nothing', () {
      var option = Option.none();
      expect(option.isSome, isFalse);
      expect(option.isNone, isTrue);
      expect(option.type(), equals(OptionType.none));
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
      expect(Option.none().map((v) => fail('oh no')).isNone, isTrue);
    });

    test('option as a result', () {
      expect(Option.some(5).okOr(Exception()).isOk, isTrue);
      expect(Option.none().okOr(Exception()).isErr, isTrue);
      expect(Option.some(5).okOrElse(() => fail('oh no')).isOk, isTrue);
      expect(Option.none().okOrElse(() => Exception()).isErr, isTrue);
    });

    test('filtering options', () {
      expect(Option.some(2).filter((v) => v % 2 == 0).isSome, isTrue);
      expect(Option.some(3).filter((v) => v % 2 == 0).isNone, isTrue);
      expect(Option.none().filter((v) => fail('oh no')).isNone, isTrue);
    });

    test('this and that', () {
      expect(Option.some(2).and(Option.some(1)).isSome, isTrue);
      expect(Option.some(2).and(Option.none()).isNone, isTrue);
      expect(Option.none().and(Option.some(2)).isNone, isTrue);
      expect(Option.some(2).andThen((v) => Option.some(v * 2)).unwrap(),
          equals(4));
      expect(Option.none().andThen((v) => fail('oh no')).isNone, isTrue);
    });

    test('this or that', () {
      expect(Option.some(2).or(Option.none()).isSome, isTrue);
      expect(Option.none().or(Option.some(2)).isSome, isTrue);
      expect(Option.some(2).orElse(() => fail('oh no')).isSome, isTrue);
      expect(Option.none().orElse(() => Option.none()).isNone, isTrue);
      expect(Option.none().orElse(() => Option.some(1)).isSome, isTrue);
    });

    test('either this or that', () {
      expect(Option.some(2).xor(Option.none()).isSome, isTrue);
      expect(Option.none().xor(Option.some(2)).isSome, isTrue);
      expect(Option.none().xor(Option.none()).isNone, isTrue);
      expect(Option.some(1).xor(Option.some(2)).isNone, isTrue);
    });
  });
}
