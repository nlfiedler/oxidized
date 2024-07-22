part of 'option_async_utils.dart';

/// Collection of method for async map and filter in a [Option]
extension OptionMapFilterAsyncX<T> on FutureOr<Option<T>> {
  /// Maps an `Option<T>` to `Option<U>` by applying an asynchronous function
  /// to a contained `Some` value. Otherwise returns a `None`.
  Future<Option<U>> mapAsync<U>(FutureOr<U> Function(T) op) {
    return Future.value(this).then((option) {
      if (this case Some(:final some)) {
        return Future.value(op(some)).then(Some.new);
      } else {
        return None<U>();
      }
    });
  }

  /// Applies an asynchronous function to the contained value (if any), or
  /// returns the provided default (if not).
  Future<U> mapOrAsync<U>(FutureOr<U> Function(T) op, U opt) {
    return Future.value(this).then((option) {
      if (this case Some(:final some)) {
        return op(some);
      } else {
        return opt;
      }
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
      if (this case Some(:final some)) {
        return Future.value(predicate(some)).then((v) => v ? this : None<T>());
      } else {
        return const None();
      }
    });
  }
}
