import 'package:flutter_test/flutter_test.dart';

import 'package:cim_shared/cim_shared.dart';

void main() {
  test('Result', () {

    final res1 = Ok();
    final res2 = Ok();
    expect(res1, equals(res2));

  });
}
