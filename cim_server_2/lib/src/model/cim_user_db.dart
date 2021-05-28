import 'package:cim_protocol/cim_protocol.dart';
import 'package:cim_server_2/src/orm/orm.dart';


class CIMUserDB extends ManagedObject<_CIMUserDB> implements _CIMUserDB{
  CIMUser toUser(){
    final user = CIMUser(username!, pwrd!);
    try {
      user.role =
          UserRoles.values.firstWhere((element) => element.toString() == role);
    }catch(e){user.role = UserRoles.patient;}
      user.id = id!;
      return user;
    }
  }
@Table('users')
class _CIMUserDB{
//  @primaryKey
  @Column(valueType: ValueTypes.generated)
  int? id;
  @Column()
  String? username;
  @Column()
  String? pwrd;
  @Column()
  String? role;
}