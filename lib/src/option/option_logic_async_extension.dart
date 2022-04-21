part of '../option.dart';

/// Async method like and, or, xor
extension OptionLoginAsyncExtension<T extends Object> on Option<T> {
  /// Transforms the `Option<T>` into a `Result<T, E>`, mapping `Some(v)` to
  /// `Ok(v)` and `None` to `Err(err())`.
  Future<Result<T, E>> okOrElseAsync<E extends Object>(
    Future<E> Function() err,
  ) {
    final val = toNullable();
    return val != null ? Future.value(Result.ok(val)) : err().then(Result.err);
  }

  /// Returns `None` if the option is `None`, otherwise asynchronously calls
  /// `op` with the wrapped value and returns the result.
  Future<Option<U>> andThenAsync<U extends Object>(
    Future<Option<U>> Function(T) op,
  ) {
    final val = toNullable();
    return val != null ? op(val) : Future.value(None<U>());
  }

  /// Returns the option if it contains a value, otherwise asynchronously calls
  /// `op` and returns the result.
  Future<Option<T>> orElseAsync(Future<Option<T>> Function() op) {
    return this is Some ? Future.value(this) : op();
  }
}
