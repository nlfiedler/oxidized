part of '../option.dart';

/// Collection of methods to work with [Future] on [OptionMatchMixin]
extension OptionMatchAsyncX<T extends Object> on OptionMatchMixin<T> {
  /// Asynchronously invokes either the `someop` or the `noneop` depending on
  /// the option.
  ///
  /// This is an attempt at providing something similar to the Rust `match`
  /// expression, which makes it easy to handle both cases at once.
  ///
  /// See also [when] for another way to achieve the same behavior.
  Future<R> matchAsync<R>(
    Future<R> Function(T) someop,
    Future<R> Function() noneop,
  ) =>
      match(someop, noneop);

  /// Asynchronously invokes either `some` or `none` depending on the option.
  ///
  /// Identical to [match] except that the arguments are named.
  Future<R> whenAsync<R>({
    required Future<R> Function(T) some,
    required Future<R> Function() none,
  }) =>
      match(some, none);
}
