import 'package:cim_protocol/cim_protocol.dart';
import 'package:cim_server_2/orm/orm.dart';


class CIMUserDB extends ManagedObject<_CIMUserDB> implements _CIMUserDB{
  CIMUser toUser(){
    final user = CIMUser(username!, pwrd!);
//    user.role = getRole();
    user.role = role;
    user.id = id!;
    return user;
  }
/*  UserRoles getRole(){
    if(role == null){
      return UserRoles.unknown;
    }
    try {
      var result = UserRoles.values.firstWhere((element) =>
      element.toString() == role);
      return result;
    }catch(e){return UserRoles.unknown;}
  }*/
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
//  String? role;
  UserRoles role = UserRoles.unknown;
}