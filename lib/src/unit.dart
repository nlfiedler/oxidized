//
// Copyright (c) 2020 Nathan Fiedler
//

/// The `Unit` type has exactly one value `()`, and is used when there is no
/// other meaningful value that could be returned for a `Result`.
///
/// For instance, returning a "nothing" `Result` would be as simple as
/// `Result.ok(unit)` and its type would be `Result<Unit, ..>` for whatever type
/// of error the result represents.
class Unit {
  const Unit._internal();

  @override
  String toString() => '()';
}

/// The one instance of `Unit`.
const Unit unit = Unit._internal();
