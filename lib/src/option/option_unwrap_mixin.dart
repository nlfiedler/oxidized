part of '../option.dart';

/// Methods por `unwrap` or `expect` for [Option]
mixin OptionUnwrapMixin<T> on OptionBase<T> {
  /// Unwraps an option, yielding the content of a [Some].
  ///
  /// Throws an [OptionUnwrapException] if the value is a [None], with the
  /// passed message.
  T expect(String msg) {
    if (this case Some(:final some)) {
      return some;
    } else {
      throw OptionUnwrapException<T>(msg);
    }
  }

  /// Unwraps an option, yielding the content of a [Some].
  ///
  /// Throws an empty [OptionUnwrapException] if this result is a [None].
  T unwrap() {
    if (this case Some(:final some)) {
      return some;
    } else {
      throw OptionUnwrapException<T>();
    }
  }

  /// Returns the contained value or a default.
  T unwrapOr(T opt) => unwrapOrElse(() => opt);

  /// Returns the contained value or computes it from a closure.
  T unwrapOrElse(T Function() op) {
    if (this case Some(:final some)) {
      return some;
    } else {
      return op();
    }
  }
}

/// {@template oxidized.OptionUnwrapException}
/// [Exception] thrown when unwrapping an [Option] that is [None].
/// {@endtemplate}
class OptionUnwrapException<T> implements Exception {
  /// {@macro oxidized.OptionUnwrapException}
  OptionUnwrapException([String? message])
      : message = message ?? 'A None<$T>() cannot be unwrapped';

  /// The message associated with this exception.
  final String message;

  @override
  String toString() => 'OptionUnwrapException: $message';
}
