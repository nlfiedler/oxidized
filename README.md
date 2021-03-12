# oxidized

A Dart package with types similar to those found in Rust, such as the `Result`
which represents either a value or an error, and `Option` which either contains
`Some` value or `None`.

## Motivation

The `Option` and `Result` types are akin to the "sum types" found in languages
such as [OCaml](https://ocaml.org) and [Rust](https://www.rust-lang.org). They
encourage safer code by making errors and possible "null" values (i.e. `None`) a
necessary part of the code flow, requiring you to deal with these cases appropriately.
For an illustration of how this style of coding can prove to be helpful, see the
excellent tutorial series by Matt Rešetá
[Flutter TDD Clean Architecture Course – Entities & Use Cases](https://resocoder.com/2019/08/29/flutter-tdd-clean-architecture-course-2-entities-use-cases/)
in which he uses the `Either` type from the
[dartz](https://pub.dev/packages/dartz) package to represent either a success or
a failure. The `Result` type in this package is specifically designed for this
purpose, making it easy to remember which part is the "success" and which is the
"failure" (imagine trying to remember "Is the right side the failure? Or was it
the left?").

## Usage

A simple example using synchronous I/O to avoid nested futures is shown below.
For additional examples, see the Dart code in the `example` directory.

```dart
import 'dart:io';
import 'package:oxidized/oxidized.dart';

Result<String, Exception> readFileSync(String name) {
  return Result.of(() {
    return File(name).readAsStringSync();
  });
}

void main() {
  var result = readFileSync('README.md');

  result.match((text) {
    print('first 80 characters of file:\n');
    print(text.substring(0, 80));
  }, (err) => print(err));

  // or in a more functional way:
  final msg = result.when(
    ok: (text) => 'first 80 characters of file:\n$text.substring(0, 80)',
    err: (err) => err,
  );
  print(msg);
}
```

## Prior Art

The [dartz](https://pub.dev/packages/dartz) package offers many functional
programming helpers, including the `Either` type, which is similar to `Result`,
with the difference being that it represents any two types of values.

The [either_option](https://pub.dev/packages/either_option) package has both
`Either` and `Option` and supports all of the typical functional operations.

The [result](https://pub.dev/packages/result) package offers a few basic
operations and may be adequate for simple cases.

The [rust_like_result](https://pub.dev/packages/rust_like_result) offers a
simple `Result` type similar to the one in Rust.

The [simple_result](https://pub.dev/packages/simple_result) package provides
a similar `Result` type based on the type of the same name in Swift.
