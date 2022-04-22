part of 'option_utils.dart';

/// Collection of utils on [Future<Option<T>>]
extension OptionFutureRedirector<T extends Object> on Future<Option<T>> {
  /// Returns an nullable that represents this optional value.
  ///
  /// If Option has Some value, it will return that value.
  /// If Option has a None value, it will return `null`.
  Future<T?> toNullable() => then((v) => v.toNullable());

  /// Returns `true` if the option is a `Some` value.
  Future<bool> isSome() => then((v) => v.isSome());

  /// Returns `true` if the option is a `None` value.
  Future<bool> isNone() => then((v) => v.isNone());

  /// Invokes either the `someop` or the `noneop` depending on the option.
  ///
  /// This is an attempt at providing something similar to the Rust `match`
  /// expression, which makes it easy to handle both cases at once.
  ///
  /// See also [when] for another way to achieve the same behavior.
  Future<R> match<R>(R Function(T) someop, R Function() noneop) =>
      matchAsync(someop, noneop);

  /// Invokes either `some` or `none` depending on the option.
  ///
  /// Identical to [match] except that the arguments are named.
  Future<R> when<R>({
    required R Function(T) some,
    required R Function() none,
  }) =>
      matchAsync(some, none);

  /// Unwraps an option, yielding the content of a `Some`.
  ///
  /// Throws an `Exception` if the value is a `None`, with the passed message.
  Future<T> expect(String msg) => then((v) => v.expect(msg));

  /// Unwraps an option, yielding the content of a `Some`.
  ///
  /// Throws an empty exception if this result is a `None`.
  Future<T> unwrap() => then((v) => v.unwrap());

  /// Returns the contained value or a default.
  Future<T> unwrapOr(T opt) => then((v) => v.unwrapOr(opt));

  /// Returns the contained value or computes it from a closure.
  Future<T> unwrapOrElse(T Function() op) => then((v) => v.unwrapOrElse(op));

  /// Maps an `Option<T>` to `Option<U>` by applying a function to a contained
  /// `Some` value. Otherwise returns a `None`.
  Future<Option<U>> map<U extends Object>(U Function(T) op) => mapAsync(op);

  /// Applies a function to the contained value (if any), or returns the
  /// provided default (if not).
  Future<U> mapOr<U>(U Function(T) op, U opt) => mapOrAsync(op, opt);

  /// Maps an `Option<T>` to `U` by applying a function to a contained `T`
  /// value, or computes a default (if not).
  Future<U> mapOrElse<U>(U Function(T) op, U Function() def) =>
      mapOrElseAsync(op, def);

  /// Transforms the `Option<T>` into a `Result<T, E>`, mapping `Some(v)` to
  /// `Ok(v)` and `None` to `Err(err)`.
  Future<Result<T, E>> okOr<E extends Object>(E err) =>
      then((v) => v.okOr(err));

  /// Transforms the `Option<T>` into a `Result<T, E>`, mapping `Some(v)` to
  /// `Ok(v)` and `None` to `Err(err())`.
  Future<Result<T, E>> okOrElse<E extends Object>(E Function() err) =>
      then((v) => v.okOrElse(err));

  /// Transforms the `Option<T>` into a `Result<T, E>`, mapping `Some(v)` to
  /// `Ok(v)` and `None` to `Err(err())`.
  Future<Result<T, E>> okOrElseAsync<E extends Object>(
    Future<E> Function() err,
  ) =>
      then((v) => v.okOrElseAsync(err));

  /// Returns `None` if the option is `None`, otherwise calls `predicate` with
  /// the wrapped value and returns:
  ///
  /// * `Some(t)` if predicate returns `true` (where `t` is the wrapped value)
  /// * `None` if predicate returns `false`.
  Future<Option<T>> filter(bool Function(T) predicate) =>
      filterAsync(predicate);

  /// Returns `None` if the option is `None`, otherwise returns `optb`.
  Future<Option<U>> and<U extends Object>(Option<U> optb) =>
      then((v) => v.and(optb));

  /// Returns `None` if the option is `None`, otherwise calls `op` with the
  /// wrapped value and returns the result.
  Future<Option<U>> andThen<U extends Object>(Option<U> Function(T) op) =>
      then((v) => v.andThen(op));

  /// Returns `None` if the option is `None`, otherwise asynchronously calls
  /// `op` with the wrapped value and returns the result.
  Future<Option<U>> andThenAsync<U extends Object>(
    Future<Option<U>> Function(T) op,
  ) =>
      then((v) => v.andThenAsync(op));

  /// Returns the option if it contains a value, otherwise returns `optb`.
  Future<Option<T>> or(Option<T> optb) => then((v) => v.or(optb));

  /// Returns the option if it contains a value, otherwise calls `op` and
  /// returns the result.
  Future<Option<T>> orElse(Option<T> Function() op) =>
      then((v) => v.orElse(op));

  /// Returns the option if it contains a value, otherwise asynchronously
  /// calls `op` and returns the result.
  Future<Option<T>> orElseAsync(Future<Option<T>> Function() op) =>
      then((v) => v.orElseAsync(op));

  /// Returns `Some` if exactly one of `this`, `optb` is `Some`, otherwise
  /// returns `None`.
  Future<Option<T>> xor(Option<T> optb) => then((v) => v.xor(optb));
}
