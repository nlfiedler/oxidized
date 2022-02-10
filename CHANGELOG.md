# Change Log

All notable changes to this project will be documented in this file.
This project adheres to [Semantic Versioning](http://semver.org/).
This file follows the convention described at
[Keep a Changelog](http://keepachangelog.com/en/1.0.0/).

## [5.2.0] - 2022-02-10

### Added

- rlch: Added async methods to `Option<T>` and `Result<T, E>`.
- rlch: Added missing type arguments to `Option<T>` and `Result<T, E>`.
- rlch: Added code coverage for async methods.
- rlch: Added `OptionFutureRedirector` util to redirect methods called on `Future<Option<T>>`.
- rlch: Added `ResultFutureRedirector` util to redirect methods called on `Future<Result<T, E>>`.

## [5.1.0] - 2021-09-20

### Added

- kranfix: `Option<Result<T, E>>.transpose()` returns a `Result<Option<T>, E>`.
- kranfix: `Option<Option<T>>.flatten()` returns an `Option<T>`.
- kranfix: `Result<Option<T>, E>.transpose()` returns an `Option<Result<T, E>>`.
- kranfix: `Result<Result<T, E>, E>.flatten()` returns a `Result<T, E>`.

## [5.0.1] - 2021-08-24

### Changed

- kranfix: Fixed equality operator for `Option` and `Result`.
- kranfix: Added more code coverage in unit tests.

## [5.0.0] - 2021-08-11

### Changed

- **BREAKING CHANGE:** can no longer pass `null` to `Result`. The rectifies the
  inconsistent handling of null values with regards to `Option` and `Result`.
- kranfix: refactored `Option<T extends Object>` to fix `Result<int?, Exception>.ok(null).ok()`
- kranfix: refactored `Result<T extends Object, E extends Object>` to fix `Result<int?, Exception>.ok(null)`

## [4.2.0] - 2021-04-30

### Added

- lemunozm: added `isSome()`, `isNone()` to `Option`.
- lemunozm: added `isOk()`, `isErr()` to `Result`.
- lemunozm: added `Option.from()` and `Option.toNullable()` to make easy conversions with nullable values.
- Added a `Unit` type that is similar to Rust's `()` type.

## [4.1.0] - 2021-03-09

### Changed

- lemunozm: return values added to `match()`, `when()` in `Result`, `Option`.

## [4.0.0] - 2021-03-03

### Changed

- **BREAKING CHANGE:** migrated to null safety and Dart SDK 2.12.

## [3.1.0] - 2020-03-22

### Added

- Add `fold()` function on `Result` that combines `map()` and `mapErr()`.

## [3.0.1] - 2020-03-18

### Changed

- Fix the package description and code formatting.

## [3.0.0] - 2020-03-18

### Changed

- **BREAKING CHANGES:** see below for the details.
- The `Result` "ok" and "error" values are full-fledged classes now.
- The `Option` "some" and "none" values are full-fledged classes now.
- `Option.isSome()` and `Option.isNone()` are gone, use `is Some` and `is None`.
- `Result.isOk()` and `Result.isErr()` are gone, use `is Ok` and `is Err`.
- The default `Result` constructor has been renamed to `of()` instead.
- Passing `null` to the `Option.some()` factory constructor will yield a `None`.
- Both the `Ok` and `Err` subclasses of `Result` allow for null arguments.

## [2.0.0] - 2020-03-14

### Added

- Borrowing from `simple_result`, added `when()` as an alternative to `match()`.

### Changed

- **BREAKING CHANGE:** the various `is` methods are now getters.
- Extend `Equatable` in both `Option` and `Result`.
- Override the equals operator (`==`) in both `Option` and `Result`.

## [1.0.0] - 2020-03-09

### Added

- Initial version
