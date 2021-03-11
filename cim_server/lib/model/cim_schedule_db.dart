import 'package:cim_server/cim_server.dart';
import 'package:cim_protocol/cim_protocol.dart';
import 'cim_doctor_db.dart';

class CIMScheduleDB extends ManagedObject<_CIMScheduleDB> implements _CIMScheduleDB{
  CIMSchedule toSchedule (Map<int, CIMDoctor> doctors, Map<int, CIMPatient> patients){
    final patient = patients[patient_id];
    if(patient == null){
      return null;
    }
    final doctor = doctors[doctor_id];
    return CIMSchedule(id, patient, date, duration: duration, doctor: doctor, note: note);
  }
}
@Table(name: 'schedule')
class _CIMScheduleDB {
  @Column(primaryKey: true, databaseType: ManagedPropertyType.bigInteger)
  int id;
  @Column(databaseType: ManagedPropertyType.datetime)
  DateTime date;
  @Column()
  String note;
  @Column()
  int duration;
  @Relate(#doctors)
  @Column(databaseType: ManagedPropertyType.bigInteger)
  int doctor_id;
  @Relate(#patients)
  @Column(databaseType: ManagedPropertyType.bigInteger)
  int patient_id;
}