import 'package:aqueduct/aqueduct.dart';
import 'package:cim_protocol/cim_protocol.dart';


class CIMUserDB extends ManagedObject<_CIMUserDB> implements _CIMUserDB{}
@Table(name: 'users')
class _CIMUserDB{
  @primaryKey
  int id;

  @Column(unique: true)
  String username;
  @Column()
  String phone;
  @Column()
  String pwrd;
  @Column()
  String name;
  @Column()
  String last_name;
  @Column()
  String mail;

  CIMUser toUser(){
    final user = CIMUser(username, pwrd);
    return user;
  }
}