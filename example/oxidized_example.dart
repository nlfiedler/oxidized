import 'dart:io';
import 'package:oxidized/oxidized.dart';

Result<String, Exception> readFileSync(String name) {
  return Result(() {
    return File(name).readAsStringSync();
  });
}

Future<Result<Future<String>, Exception>> readFile(String name) async {
  return Result(() async {
    return await File(name).readAsString();
  });
}

void main() async {
  var result = readFileSync('README.md');

  // you can use switch like so
  switch (result.type()) {
    case ResultType.err:
      print('oh no, unable to read the file!');
      break;
    case ResultType.ok:
      print('read the file successfully');
      // it is safe to call .unwrap() here
      break;
  }

  // or you can use the match function
  result.match((text) {
    print('first 80 characters of file:\n');
    print(text.substring(0, 80));
  }, (err) => print(err));

  // using the "catching" constructor with futures is also feasible
  var futureResult = await readFile('LICENSE');
  var text = await futureResult.unwrap();
  print('\nlength of LICENSE file: ${text.length}');
}
