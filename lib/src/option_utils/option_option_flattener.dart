part of 'option_utils.dart';

/// Flat utils on [Option<Option<T>>]
extension OptionOptionFlattener<T extends Object> on Option<Option<T>> {
  /// Flats an option of an option.
  ///
  /// ```dart
  /// Some(Some(1)) => Some(1)
  /// Some(None()) => None()
  /// None() => None()
  /// ```
  ///
  /// See also:
  /// - https://doc.rust-lang.org/std/option/enum.Option.html#method.flatten
  Option<T> flatten() {
    return match(
      (option) => option,
      None.new,
    );
  }
}

/// Flat utils on [Future<Option<Option<T>>>]
extension FutureOptionOptionFlattener<T extends Object>
    on Future<Option<Option<T>>> {
  /// Flats an option of an option.
  ///
  /// ```dart
  /// Future.value(Some(Some(1))) => Future.value(Some(1))
  /// Future.value(Some(None())) => Future.value(None())
  /// Future.value(None()) => Future.value(None())
  /// ```
  ///
  /// See also:
  /// - https://doc.rust-lang.org/std/option/enum.Option.html#method.flatten
  Future<Option<T>> flatten() => then((v) => v.flatten());
}
