//
// Copyright (c) 2020 Nathan Fiedler
//
import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:oxidized/oxidized.dart';
import 'package:oxidized/src/exceptions.dart';

part 'option/option_base.dart';
part 'option/option_match_mixin.dart';
part 'option/option_match_async_extension.dart';
part 'option/option_unwrap_async_extension.dart';
part 'option/option_unwrap_mixin.dart';

/// Option is a type that represents either some value ([Some]) or none
/// ([None]).
///
/// [Option<T>] is the type used for returning an optional value. It is an
/// object with a [Some] value, and [None], representing no value.
abstract class Option<T extends Object> extends OptionBase<T>
    with OptionUnwrapMixin<T>, OptionMatchMixin<T> {
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

  /// Maps an `Option<T>` to `Option<U>` by applying a function to a contained
  /// `Some` value. Otherwise returns a `None`.
  Option<U> map<U extends Object>(U Function(T) op);

  /// Maps an `Option<T>` to `Option<U>` by applying an asynchronous function
  /// to a contained `Some` value. Otherwise returns a `None`.
  Future<Option<U>> mapAsync<U extends Object>(Future<U> Function(T) op);

  /// Applies a function to the contained value (if any), or returns the
  /// provided default (if not).
  U mapOr<U>(U Function(T) op, U opt);

  /// Applies an asynchronous function to the contained value (if any), or
  /// returns the provided default (if not).
  Future<U> mapOrAsync<U>(Future<U> Function(T) op, U opt);

  /// Maps an `Option<T>` to `U` by applying a function to a contained `T`
  /// value, or computes a default (if not).
  U mapOrElse<U>(U Function(T) op, U Function() def);

  /// Maps an `Option<T>` to `U` by applying an asynchronous function to
  /// a contained `T` value, or computes a default (if not).
  Future<U> mapOrElseAsync<U>(
    Future<U> Function(T) op,
    Future<U> Function() def,
  );

  /// Transforms the `Option<T>` into a `Result<T, E>`, mapping `Some(v)` to
  /// `Ok(v)` and `None` to `Err(err)`.
  Result<T, E> okOr<E extends Object>(E err);

  /// Transforms the `Option<T>` into a `Result<T, E>`, mapping `Some(v)` to
  /// `Ok(v)` and `None` to `Err(err())`.
  Result<T, E> okOrElse<E extends Object>(E Function() err);

  /// Transforms the `Option<T>` into a `Result<T, E>`, mapping `Some(v)` to
  /// `Ok(v)` and `None` to `Err(err())`.
  Future<Result<T, E>> okOrElseAsync<E extends Object>(
    Future<E> Function() err,
  );

  /// Returns `None` if the option is `None`, otherwise calls `predicate` with
  /// the wrapped value and returns:
  ///
  /// * `Some(t)` if predicate returns `true` (where `t` is the wrapped value)
  /// * `None` if predicate returns `false`.
  Option<T> filter(bool Function(T) predicate);

  /// Returns `None` if the option is `None`, otherwise calls `predicate` with
  /// the wrapped value and returns:
  ///
  /// * `Some(t)` if predicate returns `true` (where `t` is the wrapped value)
  /// * `None` if predicate returns `false`.
  Future<Option<T>> filterAsync(Future<bool> Function(T) predicate);

  /// Returns `None` if the option is `None`, otherwise returns `optb`.
  Option<U> and<U extends Object>(Option<U> optb);

  /// Returns `None` if the option is `None`, otherwise calls `op` with the
  /// wrapped value and returns the result.
  Option<U> andThen<U extends Object>(Option<U> Function(T) op);

  /// Returns `None` if the option is `None`, otherwise asynchronously calls
  /// `op` with the wrapped value and returns the result.
  Future<Option<U>> andThenAsync<U extends Object>(
    Future<Option<U>> Function(T) op,
  );

  /// Returns the option if it contains a value, otherwise returns `optb`.
  Option<T> or(Option<T> optb);

  /// Returns the option if it contains a value, otherwise calls `op` and
  /// returns the result.
  Option<T> orElse(Option<T> Function() op);

  /// Returns the option if it contains a value, otherwise asynchronously calls
  /// `op` and returns the result.
  Future<Option<T>> orElseAsync(Future<Option<T>> Function() op);

  /// Returns `Some` if exactly one of `this`, `optb` is `Some`, otherwise
  /// returns `None`.
  Option<T> xor(Option<T> optb);
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

  @override
  bool isSome() => true;

  @override
  bool isNone() => false;

  @override
  Option<U> map<U extends Object>(U Function(T) op) => Option.some(op(_some));

  @override
  U mapOr<U>(U Function(T) op, U opt) => op(_some);

  @override
  U mapOrElse<U>(U Function(T) op, U Function() def) => op(_some);

  @override
  Result<T, E> okOr<E extends Object>(E err) => Result.ok(_some);

  @override
  Result<T, E> okOrElse<E extends Object>(E Function() err) => Result.ok(_some);

  @override
  Option<T> filter(bool Function(T) predicate) =>
      predicate(_some) ? this : None<T>();

  @override
  Option<U> and<U extends Object>(Option<U> optb) => optb;

  @override
  Option<U> andThen<U extends Object>(Option<U> Function(T) op) => op(_some);

  @override
  Option<T> or(Option<T> optb) => this;

  @override
  Option<T> orElse(Option<T> Function() op) => this;

  @override
  Option<T> xor(Option<T> optb) => optb is None ? this : None<T>();

  @override
  Future<Option<U>> andThenAsync<U extends Object>(
    Future<Option<U>> Function(T) op,
  ) =>
      op(_some);

  @override
  Future<Option<T>> filterAsync(Future<bool> Function(T) predicate) =>
      predicate(_some).then((v) => v ? this : None<T>());

  @override
  Future<Option<U>> mapAsync<U extends Object>(
    Future<U> Function(T) op,
  ) =>
      op(_some).then((v) => Option.some(v));

  @override
  Future<U> mapOrAsync<U>(Future<U> Function(T p1) op, U opt) => op(_some);

  @override
  Future<U> mapOrElseAsync<U>(
    Future<U> Function(T) op,
    Future<U> Function() def,
  ) =>
      op(_some);

  @override
  Future<Option<T>> orElseAsync(Future<Option<T>> Function() op) {
    return Future.value(this);
  }

  @override
  Future<Result<T, E>> okOrElseAsync<E extends Object>(
    Future<E> Function() err,
  ) =>
      Future.value(Result.ok(_some));
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

  @override
  bool isSome() => false;

  @override
  bool isNone() => true;

  @override
  Option<U> map<U extends Object>(U Function(T) op) => None<U>();

  @override
  U mapOr<U>(U Function(T) op, U opt) => opt;

  @override
  U mapOrElse<U>(U Function(T) op, U Function() def) => def();

  @override
  Result<T, E> okOr<E extends Object>(E err) => Result.err(err);

  @override
  Result<T, E> okOrElse<E extends Object>(E Function() err) =>
      Result.err(err());

  @override
  Option<T> filter(bool Function(T) predicate) => None<T>();

  @override
  Option<U> and<U extends Object>(Option<U> optb) => None<U>();

  @override
  Option<U> andThen<U extends Object>(Option<U> Function(T) op) => None<U>();

  @override
  Option<T> or(Option<T> optb) => optb;

  @override
  Option<T> orElse(Option<T> Function() op) => op();

  @override
  Option<T> xor(Option<T> optb) => optb is Some ? optb : None<T>();

  @override
  Future<Option<U>> andThenAsync<U extends Object>(
    Future<Option<U>> Function(T) op,
  ) =>
      Future.value(None<U>());

  @override
  Future<Option<T>> filterAsync(Future<bool> Function(T) predicate) =>
      Future.value(None<T>());

  @override
  Future<Option<U>> mapAsync<U extends Object>(Future<U> Function(T) op) =>
      Future.value(None<U>());

  @override
  Future<U> mapOrAsync<U>(Future<U> Function(T) op, U opt) => Future.value(opt);

  @override
  Future<U> mapOrElseAsync<U>(
    Future<U> Function(T) op,
    Future<U> Function() def,
  ) =>
      def();

  @override
  Future<Option<T>> orElseAsync(Future<Option<T>> Function() op) => op();

  @override
  Future<Result<T, E>> okOrElseAsync<E extends Object>(
    Future<E> Function() err,
  ) =>
      err().then((v) => Result.err(v));
}
