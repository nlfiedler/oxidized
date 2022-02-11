part of 'option_utils.dart';

extension OptionResultTransposer<T extends Object, E extends Object>
    on Option<Result<T, E>> {
  /// Transposes the result of an option.
  ///
  /// ```dart
  /// Some(Ok(1)) => Ok(Some(1));
  /// Some(Err('error message')) => Err('error message');
  /// None() => Ok(None());
  /// ```
  ///
  /// See also https://doc.rust-lang.org/std/option/enum.Option.html#method.transpose
  Result<Option<T>, E> transpose() {
    return match(
      (result) => result.match(
        (value) => Ok(Some(value)),
        (err) => Err(err),
      ),
      () => Ok(None()),
    );
  }
}

extension FutureOptionResultTransposer<T extends Object, E extends Object>
    on Future<Option<Result<T, E>>> {
  /// Transposes the result of an option.
  ///
  /// ```dart
  /// Some(Ok(1)) => Ok(Some(1));
  /// Some(Err('error message')) => Err('error message');
  /// None() => Ok(None());
  /// ```
  ///
  /// See also https://doc.rust-lang.org/std/option/enum.Option.html#method.transpose
  Future<Result<Option<T>, E>> transpose() {
    return then((v) => v.transpose());
  }
}
