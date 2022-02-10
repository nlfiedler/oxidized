part of 'result_utils.dart';

extension ResultResultFlattener<T extends Object, E extends Object>
    on Result<Result<T, E>, E> {
  /// Flattens a [Result<Result<T, E>, E>] into a [Result<T, E>]
  ///
  /// ```dart
  /// Ok(Ok(value)) => Ok(value)
  /// Ok(Err(error)) => Err(error)
  /// Err(error) => Err(error)
  /// ```
  ///
  /// See also:
  /// - https://doc.rust-lang.org/std/result/enum.Result.html#method.flatten
  Result<T, E> flatten() {
    return match(
      (result) => result.match(
        (val) => Ok(val),
        (err) => Err(err),
      ),
      (err) => Err(err),
    );
  }
}

extension FutureResultResultFlattener<T extends Object, E extends Object>
    on Future<Result<Result<T, E>, E>> {
  /// Flattens a [Result<Result<T, E>, E>] into a [Result<T, E>]
  ///
  /// ```dart
  /// Ok(Ok(value)) => Ok(value)
  /// Ok(Err(error)) => Err(error)
  /// Err(error) => Err(error)
  /// ```
  ///
  /// See also:
  /// - https://doc.rust-lang.org/std/result/enum.Result.html#method.flatten
  Future<Result<T, E>> flatten() => then((v) => v.flatten());
}
