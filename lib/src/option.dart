//
// Copyright (c) 2020 Nathan Fiedler
//
import 'package:equatable/equatable.dart';
import './result.dart';

/// The type of the option, either `some` or `none`, useful with `switch`.
enum OptionType { some, none }

/// Option is a type that represents either some value (`Some`) or none
/// (`None`).
///
/// `Option<Some>` is the type used for returning an optional value. It is an
/// object with a `some` value, and `none`, representing no value.
class Option<Some> extends Equatable {
  final Some _some;

  /// Create a `Some` option with the given value.
  ///
  /// Passing a `null` value will result in a `None`.
  Option.some(Some v) : _some = v;

  /// Create a `None` option with no value.
  Option.none() : _some = null;

  @override
  List<Object> get props => [_some];

  @override
  bool get stringify => true;

  @override
  bool operator ==(other) => other is Option && other._some == _some;

  /// Return the type of this option, either `some` or `none`.
  OptionType type() {
    return _some != null ? OptionType.some : OptionType.none;
  }

  /// Returns `true` if the option is `Some`.
  bool get isSome => _some != null;

  /// Returns `true` if the option is `None`.
  bool get isNone => _some == null;

  /// Invokes either the `someop` or the `noneop` depending on the option.
  ///
  /// This is an attempt at providing something similar to the Rust `match`
  /// expression, which makes it easy to handle both cases at once.
  ///
  /// See also [when] for another way to achieve the same behavior.
  void match(void Function(Some) someop, void Function() noneop) {
    if (_some != null) {
      someop(_some);
    } else {
      noneop();
    }
  }

  /// Invokes either `some` or `none` depending on the option.
  ///
  /// Identical to [match] except that the arguments are named.
  void when({void Function(Some) some, void Function() none}) {
    if (_some != null) {
      some(_some);
    } else {
      none();
    }
  }

  /// Unwraps an option, yielding the content of a `Some`.
  ///
  /// Throws an `Exception` if the value is a `None`, with the passed message.
  Some expect(String msg) {
    if (_some != null) {
      return _some;
    } else {
      throw Exception(msg);
    }
  }

  /// Unwraps an option, yielding the content of a `Some`.
  ///
  /// Throws an empty exception if this result is a `None`.
  Some unwrap() {
    if (_some != null) {
      return _some;
    } else {
      throw Exception();
    }
  }

  /// Returns the contained value or a default.
  Some unwrapOr(Some opt) {
    return _some ?? opt;
  }

  /// Returns the contained value or computes it from a closure.
  Some unwrapOrElse(Some Function() op) {
    return _some ?? op();
  }

  /// Maps an `Option<Some>` to `Option<NewSome>` by applying a function to
  /// a contained `Some` value. Otherwise returns a `None`.
  Option<NewSome> map<NewSome>(NewSome Function(Some) op) {
    if (_some != null) {
      return Option.some(op(_some));
    } else {
      return Option.none();
    }
  }

  /// Applies a function to the contained value (if any), or returns the
  /// provided default (if not).
  NewSome mapOr<NewSome>(NewSome Function(Some) op, NewSome opt) {
    if (_some != null) {
      return op(_some);
    } else {
      return opt;
    }
  }

  /// Maps an `Option<Some>` to `NewSome` by applying a function to a contained
  /// `Some` value, or computes a default (if not).
  NewSome mapOrElse<NewSome>(
      NewSome Function(Some) op, NewSome Function() def) {
    if (_some != null) {
      return op(_some);
    } else {
      return def();
    }
  }

  /// Transforms the `Option<Some>` into a `Result<Some, Err>`, mapping
  /// `Some(v)` to `Ok(v)` and `None` to `Err(err)`.
  Result<Some, Err> okOr<Err>(Err err) {
    if (_some != null) {
      return Result.ok(_some);
    } else {
      return Result.err(err);
    }
  }

  /// Transforms the `Option<Some>` into a `Result<Some, Err>`, mapping
  /// `Some(v)` to `Ok(v)` and `None` to `Err(err())`.
  Result<Some, Err> okOrElse<Err>(Err Function() err) {
    if (_some != null) {
      return Result.ok(_some);
    } else {
      return Result.err(err());
    }
  }

  /// Returns `None` if the option is `None`, otherwise calls `predicate` with
  /// the wrapped value and returns:
  ///
  /// * `Some(t)` if predicate returns `true` (where `t` is the wrapped value)
  /// * `None` if predicate returns `false`.
  Option<Some> filter(bool Function(Some) predicate) {
    if (_some != null && predicate(_some)) {
      return this;
    }
    return Option.none();
  }

  /// Returns `None` if the option is `None`, otherwise returns `optb`.
  Option<Some> and(Option<Some> optb) {
    if (_some != null) {
      return optb;
    } else {
      return this;
    }
  }

  /// Returns `None` if the option is `None`, otherwise calls `op` with the
  /// wrapped value and returns the result.
  Option<Some> andThen(Option<Some> Function(Some) op) {
    if (_some != null) {
      return op(_some);
    } else {
      return this;
    }
  }

  /// Returns the option if it contains a value, otherwise returns `optb`.
  Option<Some> or(Option<Some> optb) {
    if (_some != null) {
      return this;
    } else {
      return optb;
    }
  }

  /// Returns the option if it contains a value, otherwise calls `op` and
  /// returns the result.
  Option<Some> orElse(Option<Some> Function() op) {
    if (_some != null) {
      return this;
    } else {
      return op();
    }
  }

  /// Returns `Some` if exactly one of `this`, `optb` is `Some`, otherwise
  /// returns `None`.
  Option<Some> xor(Option<Some> optb) {
    if (_some != null && optb.isNone) {
      return this;
    }
    if (_some == null && optb.isSome) {
      return optb;
    }
    return Option.none();
  }
}
