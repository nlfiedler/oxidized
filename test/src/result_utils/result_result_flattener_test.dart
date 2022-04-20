// ignore_for_file: prefer_const_constructors

import 'package:oxidized/oxidized.dart';
import 'package:test/test.dart';

typedef Res = Result<int, String>;
typedef ResRes = Result<Result<int, String>, String>;

void main() {
  test('Ok(Ok(val).flatten() must return Ok(val)', () async {
    final ResRes input = Ok(Ok(1));
    final Res output = Ok(1);
    expect(input.flatten(), output);
  });

  test('Ok(Err(err).flatten() must return Err(err)', () async {
    final ResRes input = Ok(Err('error message'));
    final Res output = Err('error message');
    expect(input.flatten(), output);
  });

  test('Err(err).flatten() must return Err(err)', () async {
    final ResRes input = Err('error message');
    final Res output = Err('error message');
    expect(input.flatten(), output);
  });
}
