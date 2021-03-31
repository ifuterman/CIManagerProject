import 'package:cim_client/views/shared/funcs.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_test/flutter_test.dart';


void main() {
  EquatableConfig.stringify = true;

  test('HasNoSense test', () async {
    expect(hasNoSense(null), isTrue);
    {
      String s;
      expect(hasNoSense(s), isTrue);
    }
    {
      expect(hasNoSense(''), isTrue);
      expect(hasNoSense('a', matcher: 'a'), isTrue);
      expect(hasNoSense('a', matcher: 1), isTrue);
      expect(hasNoSense('a', matcher: true), isTrue);
      expect(hasNoSense('a', matcher: 'b'), isFalse);
    }
    {
      expect(hasNoSense(0), isTrue);
      expect(hasNoSense(1, matcher: 'a'), isTrue);
      expect(hasNoSense(1, matcher: 1), isTrue);
      expect(hasNoSense(1, matcher: 2), isFalse);
    }

  });

  test('HasSense test', () async {
    expect(hasNoSense(null), isTrue);
    {
      String s;
      expect(hasSense(s), isFalse);
    }
    {
      expect(hasSense(''), isTrue);
      expect(hasSense('a', matcher: 'a'), isTrue);
      expect(hasSense('a', matcher: 1), isFalse);
      expect(hasSense('a', matcher: true), isFalse);
      expect(hasSense('a', matcher: 'b'), isFalse);
    }
    {
      expect(hasSense(0), isTrue);
      expect(hasSense(1, matcher: 'a'), isFalse);
      expect(hasSense(1, matcher: 1), isTrue);
      expect(hasSense(1, matcher: 2), isFalse);
    }

  });

}
