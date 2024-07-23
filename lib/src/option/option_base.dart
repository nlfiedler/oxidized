part of '../option.dart';

/// [OptionBase] is the base for [Option] class.
/// It must not be used directly.
abstract class OptionBase<T> extends Equatable {
  const OptionBase._();

  @override
  bool? get stringify => true;

  /// Returns an nullable that represents this optional value.
  ///
  /// If Option has [Some] value, it will return that value.
  /// If Option has a [None] value, it will return `null`.
  T? toNullable();

  /// Returns `true` if the option is a [Some] value.
  bool isSome() => this is Some;

  /// Returns `true` if the option is a [None] value.
  bool isNone() => this is None;
}
