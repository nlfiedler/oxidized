//
// Copyright (c) 2020 Nathan Fiedler
//
import 'package:equatable/equatable.dart';
import './result.dart';

/// Option is a type that represents either some value (`Some`) or none
/// (`None`).
///
/// `Option<T>` is the type used for returning an optional value. It is an
/// object with a `Some` value, and `None`, representing no value.
abstract class Option<T extends Object> extends Equatable {
  const Option();

  /// Create a `Some` option with the given value.
  factory Option.some(T v) => Some(v);

  /// Create a `None` option with no value.
  factory Option.none() => None();

  /// Create a option from a nullable value.
  ///
  /// Passing a non-null value will result in a `Some`.
  /// Passing a `null` value will result in a `None`.
  factory Option.from(T? v) {
    return v == null ? None() : Some(v);
  }

  /// Returns an nullable that represents this optional value.
  ///
  /// If Option has Some value, it will return that value.
  /// If Option has a None value, it will return `null`.
  T? toNullable();

  /// Returns `true` if the option is a `Some` value.
  bool isSome();

  /// Returns `true` if the option is a `None` value.
  bool isNone();

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
  R when<R>({required R Function(T) some, required R Function() none});

  /// Unwraps an option, yielding the content of a `Some`.
  ///
  /// Throws an `Exception` if the value is a `None`, with the passed message.
  T expect(String msg);

  /// Unwraps an option, yielding the content of a `Some`.
  ///
  /// Throws an empty exception if this result is a `None`.
  T unwrap();

  /// Returns the contained value or a default.
  T unwrapOr(T opt);

  /// Returns the contained value or computes it from a closure.
  T unwrapOrElse(T Function() op);

  /// Maps an `Option<T>` to `Option<U>` by applying a function to a contained
  /// `Some` value. Otherwise returns a `None`.
  Option<U> map<U extends Object>(U Function(T) op);

  /// Applies a function to the contained value (if any), or returns the
  /// provided default (if not).
  U mapOr<U>(U Function(T) op, U opt);

  /// Maps an `Option<T>` to `U` by applying a function to a contained `T`
  /// value, or computes a default (if not).
  U mapOrElse<U>(U Function(T) op, U Function() def);

  /// Transforms the `Option<T>` into a `Result<T, E>`, mapping `Some(v)` to
  /// `Ok(v)` and `None` to `Err(err)`.
  Result<T, E> okOr<E extends Object>(E err);

  /// Transforms the `Option<T>` into a `Result<T, E>`, mapping `Some(v)` to
  /// `Ok(v)` and `None` to `Err(err())`.
  Result<T, E> okOrElse<E extends Object>(E Function() err);

  /// Returns `None` if the option is `None`, otherwise calls `predicate` with
  /// the wrapped value and returns:
  ///
  /// * `Some(t)` if predicate returns `true` (where `t` is the wrapped value)
  /// * `None` if predicate returns `false`.
  Option<T> filter(bool Function(T) predicate);

  /// Returns `None` if the option is `None`, otherwise returns `optb`.
  Option<U> and<U extends Object>(Option<U> optb);

  /// Returns `None` if the option is `None`, otherwise calls `op` with the
  /// wrapped value and returns the result.
  Option<U> andThen<U extends Object>(Option<U> Function(T) op);

  /// Returns the option if it contains a value, otherwise returns `optb`.
  Option<T> or(Option<T> optb);

  /// Returns the option if it contains a value, otherwise calls `op` and
  /// returns the result.
  Option<T> orElse(Option<T> Function() op);

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
  final T _some;

  /// Create a `Some` option with the given value.
  Some(T v) : _some = v;

  @override
  List<Object?> get props => [_some];

  @override
  bool get stringify => true;

  @override
  T? toNullable() => _some;

  @override
  bool isSome() => true;

  @override
  bool isNone() => false;

  @override
  R match<R>(R Function(T) someop, R Function() noneop) => someop(_some);

  @override
  R when<R>({required R Function(T) some, required R Function() none}) =>
      some(_some);

  @override
  T expect(String msg) => _some;

  @override
  T unwrap() => _some;

  @override
  T unwrapOr(T opt) => _some;

  @override
  T unwrapOrElse(T Function() op) => _some;

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
  Option<T> filter(bool Function(T) predicate) {
    return predicate(_some) ? this : Option.none();
  }

  @override
  Option<U> and<U extends Object>(Option<U> optb) => optb;

  @override
  Option<U> andThen<U extends Object>(Option<U> Function(T) op) => op(_some);

  @override
  Option<T> or(Option<T> optb) => this;

  @override
  Option<T> orElse(Option<T> Function() op) => this;

  @override
  Option<T> xor(Option<T> optb) => optb is None ? this : Option.none();
}

/// Type `None<T>` is an `Option` that does not contain any value.
///
/// You can construct a `None` using the `None()` constructor or by calling the
/// `Option.none()` factory constructor. A `None` is also returned when a `null`
/// is passed to the `Option.some()` factory constructor.
class None<T extends Object> extends Option<T> {
  /// Create a `None` option with no value.
  const None();

  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;

  @override
  T? toNullable() => null;

  @override
  bool isSome() => false;

  @override
  bool isNone() => true;

  @override
  R match<R>(R Function(T) someop, R Function() noneop) => noneop();

  @override
  R when<R>({required R Function(T) some, required R Function() none}) =>
      none();

  @override
  T expect(String msg) {
    throw Exception(msg);
  }

  @override
  T unwrap() {
    throw Exception();
  }

  @override
  T unwrapOr(T opt) => opt;

  @override
  T unwrapOrElse(T Function() op) => op();

  @override
  Option<U> map<U extends Object>(U Function(T) op) => Option.none();

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
  Option<T> filter(bool Function(T) predicate) => Option.none();

  @override
  Option<U> and<U extends Object>(Option<U> optb) => Option.none();

  @override
  Option<U> andThen<U extends Object>(Option<U> Function(T) op) =>
      Option.none();

  @override
  Option<T> or(Option<T> optb) => optb;

  @override
  Option<T> orElse(Option<T> Function() op) => op();

  @override
  Option<T> xor(Option<T> optb) => optb is Some ? optb : Option.none();
}
