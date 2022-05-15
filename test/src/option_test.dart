//
// Copyright (c) 2020 Nathan Fiedler
//
// ignore_for_file: prefer_const_constructors

import 'package:oxidized/oxidized.dart';
import 'package:test/test.dart';

void main() {
  group('Option', () {
    test('some has a value', () {
      expect(Option.some(1), isA<Some>());
      expect(Some(1), isA<Some>());
    });

    test('none has nothing', () {
      expect(Option.none(), isA<None>());
      expect(None(), isA<None>());
      expect(None(), equals(None()));
      expect(None() == None(), isTrue);
    });

    test('from nullable', () {
      expect(Option.from(1).isSome(), isTrue);
      expect(Option<int>.from(null).isNone(), isTrue);
    });
  });
}
