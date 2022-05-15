// ignore_for_file: prefer_const_constructors

import 'package:oxidized/oxidized.dart';
import 'package:test/test.dart';

typedef OptInt = Option<int>;
typedef OptOptInt = Option<OptInt>;

void main() {
  group('Option<Option<T>', () {
    test('None().flatten() must return None', () {
      final OptOptInt input = None();
      final OptInt output = None();
      expect(input.flatten(), equals(output));
    });

    test('Some(None()).flatten() must return None()', () {
      final OptOptInt input = Some(None());
      final OptInt output = None();
      expect(input.flatten(), equals(output));
    });

    test('Some(Some(val)).flatten() must return Some(val)', () {
      final OptOptInt input = Some(Some(1));
      final OptInt output = Some(1);
      expect(input.flatten(), equals(output));
    });
  });

  group('Future<Option<Option<T>>>', () {
    test('None().flatten() must return None', () async {
      final OptOptInt input = None();
      final futureInput = Future.value(input);
      final OptInt output = None();
      expect(await futureInput.flatten(), equals(output));
    });

    test('Some(None()).flatten() must return None()', () async {
      final OptOptInt input = Some(None());
      final futureInput = Future.value(input);
      final OptInt output = None();
      expect(await futureInput.flatten(), equals(output));
    });

    test('Some(Some(val)).flatten() must return Some(val)', () async {
      final OptOptInt input = Some(Some(1));
      final futureInput = Future.value(input);
      final OptInt output = Some(1);
      expect(await futureInput.flatten(), equals(output));
    });
  });
}
