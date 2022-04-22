part of 'option_async_utils.dart';

/// Async method like okOrElse
extension OptionToResultAsyncExtension<T extends Object>
    on FutureOr<Option<T>> {
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
}
