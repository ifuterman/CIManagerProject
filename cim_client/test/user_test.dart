
import 'package:cim_client/model/entity/user.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vfx_flutter_common/utils.dart';

void main (){
  test('User test', () async {
    final user = User(id: 10, userName: 'user', password: 'password');
    expect(user, equals(User(id: 10, userName: 'user', password: 'password')));
    final user2 = user.copyWith(userName: 'user2');
    expect(user2,
        isNot(equals(User(id: 10, userName: 'user', password: 'password'))));
    expect(user2,
        equals(equals(User(id: 10, userName: 'user2', password: 'password'))));
    debugPrint('$now: user2 = $user2');
  });

  test('Users test', () async {
    final users = Users(IList());
    expect(users.items.length, equals(0));
    final users2 = users.copyWith(
        items: users.items
            .add(User(id: 10, userName: 'user', password: 'password')));
    expect(users2.items.length, equals(1));
  });
}