import 'package:cim_protocol/cim_protocol.dart';
import 'package:cim_server_2/orm/orm.dart';
import 'package:cim_server_2/orm/src/database_types.dart';

class CIMPatientDB extends ManagedObject<_CIMPatientDB> implements _CIMPatientDB{
  CIMPatient toPatient() => CIMPatient(id ?? 0, last_name ?? '', name ?? '', sex,
      status: status,
      snils: snils,
      middleName: middle_name,
      birthDate: birth_date,
      email: email,
      phones: phone,
    );
}
@Table('patients')
class _CIMPatientDB{
//  @primaryKey
  @Column()
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
  String? phone;
  @Column()
  String? email;
  @Column()
  String? snils;
  @Column()
  Participation status = Participation.unknown;
  @Column()
  Sex sex = Sex.male;
}