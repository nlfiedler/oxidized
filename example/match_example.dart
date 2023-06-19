import 'package:oxidized/oxidized.dart';

Result<num, String> divide(num numerator, num denominator) {
  if (denominator == 0.0) {
    return Err('divide by zero');
  } else {
    return Ok(numerator / denominator);
  }
}

// Example using exhaustive pattern matching in Dart 3.
void main() {
  final result = divide(10, 0);
  final value = switch (result) {
    Ok(value: final x) => x,
    Err(error: final e) => 0,
  };
  print(value);

  final result2 = divide(10, 2);
  if (result2 case Ok(value: final x)) {
    print(x);
  }
}
