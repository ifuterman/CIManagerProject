import 'package:cim_protocol/cim_protocol.dart';
import 'package:cim_server_2/orm/orm.dart';
import 'package:cim_server_2/orm/src/database_types.dart';


class CIMDoctorDB extends ManagedObject<_CIMDoctorDB> implements _CIMDoctorDB{
  CIMDoctor toDoctor(){
    final doctor = CIMDoctor(name ?? '', last_name ?? '', speciality,
      middleName: middle_name,
      birthDate: birth_date,
      email: email,
      id: id ?? 0,
      phones: phones,
      userId: users_id ?? 0
    );
    return doctor;
  }
}
@Table('doctors')
class _CIMDoctorDB{
  @Column(valueType: ValueTypes.generated)
  int? id;
  @Column()
  String? name;
  @Column()
  String? middle_name;
  @Column()
  String? last_name;
  @Column(type: DatabaseTypes.datetime)
  DateTime? birth_date;
  @Column()
  String? email;
  @Column()
  String? phones;
  @Column()
  DoctorSpeciality speciality = DoctorSpeciality.unknown;
  @Column()
  int? users_id;
}