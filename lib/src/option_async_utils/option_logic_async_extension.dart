part of 'option_async_utils.dart';

/// Async method like and, or, xor
extension OptionLoginAsyncExtension<T> on FutureOr<Option<T>> {
  /// Returns `None` if the option is `None`, otherwise asynchronously calls
  /// `op` with the wrapped value and returns the result.
  Future<Option<U>> andThenAsync<U>(
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
