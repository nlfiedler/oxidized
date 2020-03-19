import 'package:oxidized/oxidized.dart';

Option<num> divide(num numerator, num denominator) {
  if (denominator == 0.0) {
    return None();
  } else {
    return Some(numerator / denominator);
  }
}

void main() {
  divide(10, 0).when(
    some: (v) {
      print(v);
    },
    none: () {
      print('oops');
    },
  );

  // you can print the option, too
  print(divide(10, 2));
}
