import 'package:aqueduct/aqueduct.dart';


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
}