//
// Copyright (c) 2020 Nathan Fiedler
//

import 'package:equatable/equatable.dart';
import 'package:oxidized/src/option.dart';
import 'package:oxidized/src/unit.dart';

/// Result is a type that represents either success (`Ok`) or failure (`Err`).
///
/// `Result<T, E>` is the type used for returning and propagating errors. It is
/// an object with an `Ok` value, representing success and containing a value,
/// and `Err`, representing error and containing an error value.
sealed class Result<T, E extends Object> extends Equatable {
  const Result._();

  /// Create an `Ok` result with the given value.
  const factory Result.ok(T s) = Ok;

  /// Create an `Err` result with the given error.
  const factory Result.err(E err) = Err;

  /// Call the `catching` function and produce a `Result`.
  ///
  /// If the function throws an error, it will be caught and contained in the
  /// returned result. Otherwise, the result of the function will be contained
  /// as the [Ok] value.
  factory Result.of(T Function() catching) {
    try {
      return Ok(catching());
    } on E catch (e) {
      return Err(e);
    }
  }

  /// Call the `catching` function and produce a `Future<Result<T, E>>`.
  ///
  /// see also:
  /// - `Result.of`
  static Future<Result<T, E>> asyncOf<T, E extends Object>(
    Future<T> Function() catching,
  ) async {
    try {
      return Ok(await catching());
    } on E catch (e) {
      return Err(e);
    }
  }

  /// Returns `true` if the option is a [Ok] value.
  bool isOk();

  /// Returns `true` if the option is a [Err] value.
  bool isErr();

  /// Invokes either the `okop` or the `errop` depending on the result.
  ///
  /// This is an attempt at providing something similar to the Rust `match`
  /// expression, which makes it easy to get at the value or error, depending on
  /// the result.
  ///
  /// See also [when] for another way to achieve the same behavior.
  R match<R>(R Function(T) okop, R Function(E) errop);

  /// Invokes the `okop` if the result is [Ok], otherwise does nothing.
  R? matchOk<R>(R Function(T) okop);

  /// Invokes the `errop` if the result is [Err], otherwise does nothing.
  R? matchErr<R>(R Function(E) errop);

  /// Asynchronously invokes either the `okop` or the `errop` depending on
  /// the result.
  ///
  /// This is an attempt at providing something similar to the Rust `match`
  /// expression, which makes it easy to get at the value or error, depending on
  /// the result.
  ///
  /// See also [when] for another way to achieve the same behavior.
  Future<R> matchAsync<R>(
    Future<R> Function(T) okop,
    Future<R> Function(E) errop,
  );

  /// Invokes either `ok` or `err` depending on the result.
  ///
  /// Identical to [match] except that the arguments are named.
  R when<R>({required R Function(T) ok, required R Function(E) err});

  /// Asynchronously invokes either `ok` or `err` depending on the result.
  ///
  /// Identical to [match] except that the arguments are named.
  Future<R> whenAsync<R>({
    required Future<R> Function(T) ok,
    required Future<R> Function(E) err,
  });

  /// Invoke either the `ok` or the `err` function based on the result.
  ///
  /// This is a combination of the [map()] and [mapErr()] functions.
  Result<U, F> fold<U, F extends Object>(U Function(T) ok, F Function(E) err);

  /// Asynchronously invoke either the `ok` or the `err` function based on
  /// the result.
  ///
  /// This is a combination of the [map()] and [mapErr()] functions.
  Future<Result<U, F>> foldAsync<U, F extends Object>(
    Future<U> Function(T) ok,
    Future<F> Function(E) err,
  );

  /// Converts the [Result] into an [Option] containing the value, if any.
  /// Otherwise returns [None] if the result is an error.
  Option<T> ok();

  /// Converts the [Result] into an [Option] containing the error, if any.
  /// Otherwise returns [None] if the result is a value.
  Option<E> err();

  /// Unwraps a result, yielding the content of an [Ok].
  ///
  /// Throws an `Exception` if the value is an [Err], with the passed message.
  T expect(String msg);

  /// Unwraps a result, yielding the content of an [Err].
  ///
  /// Throws an `Exception` if the value is an [Ok], with the passed message.
  E expectErr(String msg);

