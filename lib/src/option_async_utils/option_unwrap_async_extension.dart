part of 'option_async_utils.dart';

/// Async methods related to unwrap for [Option]
extension OptionUnwrapAsyncX<T extends Object> on OptionBase<T> {
  /// Returns the contained value or asynchronously computes it from a closure.
  Future<T> unwrapOrElseAsync(Future<T> Function() op) {
    final val = toNullable();
    if (val != null) {
      return Future.value(val);
    } else {
      return op();
    }
  }
}
