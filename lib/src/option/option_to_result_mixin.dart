part of '../option.dart';

/// Methods like and, or, xor
mixin OptionToResultMixin<T extends Object> on OptionBase<T> {
  /// Transforms the `Option<T>` into a `Result<T, E>`, mapping `Some(v)` to
  /// `Ok(v)` and `None` to `Err(err)`.
  Result<T, E> okOr<E extends Object>(E err) {
    final val = toNullable();
    return val != null ? Result.ok(val) : Result.err(err);
  }

  /// Transforms the `Option<T>` into a `Result<T, E>`, mapping `Some(v)` to
  /// `Ok(v)` and `None` to `Err(err())`.
  Result<T, E> okOrElse<E extends Object>(E Function() err) {
    final val = toNullable();
    return val != null ? Result.ok(val) : Result.err(err());
  }
}
