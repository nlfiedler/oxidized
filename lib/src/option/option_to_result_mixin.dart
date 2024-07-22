part of '../option.dart';

///
mixin OptionToResultMixin<T> on OptionBase<T> {
  /// Transforms the `Option<T>` into a `Result<T, E>`, mapping `Some(v)` to
  /// `Ok(v)` and `None` to `Err(err)`.
  Result<T, E> okOr<E extends Object>(E err) {
    if (this case Some(:final some)) {
      return Result.ok(some);
    } else {
      return Result.err(err);
    }
  }

  /// Transforms the `Option<T>` into a `Result<T, E>`, mapping `Some(v)` to
  /// `Ok(v)` and `None` to `Err(err())`.
  Result<T, E> okOrElse<E extends Object>(E Function() err) {
    if (this case Some(:final some)) {
      return Result.ok(some);
    } else {
      return Result.err(err());
    }
  }
}
