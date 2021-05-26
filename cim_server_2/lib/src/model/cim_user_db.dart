import 'package:cim_protocol/cim_protocol.dart';
import 'package:cim_server_2/src/orm/orm.dart';


class CIMUserDB extends ManagedObject<_CIMUserDB> implements _CIMUserDB{
  CIMUser toUser(){
    final user = CIMUser(username!, pwrd!);
    user.role = role!;
    user.id = id!;
    return user;
  }
}
@Table('users')
class _CIMUserDB{
//  @primaryKey
  @Column()
  int? id;

  @Column()
  String? username;
  @Column()
  String? pwrd;
  @Column()
  UserRoles? role;
}