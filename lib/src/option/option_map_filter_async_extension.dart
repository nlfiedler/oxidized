part of '../option.dart';

/// Collection of method for async map and filter in a [Option]
extension OptionMapFilterAsyncX<T extends Object> on Option<T> {
  /// Maps an `Option<T>` to `Option<U>` by applying an asynchronous function
  /// to a contained `Some` value. Otherwise returns a `None`.
  Future<Option<U>> mapAsync<U extends Object>(Future<U> Function(T) op) {
    final val = toNullable();
    if (val != null) {
      return op(val).then((v) => Some(v));
    } else {
      return Future.value(None<U>());
    }
  }

  /// Applies an asynchronous function to the contained value (if any), or
  /// returns the provided default (if not).
  Future<U> mapOrAsync<U>(Future<U> Function(T) op, U opt) {
    final val = toNullable();
    if (val != null) {
      return op(val);
    } else {
      return Future.value(opt);
    }
  }

  /// Maps an `Option<T>` to `U` by applying an asynchronous function to
  /// a contained `T` value, or computes a default (if not).
  Future<U> mapOrElseAsync<U>(
    Future<U> Function(T) op,
    Future<U> Function() def,
  ) {
    final val = toNullable();
    if (val != null) {
      return op(val);
    } else {
      return def();
    }
  }

  /// Returns `None` if the option is `None`, otherwise calls `predicate` with
  /// the wrapped value and returns:
  ///
  /// * `Some(t)` if predicate returns `true` (where `t` is the wrapped value)
  /// * `None` if predicate returns `false`.
  Future<Option<T>> filterAsync(Future<bool> Function(T) predicate) {
    final val = toNullable();
    if (val == null) return Future.value(None<T>());
    return predicate(val).then((v) => v ? this : None<T>());
  }
}