  /// Maps a `Result<T, E>` to `Result<U, E>` by applying a function to a
  /// contained [Ok] value, leaving an [Err] value untouched.
  Result<U, E> map<U>(U Function(T) op);

  /// Maps a `Result<T, E>` to `Result<U, E>` by applying an asynchronous
  /// function to a contained [Ok] value, leaving an [Err] value untouched.
  Future<Result<U, E>> mapAsync<U>(Future<U> Function(T) op);

  /// Maps a `Result<T, E>` to `Result<T, F>` by applying a function to
  /// a contained [Err] value, leaving an [Ok] value untouched.
  ///
  /// This function can be used to pass through a successful result while
  /// handling an error.
  Result<T, F> mapErr<F extends Object>(F Function(E) op);

  /// Maps a `Result<T, E>` to `Result<T, F>` by applying a function to
  /// a contained [Err] value, leaving an [Ok] value untouched.
  ///
  /// This function can be used to pass through a successful result while
  /// handling an error.
  Future<Result<T, F>> mapErrAsync<F extends Object>(Future<F> Function(E) op);

  /// Applies a function to the contained value (if any), or returns the
  /// provided default (if not).
  U mapOr<U>(U Function(T) op, U opt);

  /// Applies an asynchronous function to the contained value (if any),
  /// or returns the provided default (if not).
  Future<U> mapOrAsync<U>(Future<U> Function(T) op, U opt);

  /// Maps a `Result<T, E>` to `U` by applying a function to a contained
  /// [Ok] value, or a fallback function to a contained [Err] value.
  U mapOrElse<U>(U Function(T) op, U Function(E) errOp);

  /// Maps a `Result<T, E>` to `U` by applying a function to a contained
  /// [Ok] value, or a fallback function to a contained [Err] value.
  Future<U> mapOrElseAsync<U>(
    Future<U> Function(T) op,
    Future<U> Function(E) errOp,
  );

  /// Returns `res` if the result is [Ok], otherwise returns `this`.
  Result<U, E> and<U>(Result<U, E> res);

  /// Calls `op` with the [Ok] value if the result is [Ok], otherwise returns
  /// `this`.
  Result<U, E> andThen<U>(Result<U, E> Function(T) op);

  /// Asynchronously calls `op` with the [Ok] value if the result is [Ok],
  /// otherwise returns `this`.
  Future<Result<U, E>> andThenAsync<U>(Future<Result<U, E>> Function(T) op);

  /// Returns `res` if the result is an [Err], otherwise returns `this`.
  Result<T, F> or<F extends Object>(Result<T, F> res);

  /// Calls `op` with the [Err] value if the result is [Err], otherwise returns
  /// `this`.
  Result<T, F> orElse<F extends Object>(Result<T, F> Function(E) op);

  /// Calls `op` with the [Err] value if the result is [Err], otherwise returns
  /// `this`.
  Future<Result<T, F>> orElseAsync<F extends Object>(
    Future<Result<T, F>> Function(E) op,
  );

  /// Unwraps a result, yielding the content of an [Ok].
  ///
  /// Throws the contained error if this result is an [Err].
  T unwrap();

  /// Unwraps a result, yielding the content of an [Ok].
  ///
  /// If the value is an [Err], returns `null` instead of throwing an exception.
  T? unwrapOrNull();

  /// Unwraps a result, yielding the content of an [Err].
  ///
  /// Throws an exception if the value is an [Ok], with a custom message
  /// provided by calling `toString()` on the [Ok]'s value.
  E unwrapErr();

  /// Unwraps a result, yielding the content of an [Ok]. Else, it returns `opt`.
  T unwrapOr(T opt);

  /// Unwraps a result, yielding the content of an [Ok]. If the value is an
  /// [Err] then it calls `op` with its value.
  T unwrapOrElse(T Function(E) op);

  /// Unwraps a result, yielding the content of an [Ok]. If the value is an
  /// [Err] then it asynchronously calls `op` with its value.
  Future<T> unwrapOrElseAsync(Future<T> Function(E) op);
}

/// An `Ok<T, E>` is a [Result] that represents the successful value.
///
/// You can create an `Ok` using either the `Ok()` constructor or the
/// `Result.ok()` factory constructor.
class Ok<T, E extends Object> extends Result<T, E> {
  /// Create an `Ok` result with the given value.
  const Ok(T s)
      : _ok = s,
        super._();

