part of '../option.dart';

//// Map and filter methods for [Option]
mixin OptionMapFilterMixin<T extends Object> on OptionBase<T> {
  /// Maps an `Option<T>` to `Option<U>` by applying a function to a contained
  /// `Some` value. Otherwise returns a `None`.
  Option<U> map<U extends Object>(U Function(T) op) {
    final val = toNullable();
    if (val != null) {
      return Some(op(val));
    } else {
      return None<U>();
    }
  }

  /// Applies a function to the contained value (if any), or returns the
  /// provided default (if not).
  U mapOr<U>(U Function(T) op, U opt) {
    final val = toNullable();
    if (val != null) {
      return op(val);
    } else {
      return opt;
    }
  }

  /// Maps an `Option<T>` to `U` by applying a function to a contained `T`
  /// value, or computes a default (if not).
  U mapOrElse<U>(U Function(T) op, U Function() def) {
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
  Option<T> filter(bool Function(T) predicate) {
    final val = toNullable();
    if (val != null && predicate(val)) {
      return Some(val);
    } else {
      return None<T>();
    }
  }
}
