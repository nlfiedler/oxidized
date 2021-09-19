import 'package:oxidized/oxidized.dart';
import 'package:test/test.dart';

typedef OptInt = Option<int>;
typedef OptOptInt = Option<OptInt>;

void main() {
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
}
