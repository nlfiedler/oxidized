part of '../option.dart';

/// [OptionBase] is the base for [Option] class.
/// It must not be used directly.
abstract class OptionBase<T extends Object> extends Equatable {
  @override
  bool? get stringify => true;
}
