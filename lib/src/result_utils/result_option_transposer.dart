part of 'result_utils.dart';

/// Utils for transposing [Result<Option<T>, E>] into [Option<Result<T, E>>]
/// in a [Future]
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
        None.new,
      ),
      (err) => Some(Err(err)),
    );
  }
}

/// Utils for transposing [Option<Result<T, E>>] into [Result<Option<T>, E>]
/// in a [Future]
extension FutureResultOptionTransposer<T extends Object, E extends Object>
    on Future<Result<Option<T>, E>> {
  /// Transposes the result to an option.
  ///
  /// ```dart
  /// Future.value(Ok(None())) => Future.value(None())
  /// Future.value(Ok(Some(val))) => Future.value(Some(Ok(val)))
  /// Future.value(Err(err)) => Future.value(Some(Err(err)))
  /// ```
  ///
  /// See also:
  /// - https://doc.rust-lang.org/std/result/enum.Result.html#method.transpose
  Future<Option<Result<T, E>>> transpose() => then((v) => v.transpose());
}
