import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';

///
@freezed
class User with _$User {
  factory User({
    required int id,
    required String userName,
    required String password,
  }) = _User;
}

@freezed
class Users with _$Users {
  factory Users(IList<User> items) = _Users;
}


