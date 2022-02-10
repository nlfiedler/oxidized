part of 'result_utils.dart';

extension ResultFutureRedirector<T extends Object, E extends Object>
    on Future<Result<T, E>> {
  /// Returns `true` if the option is a `Ok` value.
  Future<bool> isOk() => then((result) => result.isOk());

  /// Returns `true` if the option is a `Err` value.
  Future<bool> isErr() => then((result) => result.isErr());

  /// Invokes either the `okop` or the `errop` depending on the result.
  ///
  /// This is an attempt at providing something similar to the Rust `match`
  /// expression, which makes it easy to get at the value or error, depending on
  /// the result.
  ///
  /// See also [when] for another way to achieve the same behavior.
  Future<R> match<R>(R Function(T) okop, R Function(E) errop) =>
      then((result) => result.match(okop, errop));

  /// Asynchronously invokes either the `okop` or the `errop` depending on the result.
  ///
  /// This is an attempt at providing something similar to the Rust `match`
  /// expression, which makes it easy to get at the value or error, depending on
  /// the result.
  ///
  /// See also [when] for another way to achieve the same behavior.
  Future<R> matchAsync<R>(
    Future<R> Function(T) okop,
    Future<R> Function(E) errop,
  ) =>
      then((result) => result.matchAsync(okop, errop));

  /// Invokes either `ok` or `err` depending on the result.
  ///
  /// Identical to [match] except that the arguments are named.
  Future<R> when<R>({required R Function(T) ok, required R Function(E) err}) =>
      then((result) => result.when(ok: ok, err: err));

  /// Asynchronously invokes either `ok` or `err` depending on the result.
  ///
  /// Identical to [match] except that the arguments are named.
  Future<R> whenAsync<R>({
    required Future<R> Function(T) ok,
    required Future<R> Function(E) err,
  }) =>
      then((result) => result.whenAsync(ok: ok, err: err));

  /// Invoke either the `ok` or the `err` function based on the result.
  ///
  /// This is a combination of the [map()] and [mapErr()] functions.
  Future<Result<U, F>> fold<U extends Object, F extends Object>(
    U Function(T) ok,
    F Function(E) err,
  ) =>
      then((result) => result.fold(ok, err));

  /// Asynchronously invoke either the `ok` or the `err` function based on the result.
  ///
  /// This is a combination of the [map()] and [mapErr()] functions.
  Future<Result<U, F>> foldAsync<U extends Object, F extends Object>(
    Future<U> Function(T) ok,
    Future<F> Function(E) err,
  ) =>
      then((result) => result.foldAsync(ok, err));

  /// Converts the `Result` into an `Option` containing the value, if any.
  /// Otherwise returns `None` if the result is an error.
  Future<Option<T>> ok() => then((result) => result.ok());

  /// Converts the `Result` into an `Option` containing the error, if any.
  /// Otherwise returns `None` if the result is a value.
  Future<Option<E>> err() => then((result) => result.err());

  /// Unwraps a result, yielding the content of an `Ok`.
  ///
  /// Throws an `Exception` if the value is an `Err`, with the passed message.
  Future<T> expect(String msg) => then((result) => result.expect(msg));

  /// Unwraps a result, yielding the content of an `Err`.
  ///
  /// Throws an `Exception` if the value is an `Ok`, with the passed message.
  Future<E> expectErr(String msg) => then((result) => result.expectErr(msg));

  /// Maps a `Result<T, E>` to `Result<U, E>` by applying a function to a
  /// contained `Ok` value, leaving an `Err` value untouched.
  Future<Result<U, E>> map<U extends Object>(U Function(T) op) =>
      then((result) => result.map(op));

  /// Maps a `Result<T, E>` to `Result<U, E>` by applying an asynchronous function to a
  /// contained `Ok` value, leaving an `Err` value untouched.
  Future<Result<U, E>> mapAsync<U extends Object>(Future<U> Function(T) op) =>
      then((result) => result.mapAsync(op));

  /// Maps a `Result<T, E>` to `Result<T, F>` by applying a function to
  /// a contained `Err` value, leaving an `Ok` value untouched.
  ///
  /// This function can be used to pass through a successful result while
  /// handling an error.
  Future<Result<T, F>> mapErr<F extends Object>(F Function(E) op) =>
      then((result) => result.mapErr(op));

  /// Maps a `Result<T, E>` to `Result<T, F>` by applying a function to
  /// a contained `Err` value, leaving an `Ok` value untouched.
  ///
  /// This function can be used to pass through a successful result while
  /// handling an error.
  Future<Result<T, F>> mapErrAsync<F extends Object>(
          Future<F> Function(E) op) =>
      then((result) => result.mapErrAsync(op));

  /// Applies a function to the contained value (if any), or returns the
  /// provided default (if not).
  Future<U> mapOr<U>(U Function(T) op, U opt) =>
      then((result) => result.mapOr(op, opt));

  /// Applies an asynchronous function to the contained value (if any), or returns the
  /// provided default (if not).
  Future<U> mapOrAsync<U>(Future<U> Function(T) op, U opt) =>
      then((result) => result.mapOrAsync(op, opt));

  /// Maps a `Result<T, E>` to `U` by applying a function to a contained
  /// `Ok` value, or a fallback function to a contained `Err` value.
  Future<U> mapOrElse<U>(U Function(T) op, U Function(E) errOp) =>
      then((result) => result.mapOrElse(op, errOp));

  /// Maps a `Result<T, E>` to `U` by applying a function to a contained
  /// `Ok` value, or a fallback function to a contained `Err` value.
  Future<U> mapOrElseAsync<U>(
    Future<U> Function(T) op,
    Future<U> Function(E) errOp,
  ) =>
      then((result) => result.mapOrElseAsync(op, errOp));

  /// Returns `res` if the result is `Ok`, otherwise returns `this`.
  Future<Result<U, E>> and<U extends Object>(Result<U, E> res) =>
      then((result) => result.and(res));

  /// Calls `op` with the `Ok` value if the result is `Ok`, otherwise returns
  /// `this`.
  Future<Result<U, E>> andThen<U extends Object>(Result<U, E> Function(T) op) =>
      then((result) => result.andThen(op));

  /// Asynchronously calls `op` with the `Ok` value if the result is `Ok`, otherwise returns
  /// `this`.
  Future<Result<U, E>> andThenAsync<U extends Object>(
    Future<Result<U, E>> Function(T) op,
  ) =>
      then((result) => result.andThenAsync(op));

  /// Returns `res` if the result is an `Err`, otherwise returns `this`.
  Future<Result<T, F>> or<F extends Object>(Result<T, F> res) =>
      then((result) => result.or(res));

  /// Calls `op` with the `Err` value if the result is `Err`, otherwise returns
  /// `this`.
  Future<Result<T, F>> orElse<F extends Object>(Result<T, F> Function(E) op) =>
      then((result) => result.orElse(op));

  /// Calls `op` with the `Err` value if the result is `Err`, otherwise returns
  /// `this`.
  Future<Result<T, F>> orElseAsync<F extends Object>(
    Future<Result<T, F>> Function(E) op,
  ) =>
      then((result) => result.orElseAsync(op));

  /// Unwraps a result, yielding the content of an `Ok`.
  ///
  /// Throws the contained error if this result is an `Err`.
  Future<T> unwrap() => then((result) => result.unwrap());

  /// Unwraps a result, yielding the content of an `Err`.
  ///
  /// Throws an exception if the value is an `Ok`, with a custom message
  /// provided by calling `toString()` on the `Ok`'s value.
  Future<E> unwrapErr() => then((result) => result.unwrapErr());

  /// Unwraps a result, yielding the content of an `Ok`. Else, it returns `opt`.
  Future<T> unwrapOr(T opt) => then((result) => result.unwrapOr(opt));

  /// Unwraps a result, yielding the content of an `Ok`. If the value is an
  /// `Err` then it calls `op` with its value.
  Future<T> unwrapOrElse(T Function(E) op) =>
      then((result) => result.unwrapOrElse(op));

  /// Unwraps a result, yielding the content of an `Ok`. If the value is an
  /// `Err` then it asynchronously calls `op` with its value.
  Future<T> unwrapOrElseAsync(Future<T> Function(E) op) =>
      then((result) => result.unwrapOrElseAsync(op));
}
