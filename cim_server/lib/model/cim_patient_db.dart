import 'package:cim_server/cim_server.dart';
import 'package:cim_protocol/cim_protocol.dart';

class CIMPatientDB extends ManagedObject<_CIMPatientDB> implements _CIMPatientDB{
  CIMPatient toPatient() => CIMPatient(id, last_name, name, sex,
      status: status,
      snils: snils,
      middleName: middle_name,
      birthDate: birth_date,
      email: email,
      phones: phone
    );
}
@Table(name: 'patients')
class _CIMPatientDB{
//  @primaryKey
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
  String phone;
  @Column()
  String email;
  @Column()
  String snils;
  @Column()
  Participation status;
  @Column()
  Sex sex;
}