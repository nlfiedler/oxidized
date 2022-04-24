// ignore_for_file: prefer_const_constructors

import 'package:oxidized/oxidized.dart';
import 'package:test/test.dart';

typedef OptRes = Option<Result<int, String>>;
typedef ResOpt = Result<Option<int>, String>;

void main() {
  test('None() transpose must return Ok(None())', () {
    final OptRes input = None();
    final ResOpt output = Ok(None());
    expect(input.transpose(), equals(output));
  });

  test('Some(Ok(val)) transpose must return Ok(Some(val))', () {
    final OptRes input = Some(Ok(1));
    final ResOpt output = Ok(Some(1));
    expect(input.transpose(), equals(output));
  });

  test('Some(Err(val)) transpose must return Err(val)', () {
    final OptRes input = Some(Err('error'));
    final ResOpt output = Err('error');
    expect(input.transpose(), equals(output));
  });
}
