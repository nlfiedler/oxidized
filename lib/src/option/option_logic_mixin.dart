part of '../option.dart';

/// Methods like and, or, xor
mixin OptionLogicMixin<T extends Object> on OptionBase<T> {
  /// Returns [None] if the option is [None], otherwise returns `optb`.
  Option<U> and<U extends Object>(Option<U> optb) {
    return isSome() ? optb : None<U>();
  }

  /// Returns `None` if the option is `None`, otherwise calls `op` with the
  /// wrapped value and returns the result.
  Option<U> andThen<U extends Object>(Option<U> Function(T) op) {
    final val = toNullable();
    return val != null ? op(val) : None<U>();
  }

  /// Returns the option if it contains a value, otherwise returns `optb`.
  Option<T> or(Option<T> optb) {
    return isSome() ? this as Some<T> : optb;
  }

  /// Returns the option if it contains a value, otherwise calls `op` and
  /// returns the result.
  Option<T> orElse(Option<T> Function() op) {
    return isSome() ? this as Some<T> : op();
  }

  /// Returns `Some` if exactly one of `this`, `optb` is `Some`, otherwise
  /// returns `None`.
  Option<T> xor(Option<T> optb) {
    if (this is None) return optb;
    if (optb is None) return this as Option<T>;
    return None<T>();
  }
}
