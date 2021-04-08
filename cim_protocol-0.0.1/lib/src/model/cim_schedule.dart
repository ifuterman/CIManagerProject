import 'package:cim_protocol/src/model/cim_patient.dart';
import 'package:cim_protocol/src/model/cim_doctor.dart';

class CIMSchedule{
  
  int id;
  CIMDoctor doctor;
  CIMPatient patient;
  DateTime date;
  int duration;
  String note;

  CIMSchedule(
      this.id, this.patient, this.date, {this.doctor, this.duration = 45, this.note}){
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CIMSchedule &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          doctor == other.doctor &&
          patient == other.patient &&
          date == other.date &&
          duration == other.duration &&
          note == other.note;

  @override
  int get hashCode =>
      id.hashCode ^
      doctor.hashCode ^
      patient.hashCode ^
      date.hashCode ^
      duration.hashCode ^
      note.hashCode;
}