  final T _ok;

  /// Wrapped value.
  T get value => _ok;

  @override
  List<Object?> get props => [_ok];

  @override
  bool get stringify => true;

  @override
  bool isOk() => true;

  @override
  bool isErr() => false;

  @override
  R match<R>(R Function(T) okop, R Function(E) errop) => okop(_ok);

  @override
  R? matchOk<R>(R Function(T) okop) => okop(_ok);

  @override
  R? matchErr<R>(R Function(E) errop) => null;

  @override
  R when<R>({required R Function(T) ok, required R Function(E) err}) => ok(_ok);

  @override
  Result<U, F> fold<U, F extends Object>(U Function(T) ok, F Function(E) err) =>
      Ok(ok(_ok));

  @override
  Option<T> ok() => Some<T>(_ok);

  @override
  Option<E> err() => None<E>();

  @override
  T expect(String msg) => _ok;

  @override
  E expectErr(String msg) => throw ResultUnwrapException<T, E>(msg);

  @override
  Result<U, E> map<U>(U Function(T) op) => Ok(op(_ok));

  @override
  Result<T, F> mapErr<F extends Object>(F Function(E) op) => Ok(_ok);

  @override
  U mapOr<U>(U Function(T) op, U opt) => op(_ok);

  @override
  U mapOrElse<U>(U Function(T) op, U Function(E) errOp) => op(_ok);

  @override
  Result<U, E> and<U>(Result<U, E> res) => res;

  @override
  Result<U, E> andThen<U>(Result<U, E> Function(T) op) => op(_ok);

  @override
  Result<T, F> or<F extends Object>(Result<T, F> res) => Ok(_ok);

  @override
  Result<T, F> orElse<F extends Object>(Result<T, F> Function(E) op) => Ok(_ok);

  @override
  T unwrap() => _ok;

  @override
  T? unwrapOrNull() => _ok;

  @override
  E unwrapErr() => throw ResultUnwrapException<T, E>(_ok.toString());

  @override
  T unwrapOr(T opt) => _ok;

  @override
  T unwrapOrElse(T Function(E) op) => _ok;

  @override
  Future<Result<U, E>> andThenAsync<U>(Future<Result<U, E>> Function(T) op) =>
      op(_ok);

  @override
  Future<Result<U, F>> foldAsync<U, F extends Object>(
    Future<U> Function(T) ok,
    Future<F> Function(E) err,
  ) =>
      ok(_ok).then(Ok.new);

  @override
  Future<Result<U, E>> mapAsync<U>(Future<U> Function(T) op) =>
      op(_ok).then(Ok.new);

  @override
  Future<Result<T, F>> mapErrAsync<F extends Object>(
    Future<F> Function(E) op,
  ) =>
      Future.value(Ok(_ok));

  @override
  Future<U> mapOrAsync<U>(Future<U> Function(T) op, U opt) => op(_ok);

  @override
  Future<U> mapOrElseAsync<U>(
    Future<U> Function(T) op,
    Future<U> Function(E) errOp,
  ) =>
      op(_ok);

  @override
  Future<R> matchAsync<R>(
    Future<R> Function(T) okop,
    Future<R> Function(E) errop,
  ) =>
      okop(_ok);

  @override
  Future<Result<T, F>> orElseAsync<F extends Object>(
    Future<Result<T, F>> Function(E) op,
  ) =>
      Future.value(Ok(_ok));

  @override
  Future<T> unwrapOrElseAsync(Future<T> Function(E) op) => Future.value(_ok);

  @override
  Future<R> whenAsync<R>({
    required Future<R> Function(T) ok,
    required Future<R> Function(E) err,
  }) =>
      ok(_ok);

  /// Returns a new [Ok]<[Unit], E>
  static Ok<Unit, E> unit<E extends Object>() => Ok<Unit, E>(Unit.unit);
}

/// An `Err<T, E>` is a [Result] that represents a failure.
///
/// You can create an `Err` using either the `Err(E)` constructor or the
/// `Result.err(E)` factory constructor.
class Err<T, E extends Object> extends Result<T, E> {
  /// Create an `Err` result with the given error.
  const Err(E err)
      : _err = err,
        super._();

