part of 'option_async_utils.dart';

/// Collection of methods to work with [Future] on [OptionMatchMixin]
extension OptionMatchAsyncX<T> on FutureOr<Option<T>> {
  /// Asynchronously invokes either the `someop` or the `noneop` depending on
  /// the option.
  ///
  /// This is an attempt at providing something similar to the Rust `match`
  /// expression, which makes it easy to handle both cases at once.
  ///
  /// See also `when` for another way to achieve the same behavior.
  Future<R> matchAsync<R>(
    FutureOr<R> Function(T) someop,
    FutureOr<R> Function() noneop,
  ) =>
      Future.value(this).then((v) => v.match(someop, noneop));

  /// Asynchronously invokes either `some` or `none` depending on the option.
  ///
  /// Identical to `match` except that the arguments are named.
  Future<R> whenAsync<R>({
    required FutureOr<R> Function(T) some,
    required FutureOr<R> Function() none,
  }) =>
      matchAsync(some, none);
}
