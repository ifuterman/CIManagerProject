import 'dart:indexed_db';

import 'package:cim_server_2/src/orm/orm.dart';
import 'package:cim_server_2/src/orm/src/database_types.dart';


class CIMToken extends ManagedObject<_CIMToken> implements _CIMToken{}
@Table('tokens')
class _CIMToken{
  @Column(valueType: ValueTypes.generated)
  int? id;
  @Column()
  String? token;
  @Column()
  String? refresh_token;
  @Column(type: DatabaseTypes.datetime)
  DateTime? expiration;
  @Column()
  int? users_id;
}