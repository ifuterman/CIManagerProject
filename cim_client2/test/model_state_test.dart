import 'package:cim_client2/model/model_state.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cim_client2/core/extensions.dart';

void main() {
  EquatableConfig.stringify = true;

  test('ModelState test', () async {
    expect(getState(null, forceError: true), isA<ErrorDetails>());
    expect(getState('null', forceError: true), isA<ErrorDetails<String>>());
    expect(getState(null), isA<Loading>());
    expect(getState('null'), isA<Data<String>>());
    expect((getState(333) as Data<int>).value, equals(333));
  });
}

ModelState<T> getState<T>(T? value, {bool forceError = false}) {
  final op = forceError
      ? ModelState<T>.error()
      : value == null
          ? ModelState<T>.loading()
          : ModelState<T>(value);
  return op.when(
    (value) => op,
    loading: () => op,
    error: ([message]) => op,
    initial: () => op,
  );
}