  final E _err;

  /// Wrapped error.
  E get error => _err;

  @override
  List<Object?> get props => [_err];

  @override
  bool get stringify => true;

  @override
  bool isOk() => false;

  @override
  bool isErr() => true;

  @override
  R match<R>(R Function(T) okop, R Function(E) errop) => errop(_err);

  @override
  R? matchOk<R>(R Function(T) okop) => null;

  @override
  R? matchErr<R>(R Function(E) errop) => errop(_err);

  @override
  R when<R>({required R Function(T) ok, required R Function(E) err}) =>
      err(_err);

  @override
  Result<U, F> fold<U, F extends Object>(U Function(T) ok, F Function(E) err) =>
      Err(err(_err));

  @override
  Option<T> ok() => None<T>();

  @override
  Option<E> err() => Some<E>(_err);

  @override
  T expect(String msg) {
    throw ResultUnwrapException<T, E>(msg);
  }

  @override
  E expectErr(String msg) => _err;

  @override
  Result<U, E> map<U>(U Function(T) op) => Err(_err);

  @override
  Result<T, F> mapErr<F extends Object>(F Function(E) op) => Err(op(_err));

  @override
  U mapOr<U>(U Function(T) op, U opt) => opt;

  @override
  U mapOrElse<U>(U Function(T) op, U Function(E) errOp) => errOp(_err);

  @override
  Result<U, E> and<U>(Result<U, E> res) => Err(_err);

  @override
  Result<U, E> andThen<U>(Result<U, E> Function(T) op) => Err(_err);

  @override
  Result<T, F> or<F extends Object>(Result<T, F> res) => res;

  @override
  Result<T, F> orElse<F extends Object>(Result<T, F> Function(E) op) =>
      op(_err);

  @override
  T unwrap() => throw ResultUnwrapException<T, E>(_err.toString());

  @override
  T? unwrapOrNull() => null;

  @override
  E unwrapErr() => _err;

  @override
  T unwrapOr(T opt) => opt;

  @override
  T unwrapOrElse(T Function(E) op) => op(_err);

  @override
  Future<Result<U, E>> andThenAsync<U>(Future<Result<U, E>> Function(T) op) =>
      Future.value(Err(_err));

  @override
  Future<Result<U, F>> foldAsync<U, F extends Object>(
    Future<U> Function(T) ok,
    Future<F> Function(E) err,
  ) =>
      err(_err).then(Err.new);

  @override
  Future<Result<U, E>> mapAsync<U>(Future<U> Function(T) op) =>
      Future.value(Err(_err));

  @override
  Future<Result<T, F>> mapErrAsync<F extends Object>(
    Future<F> Function(E) op,
  ) =>
      op(_err).then(Err.new);

  @override
  Future<U> mapOrAsync<U>(Future<U> Function(T) op, U opt) => Future.value(opt);

  @override
  Future<U> mapOrElseAsync<U>(
    Future<U> Function(T) op,
    Future<U> Function(E) errOp,
  ) =>
      errOp(_err);

  @override
  Future<R> matchAsync<R>(
    Future<R> Function(T) okop,
    Future<R> Function(E) errop,
  ) =>
      errop(_err);

  @override
  Future<Result<T, F>> orElseAsync<F extends Object>(
    Future<Result<T, F>> Function(E) op,
  ) =>
      op(_err);

  @override
  Future<T> unwrapOrElseAsync(Future<T> Function(E) op) => op(_err);

  @override
  Future<R> whenAsync<R>({
    required Future<R> Function(T) ok,
    required Future<R> Function(E) err,
  }) =>
      err(_err);

  /// Returns a new [Err]<[Unit], E>
  static Err<Unit, E> unit<E extends Object>(E error) => Err<Unit, E>(error);
}

/// {@template oxidized.ResultUnwrapException}
/// [Exception] thrown when unwrapping an [Option] that is [None].
/// {@endtemplate}
class ResultUnwrapException<T, E> implements Exception {
  /// {@macro oxidized.ResultUnwrapException}
  ResultUnwrapException([String? message])
      : message = message ?? 'A Result<$T, $E>() cannot be unwrapped';

  /// The message associated with this exception.
  final String message;

  @override
  String toString() {
    return 'ResultUnwrapException: $message';
  }
}
