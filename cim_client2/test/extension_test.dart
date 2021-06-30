import 'package:equatable/equatable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cim_client2/core/extensions.dart';


void main() {
  EquatableConfig.stringify = true;

  test('String maxLen test', () async {
    expect(() => 'hello'.maxLen(-1),  throwsA(isA<AssertionError>()));
    expect('hello'.maxLen(0), '');
    expect('hello'.maxLen(1), 'h');
    expect('hello'.maxLen(6), 'hello');
    expect('hello'.maxLen(16), 'hello');
  });
}
