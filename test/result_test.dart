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
      expect(Ok(1).isOk(), isTrue);
      expect(Ok(1).isErr(), isFalse);
    });

    test('unit value is an ok unit', () {
      var result = Result.ok(unit);
      expect(result, isA<Ok>());
      expect(result, isNot(isA<Err>()));
      expect(result.unwrap(), equals(unit));
    });

    test('err is not okay', () {
      expect(Result.err(Exception()), isA<Err>());
      expect(Err(Exception()), isA<Err>());
      expect(Err(Exception()).isOk(), isFalse);
      expect(Err(Exception()).isErr(), isTrue);
    });

    test('catching ok values', () {
      var result = Result.of(() => 2);
      expect(result, isA<Ok>());
      expect(result.unwrap(), equals(2));
    });

    test('catching ok values async', () async {
      var result = await Result.asyncOf(() async => 2);
      expect(result, isA<Ok>());
      expect(result.unwrap(), equals(2));
    });

    test('catching exceptions', () {
      var result = Result.of(() => throw Exception());
      expect(result, isA<Err>());
    });

    test('catching exceptions async', () async {
      var result = await Result.asyncOf(() => throw Exception());
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
      expect(Result<int, String>.ok(2), isNot(equals(Result<int, bool>.ok(2))));
      expect(Result.ok(2), isNot(equals(Result.ok(3))));
      var exc = Exception();
      expect(Result.err(exc), equals(Result.err(exc)));
      expect(
          Err<int, Exception>(exc), isNot(equals(Err<double, Exception>(exc))));
      // exceptions do not compare equally?
      expect(Result.err(Exception()), isNot(equals(Result.err(Exception()))));
      expect(Result.ok(2), isNot(equals(Result.err(Exception()))));
    });

    test('to string', () {
      expect(Result.ok(2).toString(), equals('Ok<int, Object>(2)'));
      expect(
        Result<int, String>.ok(2).toString(),
        equals('Ok<int, String>(2)'),
      );

      expect(
        Result.err('message').toString(),
        equals('Err<Object, String>(message)'),
      );
      expect(
        Result<int, String>.err('message').toString(),
        equals('Err<int, String>(message)'),
      );
    });

    test('matching results', () {
      var called = 0;
      var returned = Result.ok(3).match((v) {
        expect(v, equals(3));
        called++;
        return 1;
      }, (err) => fail('oh no'));
      expect(returned, equals(1));
      expect(called, equals(1));
      returned = Result.err(Exception()).match((v) => fail('oh no'), (err) {
        expect(err, isNotNull);
        called++;
        return 2;
      });
      expect(returned, equals(2));
      expect(called, equals(2));
    });

    test('matching results async', () async {
      var called = 0;
      var returned = await Result.ok(3).matchAsync((v) async {
        expect(v, equals(3));
        called++;
        return 1;
      }, (err) => fail('oh no'));
      expect(returned, equals(1));
      expect(called, equals(1));
      returned = await Result.err(Exception()).matchAsync(
        (v) => fail('oh no'),
        (err) async {
          expect(err, isNotNull);
          called++;
          return 2;
        },
      );
      expect(returned, equals(2));
      expect(called, equals(2));
    });

    test('when matching results', () {
      var called = 0;
      var returned = Result.ok(3).when(
        ok: (v) {
          expect(v, equals(3));
          called++;
          return 1;
        },
        err: (err) => fail('oh no'),
      );
      expect(called, equals(1));
      expect(returned, equals(1));
      returned = Result.err(Exception()).when(
        ok: (v) => fail('oh no'),
        err: (err) {
          expect(err, isNotNull);
          called++;
          return 2;
        },
      );
      expect(returned, equals(2));
      expect(called, equals(2));
    });

    test('when matching results async', () async {
      var called = 0;
      var returned = await Result.ok(3).whenAsync(
        ok: (v) async {
          expect(v, equals(3));
          called++;
          return 1;
        },
        err: (err) => fail('oh no'),
      );
      expect(called, equals(1));
      expect(returned, equals(1));
      returned = await Result.err(Exception()).whenAsync(
        ok: (v) => fail('oh no'),
        err: (err) async {
          expect(err, isNotNull);
          called++;
          return 2;
        },
      );
      expect(returned, equals(2));
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

    test('folding results async', () async {
      expect(
        await Ok(2).foldAsync(
          (v) async => v * 3,
          (e) async => e,
        ),
        equals(Ok(6)),
      );
      expect(
        await Err(3).foldAsync(
          (v) async => v,
          (e) async => e * 3,
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

    test('mapping values', () async {
      expect(
        await Result.ok(5).mapAsync((v) async => v * 2).then((v) => v.unwrap()),
        equals(10),
      );
      expect(
        await Result.ok(5).mapOrAsync((v) async => v * 2, 2),
        equals(10),
      );
      expect(
        await Result.ok(5).mapOrElseAsync((v) async => v * 2, (e) async => 2),
        equals(10),
      );
      expect(
        await Result.err(Exception()).mapAsync((v) => fail('oh no')),
        isA<Err>(),
      );
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

    test('mapping errors async', () async {
      expect(
        await Result.ok(5)
            .mapErrAsync((v) => fail('oh no'))
            .then((v) => v.unwrap()),
        equals(5),
      );
      var called = 0;
      await Result.err(Exception()).mapErrAsync((e) async => called++);
      expect(called, equals(1));
      expect(
        await Result.err(Exception()).mapAsync((e) async => Exception()),
        isA<Err>(),
      );
      expect(
        await Result.err(Exception()).mapOrAsync((v) => fail('oh no'), 2),
        equals(2),
      );
      expect(
        await Result.err(Exception()).mapOrElseAsync(
          (v) => fail('oh no'),
          (e) async => 2,
        ),
        equals(2),
      );
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
      expect(
          Result.err(Exception()).andThen(((v) => fail('oh no'))), isA<Err>());
    });

    test('this and that async', () async {
      expect(
        await Result.ok(2)
            .andThenAsync((v) async => Result.ok(v * 2))
            .then((v) => v.unwrap()),
        equals(4),
      );
      expect(
        await Result.err(Exception()).andThenAsync(((v) => fail('oh no'))),
        isA<Err>(),
      );
    });

    test('this or that', () {
      expect(Result.ok(2).or(Result.err(Exception())), isA<Ok>());
      expect(Result.err(Exception()).or(Result.ok(2)), isA<Ok>());
      expect(Result.ok(2).orElse(((err) => fail('oh no'))), isA<Ok>());
      expect(
        Result.err(Exception()).orElse((err) => Result.err(err)),
        isA<Err>(),
      );
    });

    test('this or that', () async {
      expect(
        await Result.ok(2).orElseAsync(((err) => fail('oh no'))),
        isA<Ok>(),
      );
      expect(
        await Result.err(Exception()).orElseAsync(
          (err) async => Result.err(err),
        ),
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
      expect(Result.ok(5).unwrapOr(2), equals(5));
      expect(Result.ok(5).unwrapOrElse((e) => fail('oh no')), equals(5));
      expect(Result.err(Exception()).unwrapOr(2), equals(2));
      expect(Result.err(Exception()).unwrapOrElse((e) => 2), equals(2));
    });

    test('unwrapping with a default async', () async {
      expect(
        await Result.ok(5).unwrapOrElseAsync((e) => fail('oh no')),
        equals(5),
      );
      expect(
        await Result.err(Exception()).unwrapOrElseAsync((e) async => 2),
        equals(2),
      );
    });
  });
}
