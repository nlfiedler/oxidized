//
// Copyright (c) 2020 Nathan Fiedler
//

/// Defines types similar to those in Rust, such as `Result` and `Option`.
///
/// # Option
///
/// Type `Option<T>` represents an optional value, either `Some` and its value,
/// or `None` which does not have a value. The `Option<T>` primarily serves as
/// an alternative to nullable values, the benefit being that this type requires
/// you to explicitly deal with the optional nature of the value.
///
/// ## Example
///
/// Borrowing from the Rust API documentation, the function below performs
/// numeric division, returning a `None` if the denominator is zero.
///
/// ```dart
/// Option<num> divide(num numerator, num denominator) {
///   if (denominator == 0.0) {
///     return None();
///   } else {
///     return Some(numerator / denominator);
///   }
/// }
///
/// divide(10, 0).when(
///   some: (v) {
///     print(v);
///   },
///   none: () {
///     print('oops');
///   },
/// );
/// ```
///
/// # Result
///
/// The `Result<T, E>` type is intended for representing either a value, or an
/// error. Typical use would be for functions that perform input/output
/// operations that may result in a failure that is expected and recoverable
/// (i.e. the behavior is not "exceptional", thus the code does not throw an
/// exception). Using `Result<T, E>` encourages taking a direct approach to
/// dealing with the result, _without_ worrying about forgetting to `catch` all
/// possible exceptions.
///
/// ## Example
///
/// Again, borrowing from the Rust API documentation, the function below parses
/// some simple input and returns the result.
///
/// ```dart
/// enum Version { version1, version2 }
///
/// Result<Version, Exception> parse_version(List<int> header) {
///   switch (header[0]) {
///     case 0:
///       return Err(Exception('invalid header length'));
///     case 1:
///       return Ok(Version.version1);
///     case 2:
///       return Ok(Version.version2);
///     default:
///       return Err(Exception('invalid version'));
///   }
/// }
///
/// void main() {
///   final version = parse_version([1, 2, 3, 4]);
///   version.when(
///     ok: (v) {
///       print('working with version: ${v}');
///     },
///     err: (e) {
///       print('error parsing header: ${e}');
///     },
///   );
/// }
/// ```
///
/// # Unit
///
/// Similar to the Rust `()` type, the `Unit` type has exactly one value `()`,
/// and is used when there is no other meaningful value that could be returned.
/// This is especially useful for `Result` when not returning anything other
/// than an error, as returning `void` in Dart is difficult with type
/// parameterization.
///
/// The single instance of `Unit` is defined as the `unit` constant in the
/// package.
library oxidized;

export 'src/option.dart';
export 'src/result.dart';
export 'src/unit.dart';

export 'src/option_utils/option_utils.dart';
export 'src/result_utils/result_utils.dart';
