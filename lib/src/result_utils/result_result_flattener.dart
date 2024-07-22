part of 'result_utils.dart';

/// Utils for flatting [Result<Result<T, E>>]
extension ResultResultFlattener<T, E extends Object>
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
      (result) => result.match(Ok.new, Err.new),
      Err.new,
    );
  }
}

/// Utils for flatting [Result<Result<T, E>>] in a [Future]
extension FutureResultResultFlattener<T, E extends Object>
    on Future<Result<Result<T, E>, E>> {
  /// Flattens a [Result<Result<T, E>, E>] into a [Result<T, E>]
  ///
  /// ```dart
  /// Future.valueOk(Ok(value))) => Future.value(Ok(value))
  /// Future.valueOk(Err(error))) => Future.value(Err(error))
  /// Future.valueErr(error)) => Future.value(Err(error))
  /// ```
  ///
  /// See also:
  /// - https://doc.rust-lang.org/std/result/enum.Result.html#method.flatten
  Future<Result<T, E>> flatten() => then((v) => v.flatten());
}
