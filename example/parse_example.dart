import 'package:oxidized/oxidized.dart';

enum Version { version1, version2 }

Result<Version, Exception> parse_version(List<int> header) {
  switch (header[0]) {
    case 0:
      return Err(Exception('invalid header length'));
    case 1:
      return Ok(Version.version1);
    case 2:
      return Ok(Version.version2);
    default:
      return Err(Exception('invalid version'));
  }
}

void main() {
  final version = parse_version([1, 2, 3, 4]);
  version.when(
    ok: (v) {
      print('working with version: $v');
    },
    err: (e) {
      print('error parsing header: $e');
    },
  );
}
