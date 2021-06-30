import 'package:cim_protocol/cim_protocol.dart';
import 'package:cim_server_2/orm/orm.dart';
import 'package:cim_server_2/orm/src/database_types.dart';
import 'cim_patient_db.dart';
import 'cim_doctor_db.dart';

class CIMScheduleDB extends ManagedObject<_CIMScheduleDB> implements _CIMScheduleDB{
  /*CIMSchedule toSchedule (Map<int, CIMDoctor> doctors, Map<int, CIMPatient> patients){
    final patient = patients[patient_id];
    if(patient == null){
      return null;
    }
    final doctor = doctors[doctor_id];
    return CIMSchedule(id, patient, date, duration: duration, doctor: doctor, note: note);
  }

   */
  CIMSchedule toSchedule(CIMPatient patient, CIMDoctor? doctor){
    return CIMSchedule(id, patient, date, duration: duration, doctor: doctor, note: note);
  }
}
@Table('schedule')
class _CIMScheduleDB {
  @Column()
  int id = 0;
  @Column(type: DatabaseTypes.datetime)
  DateTime date = DateTime.now();
  @Column()
  String note = '';
  @Column()
  int duration = 40;
  @Column()
  int? doctor_id;
  @Column()
  int patient_id = 0;
}