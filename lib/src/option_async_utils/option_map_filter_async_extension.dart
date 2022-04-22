part of 'option_async_utils.dart';

/// Collection of method for async map and filter in a [Option]
extension OptionMapFilterAsyncX<T extends Object> on FutureOr<Option<T>> {
  /// Maps an `Option<T>` to `Option<U>` by applying an asynchronous function
  /// to a contained `Some` value. Otherwise returns a `None`.
  Future<Option<U>> mapAsync<U extends Object>(FutureOr<U> Function(T) op) {
    return Future.value(this).then((option) {
      final val = option.toNullable();
      if (val != null) {
        return Future.value(op(val)).then(Some.new);
      } else {
        return None<U>();
      }
    });
  }

  /// Applies an asynchronous function to the contained value (if any), or
  /// returns the provided default (if not).
  Future<U> mapOrAsync<U>(FutureOr<U> Function(T) op, U opt) {
    return Future.value(this).then((option) {
      final val = option.toNullable();
      return val != null ? op(val) : opt;
    });
  }

  /// Maps an `Option<T>` to `U` by applying an asynchronous function to
  /// a contained `T` value, or computes a default (if not).
  Future<U> mapOrElseAsync<U>(
    FutureOr<U> Function(T) op,
    FutureOr<U> Function() def,
  ) {
    return Future.value(this).then((option) => option.mapOrElse(op, def));
  }

  /// Returns `None` if the option is `None`, otherwise calls `predicate` with
  /// the wrapped value and returns:
  ///
  /// * `Some(t)` if predicate returns `true` (where `t` is the wrapped value)
  /// * `None` if predicate returns `false`.
  Future<Option<T>> filterAsync(FutureOr<bool> Function(T) predicate) {
    return Future.value(this).then((option) {
      final val = option.toNullable();
      if (val == null) return None<T>();
      return Future.value(predicate(val)).then((v) => v ? this : None<T>());
    });
  }
}
