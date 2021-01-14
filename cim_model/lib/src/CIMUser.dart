import 'package:aqueduct/aqueduct.dart';
import 'CIMUserRole.dart';


class CIMUser extends ManagedObject<_CIMUser> implements _CIMUser{}
class _CIMUser{
  @primaryKey
  int id;

  @Column(unique: true)
  String login;
  String pwrd;//MD5 hash for pwrd
  String name;
  String last_name;
  String mail;
  String phone;

  ManagedSet<CIMUserRole> roles;
}