part of '../option.dart';

//// Map and filter methods for [Option]
mixin OptionMapFilterMixin<T> on OptionBase<T> {
  /// Maps an `Option<T>` to `Option<U>` by applying a function to a contained
  /// `Some` value. Otherwise returns a `None`.
  Option<U> map<U>(U Function(T) op) {
    if (this case Some(:final some)) {
      return Some(op(some));
    } else {
      return None<U>();
    }
  }

  /// Applies a function to the contained value (if any), or returns the
  /// provided default (if not).
  U mapOr<U>(U Function(T) op, U opt) {
    if (this case Some(:final some)) {
      return op(some);
    } else {
      return opt;
    }
  }

  /// Maps an `Option<T>` to `U` by applying a function to a contained `T`
  /// value, or computes a default (if not).
  U mapOrElse<U>(U Function(T) op, U Function() def) {
    if (this case Some(:final some)) {
      return op(some);
    } else {
      return def();
    }
  }

  /// Returns `None` if the option is `None`, otherwise calls `predicate` with
  /// the wrapped value and returns:
  ///
  /// * `Some(t)` if predicate returns `true` (where `t` is the wrapped value)
  /// * `None` if predicate returns `false`.
  Option<T> filter(bool Function(T) predicate) {
    if (this case Some(:final some)) {
      if (predicate(some)) {
        return Some(some);
      }
    }
    return None<T>();
  }
}
