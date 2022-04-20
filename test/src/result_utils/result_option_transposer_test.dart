// ignore_for_file: prefer_const_constructors

import 'package:oxidized/oxidized.dart';
import 'package:test/test.dart';

typedef OptRes = Option<Result<int, String>>;
typedef ResOpt = Result<Option<int>, String>;

void main() {
  test('Ok(None()).transpose() must return None()', () async {
    final ResOpt input = Ok(None());
    final OptRes output = None();
    expect(input.transpose(), output);
  });

  test('Ok(Some(val)).transpose() must return Some(Ok(val))', () async {
    final ResOpt input = Ok(Some(1));
    final OptRes output = Some(Ok(1));
    expect(input.transpose(), output);
  });

  test('Err(err).transpose() must return Some(Err(err))', () async {
    final ResOpt input = Err('error message');
    final OptRes output = Some(Err('error message'));
    expect(input.transpose(), output);
  });
}
