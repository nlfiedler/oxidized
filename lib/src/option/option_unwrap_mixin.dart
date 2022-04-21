part of '../option.dart';

/// Methods por `unwrap` or `expect` for [Option]
mixin OptionUnwrapMixin<T extends Object> on OptionBase<T> {
  /// Unwraps an option, yielding the content of a `Some`.
  ///
  /// Throws an `Exception` if the value is a `None`, with the passed message.
  T expect(String msg) => toNullable() ?? (throw Exception(msg));

  /// Unwraps an option, yielding the content of a `Some`.
  ///
  /// Throws an empty exception if this result is a `None`.
  T unwrap() => toNullable() ?? (throw OptionUnwrapException<T>());

  /// Returns the contained value or a default.
  T unwrapOr(T opt) => toNullable() ?? opt;

  /// Returns the contained value or computes it from a closure.
  T unwrapOrElse(T Function() op) => toNullable() ?? op();
}
