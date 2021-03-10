import 'dart:io';
import 'package:oxidized/oxidized.dart';

Result<String, Exception> readFileSync(String name) {
  return Result.of(() {
    return File(name).readAsStringSync();
  });
}

Future<Result<Future<String>, Exception>> readFile(String name) async {
  return Result.of(() async {
    return await File(name).readAsString();
  });
}

void main() async {
  var result = readFileSync('README.md');

  // you can use `is` like so
  if (result is Err) {
    print('oh no, unable to read the file!');
  } else {
    print('read the file successfully');
    // it is safe to call .unwrap() here
  }

  // or you can use the match function
  result.match((text) {
    print('first 80 characters of file:\n');
    print(text.substring(0, 80));
  }, (err) => print(err));

  // also, you can return values in a functional way
  final length = result.when(
    ok: (text) => text.length,
    err: (err) => -1,
  );
  print(length);

  // using the "catching" constructor with futures is also feasible
  var futureResult = await readFile('LICENSE');
  futureResult.when(
    ok: (text) async {
      var text = await futureResult.unwrap();
      print('\nlength of LICENSE file: ${text.length}');
    },
    err: (err) => print(err),
  );
}
