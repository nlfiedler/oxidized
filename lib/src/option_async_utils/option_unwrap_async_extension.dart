part of 'option_async_utils.dart';

/// Async methods related to unwrap for [Option]
extension OptionUnwrapAsyncX<T extends Object> on FutureOr<Option<T>> {
  /// Returns the contained value or asynchronously computes it from a closure.
  Future<T> unwrapOrElseAsync(FutureOr<T> Function() op) {
    return matchAsync((some) => some, op);
  }
}
