//
// Copyright (c) 2020 Nathan Fiedler
//

/// The type of the result, either `ok` or `err`, useful with `switch`.
enum ResultType { ok, err }

/// Result is a type that represents either success (`Ok`) or failure (`Err`).
///
/// `Result<Ok, Err>` is the type used for returning and propagating errors. It
/// is an object with an `ok` value, representing success and containing a
/// value, and `err`, representing error and containing an error value.
class Result<Ok, Err> {
  Ok _ok;
  Err _err;

  /// Create an `Ok` result with the given value.
  Result.ok(Ok s) : assert(s != null) {
    _ok = s;
  }

  /// Create an `Err` result with the given error.
  Result.err(Err f) : assert(f != null) {
    _err = f;
  }

  /// Call the `catching` function and produce a `Result`.
  ///
  /// If the function throws an error, it will be caught and contained in the
  /// returned result. Otherwise, the result of the function will be contained
  /// as the `Ok` value.
  Result(Ok Function() catching) {
    try {
      _ok = catching();
    } catch (e) {
      _err = e;
    }
  }

  /// Return the type of this result, either `ok` or `err`.
  ResultType type() {
    return _ok != null ? ResultType.ok : ResultType.err;
  }

  /// Returns `true` if the result is `Ok`.
  bool isOk() {
    return _ok != null;
  }

  /// Returns `true` if the result is `Err`.
  bool isErr() {
    return _err != null;
  }

  /// Unwraps a result, yielding the content of an `Ok`.
  ///
  /// Throws an `Exception` if the value is an `Err`, with the passed message.
  Ok expect(String msg) {
    if (_ok != null) {
      return _ok;
    } else {
      throw Exception(msg);
    }
  }

  /// Unwraps a result, yielding the content of an `Err`.
  ///
  /// Throws an `Exception` if the value is an `Ok`, with the passed message.
  Err expectErr(String msg) {
    if (_ok != null) {
      throw Exception(msg);
    } else {
      return _err;
    }
  }

  /// Maps a `Result<Ok, Err>` to `Result<NewOk, Err>` by applying a function to
  /// a contained `Ok` value, leaving an `Err` value untouched.
  Result<NewOk, Err> map<NewOk>(NewOk Function(Ok) op) {
    if (_ok != null) {
      return Result.ok(op(_ok));
    } else {
      return Result.err(_err);
    }
  }

  /// Maps a `Result<Ok, Err>` to `Result<Ok, NewErr>` by applying a function to
  /// a contained `Err` value, leaving an `Ok` value untouched.
  ///
  /// This function can be used to pass through a successful result while
  /// handling an error.
  Result<Ok, NewErr> mapErr<NewErr>(NewErr Function(Err) op) {
    if (_err != null) {
      return Result.err(op(_err));
    } else {
      return Result.ok(_ok);
    }
  }

  /// Applies a function to the contained value (if any), or returns the
  /// provided default (if not).
  NewOk mapOr<NewOk>(NewOk Function(Ok) op, NewOk opt) {
    if (_ok != null) {
      return op(_ok);
    } else {
      return opt;
    }
  }

  /// Maps a `Result<Ok, Err>` to `NewOk` by applying a function to a contained
  /// `Ok` value, or a fallback function to a contained `Err` value.
  NewOk mapOrElse<NewOk>(NewOk Function(Ok) op, NewOk Function(Err) errOp) {
    if (_ok != null) {
      return op(_ok);
    } else {
      return errOp(_err);
    }
  }

  /// Returns `res` if the result is `Ok`, otherwise returns `this`.
  Result<Ok, Err> and(Result<Ok, Err> res) {
    if (_ok != null) {
      return res;
    } else {
      return this;
    }
  }

  /// Calls `op` with the `Ok` value if the result is `Ok`, otherwise returns
  /// `this`.
  Result<Ok, Err> andThen(Result<Ok, Err> Function(Ok) op) {
    if (_ok != null) {
      return op(_ok);
    } else {
      return this;
    }
  }

  /// Returns `res` if the result is an `Err`, otherwise returns `this`.
  Result<Ok, Err> or(Result<Ok, Err> res) {
    if (_ok != null) {
      return this;
    } else {
      return res;
    }
  }

  /// Calls `op` with the `Err` value if the result is `Err`, otherwise returns
  /// `this`.
  Result<Ok, Err> orElse(Result<Ok, Err> Function(Err) op) {
    if (_ok != null) {
      return this;
    } else {
      return op(_err);
    }
  }

  /// Unwraps a result, yielding the content of an `Ok`.
  ///
  /// Throws the contained error if this result is an `Err`.
  Ok unwrap() {
    if (_ok != null) {
      return _ok;
    } else {
      throw _err;
    }
  }

  /// Unwraps a result, yielding the content of an `Err`.
  ///
  /// Throws an exception if the value is an `Ok`, with a custom message
  /// provided by calling `toString()` on the `Ok`'s value.
  Err unwrapErr() {
    if (_ok != null) {
      throw Exception(_ok.toString());
    } else {
      return _err;
    }
  }

  /// Unwraps a result, yielding the content of an `Ok`. Else, it returns `opt`.
  Ok unwrapOr(Ok opt) {
    return _ok ?? opt;
  }

  /// Unwraps a result, yielding the content of an `Ok`. If the value is an
  /// `Err` then it calls `op` with its value.
  Ok unwrapOrElse(Ok Function(Err) op) {
    return _ok ?? op(_err);
  }
}
