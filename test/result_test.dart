//
// Copyright (c) 2020 Nathan Fiedler
//
import 'package:oxidized/oxidized.dart';
import 'package:test/test.dart';

void main() {
  group('Result', () {
    test('ok is okay', () {
      var result = Result.ok(1);
      expect(result.isOk(), isTrue);
      expect(result.isErr(), isFalse);
      expect(result.type(), equals(ResultType.ok));
    });

    test('err is not okay', () {
      var result = Result.err(Exception());
      expect(result.isOk(), isFalse);
      expect(result.isErr(), isTrue);
      expect(result.type(), equals(ResultType.err));
    });

    test('catching ok values', () {
      var result = Result(() => 2);
      expect(result.isOk(), isTrue);
      expect(result.unwrap(), equals(2));
    });

    test('catching exceptions', () {
      var result = Result(() => throw Exception());
      expect(result.isErr(), isTrue);
    });

    test('expectations', () {
      expect(Result.ok(2).expect('foo'), equals(2));
      expect(() => Result.err(Exception()).expect('oh no'), throwsException);
      expect(() => Result.ok(2).expectErr('foo'), throwsException);
      expect(Result.err(Exception()).expectErr('oh no'), isA<Exception>());
    });

    test('matching results', () {
      var called = 0;
      Result.ok(3).match((v) {
        expect(v, equals(3));
        called++;
      }, (err) => fail('oh no'));
      expect(called, equals(1));
      Result.err(Exception()).match((v) => fail('oh no'), (err) {
        expect(err, isNotNull);
        called++;
      });
      expect(called, equals(2));
    });

    test('mapping values', () {
      expect(Result.ok(5).map((v) => v * 2).unwrap(), equals(10));
      expect(Result.ok(5).mapOr((v) => v * 2, 2), equals(10));
      expect(Result.ok(5).mapOrElse((v) => v * 2, (e) => 2), equals(10));
      expect(Result.err(Exception()).map((v) => fail('oh no')).isErr(), isTrue);
    });

    test('mapping errors', () {
      expect(Result.ok(5).mapErr((v) => fail('oh no')).unwrap(), equals(5));
      var called = 0;
      Result.err(Exception()).mapErr((e) => called++);
      expect(called, equals(1));
      expect(Result.err(Exception()).map((e) => Exception()).isErr(), isTrue);
      expect(Result.err(Exception()).mapOr((v) => fail('oh no'), 2), equals(2));
      expect(Result.err(Exception()).mapOrElse((v) => fail('oh no'), (e) => 2),
          equals(2));
    });

    test('result as an option', () {
      expect(Result.ok(5).ok().isSome(), isTrue);
      expect(Result.err(Exception()).ok().isNone(), isTrue);
      expect(Result.ok(5).err().isNone(), isTrue);
      expect(Result.err(Exception()).err().isSome(), isTrue);
    });

    test('this and that', () {
      expect(Result.ok(2).and(Result.ok(1)).isOk(), isTrue);
      expect(Result.ok(2).and(Result.err(Exception())).isErr(), isTrue);
      expect(Result.err(Exception()).and(Result.ok(2)).isErr(), isTrue);
      expect(Result.ok(2).andThen((v) => Result.ok(v * 2)).unwrap(), equals(4));
      expect(Result.err(Exception()).andThen((v) => fail('oh no')).isErr(),
          isTrue);
    });

    test('this or that', () {
      expect(Result.ok(2).or(Result.err(Exception())).isOk(), isTrue);
      expect(Result.err(Exception()).or(Result.ok(2)).isOk(), isTrue);
      expect(Result.ok(2).orElse((err) => fail('oh no')).isOk(), isTrue);
      expect(Result.err(Exception()).orElse((err) => Result.err(err)).isErr(),
          isTrue);
    });

    test('unwrapping the present', () {
      expect(() => Result.err(Exception()).unwrap(), throwsException);
      expect(Result.ok(2).unwrap(), equals(2));
      expect(Result.err(Exception()).unwrapErr(), isA<Exception>());
      expect(() => Result.ok(2).unwrapErr(), throwsException);
    });

    test('unwrapping with a default', () {
      expect(Result.err(Exception()).unwrapOr(2), equals(2));
      expect(Result.err(Exception()).unwrapOrElse((e) => 2), equals(2));
    });
  });
}
