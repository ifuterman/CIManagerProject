import 'package:cim_server/cim_server.dart';

class CIMDoctorDB extends ManagedObject<_CIMDoctorDB> implements _CIMDoctorDB{}
@Table(name: 'doctors')
class _CIMDoctorDB{
  @primaryKey
  int id;
  @Column()
  String name;
  @Column()
  String middle_name;
  @Column()
  String last_name;
  @Column(databaseType: ManagedPropertyType.datetime)
  DateTime birth_date;
  @Column()
  String email;
  @Column()
  String phones;
  @Column()
  int speciality;
  @Relate(#users)
  int users_id;
}