import 'package:cim_server/cim_server.dart';
import 'package:cim_protocol/cim_protocol.dart';



class CIMDoctorDB extends ManagedObject<_CIMDoctorDB> implements _CIMDoctorDB{
  CIMDoctor toDoctor(){
    speciality ??= DoctorSpeciality.therapist.index;
    final doctor = CIMDoctor(name, last_name,
      DoctorSpeciality.values[speciality],
      middleName: middle_name,
      birthDate: birth_date,
      email: email,
      id: id,
      phones: phones,
      userId: users_id
    );
  }
}
@Table(name: 'doctors')
class _CIMDoctorDB{
  @Column(primaryKey: true, databaseType: ManagedPropertyType.bigInteger)
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
  @Column(databaseType: ManagedPropertyType.bigInteger)
  int users_id;
}