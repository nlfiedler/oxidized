part of '../option.dart';

///
mixin OptionMatchMixin<T extends Object> {
  /// Invokes either the `someop` or the `noneop` depending on the option.
  ///
  /// This is an attempt at providing something similar to the Rust `match`
  /// expression, which makes it easy to handle both cases at once.
  ///
  /// See also [when] for another way to achieve the same behavior.
  R match<R>(R Function(T) someop, R Function() noneop);

  /// Invokes either `some` or `none` depending on the option.
  ///
  /// Identical to [match] except that the arguments are named.
  R when<R>({required R Function(T) some, required R Function() none}) {
    return match(some, none);
  }
}
