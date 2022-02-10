part of 'option_utils.dart';

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
      () => None(),
    );
  }
}

extension FutureOptionOptionFlattener<T extends Object>
    on Future<Option<Option<T>>> {
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
  Future<Option<T>> flatten() => then((v) => v.flatten());
}
