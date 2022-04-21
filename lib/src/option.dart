//
// Copyright (c) 2020 Nathan Fiedler
//
import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:oxidized/oxidized.dart';

part 'option/option_base.dart';
part 'option/option_logic_async_extension.dart';
part 'option/option_logic_mixin.dart';
part 'option/option_map_filter_async_extension.dart';
part 'option/option_map_filter_mixin.dart';
part 'option/option_match_mixin.dart';
part 'option/option_match_async_extension.dart';
part 'option/option_to_result_mixin.dart';
part 'option/option_unwrap_async_extension.dart';
part 'option/option_unwrap_mixin.dart';

/// Option is a type that represents either some value ([Some]) or none
/// ([None]).
///
/// [Option<T>] is the type used for returning an optional value. It is an
/// object with a [Some] value, and [None], representing no value.
abstract class Option<T extends Object> extends OptionBase<T>
    with
        OptionUnwrapMixin<T>,
        OptionMatchMixin<T>,
        OptionMapFilterMixin<T>,
        OptionLoginMixin<T>,
        OptionToResultMixin<T> {
  /// Create a [Some] option with the given value.
  const factory Option.some(T v) = Some;

  /// Create a [None] option with no value.
  const factory Option.none() = None;

  const Option._() : super._();

  /// Create a option from a nullable value.
  ///
  /// Passing a non-null value will result in a [Some].
  /// Passing a `null` value will result in a [None].
  factory Option.from(T? v) {
    return v == null ? None<T>() : Some(v);
  }
}

/// Type `Some<T>` is an `Option` that contains a value.
///
/// You can construct a `Some` using the `Some()` constructor or by calling the
/// `Option.some()` factory constructor. The advantage of using the factory
/// constructor on `Option` is that it will yield a `None` if the passed value
/// is `null`, which can be helpful.
class Some<T extends Object> extends Option<T> {
  /// Create a `Some` option with the given value.
  const Some(T v)
      : _some = v,
        super._();

  final T _some;

  @override
  List<Object?> get props => [_some];

  @override
  T? toNullable() => _some;
}

/// Type `None<T>` is an `Option` that does not contain any value.
///
/// You can construct a `None` using the `None()` constructor or by calling the
/// `Option.none()` factory constructor. A `None` is also returned when a `null`
/// is passed to the `Option.some()` factory constructor.
class None<T extends Object> extends Option<T> {
  /// Create a `None` option with no value.
  const None() : super._();

  @override
  List<Object> get props => [];

  @override
  T? toNullable() => null;
}
