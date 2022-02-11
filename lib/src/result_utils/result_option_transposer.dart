part of 'result_utils.dart';

extension ResultOptionTransposer<T extends Object, E extends Object>
    on Result<Option<T>, E> {
  /// Transposes the result to an option.
  ///
  /// ```dart
  /// Ok(None()) => None()
  /// Ok(Some(val)) => Some(Ok(val))
  /// Err(err) => Some(Err(err))
  /// ```
  ///
  /// See also:
  /// - https://doc.rust-lang.org/std/result/enum.Result.html#method.transpose
  Option<Result<T, E>> transpose() {
    return match(
      (option) => option.match(
        (val) => Some(Ok(val)),
        () => None(),
      ),
      (err) => Some(Err(err)),
    );
  }
}

extension FutureResultOptionTransposer<T extends Object, E extends Object>
    on Future<Result<Option<T>, E>> {
  /// Transposes the result to an option.
  ///
  /// ```dart
  /// Ok(None()) => None()
  /// Ok(Some(val)) => Some(Ok(val))
  /// Err(err) => Some(Err(err))
  /// ```
  ///
  /// See also:
  /// - https://doc.rust-lang.org/std/result/enum.Result.html#method.transpose
  Future<Option<Result<T, E>>> transpose() => then((v) => v.transpose());
}
