//
// Copyright (c) 2020 Nathan Fiedler
//
import 'package:oxidized/oxidized.dart';
import 'package:test/test.dart';

void main() {
  group('Result', () {
    test('ok is okay', () {
      expect(Result.ok(1), isA<Ok>());
      expect(Ok(1), isA<Ok>());
    });

    test('null ok is still okay', () {
      var result = Result.ok(null);
      expect(result, isA<Ok>());
      expect(result, isNot(isA<Err>()));
    });

    test('err is not okay', () {
      expect(Result.err(Exception()), isA<Err>());
      expect(Err(Exception()), isA<Err>());
    });

    test('null err is still an error', () {
      expect(Result.err(null), isA<Err>());
      expect(Err(null), isA<Err>());
    });

    test('catching ok values', () {
      var result = Result.of(() => 2);
      expect(result, isA<Ok>());
      expect(result.unwrap(), equals(2));
    });

    test('catching exceptions', () {
      var result = Result.of(() => throw Exception());
      expect(result, isA<Err>());
    });

    test('expectations', () {
      expect(Result.ok(2).expect('foo'), equals(2));
      expect(() => Result.err(Exception()).expect('oh no'), throwsException);
      expect(() => Result.ok(2).expectErr('foo'), throwsException);
      expect(Result.err(Exception()).expectErr('oh no'), isA<Exception>());
    });

    test('equal values are equal', () {
      expect(Result.ok(2), equals(Result.ok(2)));
      expect(Result.ok(2), isNot(equals(Result.ok(3))));
      var exc = Exception();
      expect(Result.err(exc), equals(Result.err(exc)));
      // exceptions do not compare equally?
      expect(Result.err(Exception()), isNot(equals(Result.err(Exception()))));
      expect(Result.ok(2), isNot(equals(Result.err(Exception()))));
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

    test('when matching results', () {
      var called = 0;
      Result.ok(3).when(
        ok: (v) {
          expect(v, equals(3));
          called++;
        },
        err: (err) => fail('oh no'),
      );
      expect(called, equals(1));
      Result.err(Exception()).when(
        ok: (v) => fail('oh no'),
        err: (err) {
          expect(err, isNotNull);
          called++;
        },
      );
      expect(called, equals(2));
    });

    test('folding results', () {
      expect(
        Ok(2).fold(
          (v) => v * 3,
          (e) => e,
        ),
        equals(Ok(6)),
      );
      expect(
        Err(3).fold(
          (v) => v,
          (e) => e * 3,
        ),
        equals(Err(9)),
      );
    });

    test('mapping values', () {
      expect(Result.ok(5).map((v) => v * 2).unwrap(), equals(10));
      expect(Result.ok(5).mapOr((v) => v * 2, 2), equals(10));
      expect(Result.ok(5).mapOrElse((v) => v * 2, (e) => 2), equals(10));
      expect(Result.err(Exception()).map((v) => fail('oh no')), isA<Err>());
    });

    test('mapping errors', () {
      expect(Result.ok(5).mapErr((v) => fail('oh no')).unwrap(), equals(5));
      var called = 0;
      Result.err(Exception()).mapErr((e) => called++);
      expect(called, equals(1));
      expect(Result.err(Exception()).map((e) => Exception()), isA<Err>());
      expect(Result.err(Exception()).mapOr((v) => fail('oh no'), 2), equals(2));
      expect(Result.err(Exception()).mapOrElse((v) => fail('oh no'), (e) => 2),
          equals(2));
    });

    test('result as an option', () {
      expect(Result.ok(5).ok(), isA<Some>());
      expect(Result.err(Exception()).ok(), isA<None>());
      expect(Result.ok(5).err(), isA<None>());
      expect(Result.err(Exception()).err(), isA<Some>());
    });

    test('this and that', () {
      expect(Result.ok(2).and(Result.ok(1)), isA<Ok>());
      expect(Result.ok(2).and(Result.err(Exception())), isA<Err>());
      expect(Result.err(Exception()).and(Result.ok(2)), isA<Err>());
      expect(Result.ok(2).andThen((v) => Result.ok(v * 2)).unwrap(), equals(4));
      expect(Result.err(Exception()).andThen((v) => fail('oh no')), isA<Err>());
    });

    test('this or that', () {
      expect(Result.ok(2).or(Result.err(Exception())), isA<Ok>());
      expect(Result.err(Exception()).or(Result.ok(2)), isA<Ok>());
      expect(Result.ok(2).orElse((err) => fail('oh no')), isA<Ok>());
      expect(
        Result.err(Exception()).orElse((err) => Result.err(err)),
        isA<Err>(),
      );
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
