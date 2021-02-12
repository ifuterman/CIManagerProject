import 'package:aqueduct/aqueduct.dart';


class CIMToken extends ManagedObject<_CIMToken> implements _CIMToken{}
@Table(name: 'tokens')
class _CIMToken{
  @primaryKey
  String token;

  @Column(databaseType: ManagedPropertyType.datetime)
  DateTime expiration;
  @Relate(#users)
  int users_id;
}