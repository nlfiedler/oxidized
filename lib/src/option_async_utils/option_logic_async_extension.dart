part of 'option_async_utils.dart';

/// Async method like and, or, xor
extension OptionLoginAsyncExtension<T extends Object> on FutureOr<Option<T>> {
  /// Transforms the `Option<T>` into a `Result<T, E>`, mapping `Some(v)` to
  /// `Ok(v)` and `None` to `Err(err())`.
  Future<Result<T, E>> okOrElseAsync<E extends Object>(
    FutureOr<E> Function() err,
  ) {
    return Future.value(this).then((option) {
      return option.match(
        Ok.new,
        () => Future.value(err()).then(Err.new),
      );
    });
  }

  /// Returns `None` if the option is `None`, otherwise asynchronously calls
  /// `op` with the wrapped value and returns the result.
  Future<Option<U>> andThenAsync<U extends Object>(
    FutureOr<Option<U>> Function(T) op,
  ) {
    return Future.value(this).then((option) => option.match(op, None.new));
  }

  /// Returns the option if it contains a value, otherwise asynchronously calls
  /// `op` and returns the result.
  Future<Option<T>> orElseAsync(FutureOr<Option<T>> Function() op) {
    return Future.value(this).then((option) => option.isSome() ? option : op());
  }
}
