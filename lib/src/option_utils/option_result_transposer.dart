part of 'option_utils.dart';

/// Utils for transposing [Option<Result<T, E>>] to [Result<Option<T>, E>]
extension OptionResultTransposer<T extends Object, E extends Object>
    on Option<Result<T, E>> {
  /// Transposes the result of an option.
  ///
  /// ```dart
  /// Some(Ok(1)) => Ok(Some(1));
  /// Some(Err('message')) => Err('message');
  /// None() => Ok(None());
  /// ```
  ///
  /// See also https://doc.rust-lang.org/std/option/enum.Option.html#method.transpose
  Result<Option<T>, E> transpose() {
    return match(
      (result) => result.match(
        (value) => Ok(Some(value)),
        Err.new,
      ),
      () => Ok(None<T>()),
    );
  }
}

/// Utils for transposing [Future<Option<Result<T, E>>>]
/// to [Future<Result<Option<T>, E>>]
extension FutureOptionResultTransposer<T extends Object, E extends Object>
    on Future<Option<Result<T, E>>> {
  /// Transposes the result of an option.
  ///
  /// ```dart
  /// Future.value(Some(Ok(1))) => Future.value(Ok(Some(1)));
  /// Future.value(Some(Err('message'))) => Future.value(Err('message'));
  /// Future.value(None()) => Future.value(Ok(None()));
  /// ```
  ///
  /// See also https://doc.rust-lang.org/std/option/enum.Option.html#method.transpose
  Future<Result<Option<T>, E>> transpose() {
    return then((v) => v.transpose());
  }
}
