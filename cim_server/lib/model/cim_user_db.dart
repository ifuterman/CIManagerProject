import 'package:aqueduct/aqueduct.dart';
import 'package:cim_protocol/cim_protocol.dart';


class CIMUserDB extends ManagedObject<_CIMUserDB> implements _CIMUserDB{
  CIMUser toUser(){
    final user = CIMUser(username, pwrd);
    user.role = role;
    user.id = id;
    return user;
  }
}
@Table(name: 'users')
class _CIMUserDB{
//  @primaryKey
  @Column(primaryKey: true, databaseType: ManagedPropertyType.bigInteger)
  int id;

  @Column(unique: true)
  String username;
  @Column()
  String pwrd;
  @Column()
  UserRoles role;
}