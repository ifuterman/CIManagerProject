import 'package:aqueduct/aqueduct.dart';
import 'CIMUserRole.dart';

enum CIMRoleType{
  admin,
  superuser,
  technician,
  medic,
  patient
}

class CIMRole extends ManagedObject<_CIMRole> implements _CIMRole{}

class _CIMRole{
  @primaryKey
  int id;
  CIMRoleType roleType;

  ManagedSet<CIMUserRole> roles;
}