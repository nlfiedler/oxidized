import 'package:oxidized/oxidized.dart';

// Insert an entry in a thing and return "nothing" when successful.
Result<Unit, Exception> insertEntry(String name) {
  // perform some operation here...
  return Ok(unit);
}

void main() {
  var result = insertEntry('SampleEntry');
  if (result is Err) {
    print('oh no, unable to insert the entry!');
  } else {
    print('nothing much to say about unit result');
  }
}
