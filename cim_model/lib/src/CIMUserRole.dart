import 'package:aqueduct/aqueduct.dart';
import 'CIMRole.dart';
import 'CIMUser.dart';

class CIMUserRole extends ManagedObject<_CIMUserRole> implements _CIMUserRole{}

class _CIMUserRole {
  @primaryKey
  int id;
  @Relate(#roles)
  CIMRole role;

  @Relate(#roles)
  CIMUser user;
}