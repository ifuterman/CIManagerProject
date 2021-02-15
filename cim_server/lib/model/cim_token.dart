import 'package:aqueduct/aqueduct.dart';


class CIMToken extends ManagedObject<_CIMToken> implements _CIMToken{}
@Table(name: 'tokens')
class _CIMToken{
  @primaryKey
  int id;
  @Column(unique: true)
  String token;
  @Column(unique: true)
  String refresh_token;
  @Column(databaseType: ManagedPropertyType.datetime)
  DateTime expiration;
  @Relate(#users)
  int users_id;
}