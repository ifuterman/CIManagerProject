import 'package:cim_protocol/cim_protocol.dart';

class CIMSchedule{
  
  int id;
  CIMDoctor doctor;
  CIMPatient patient;
  DateTime date;
  DateTime duration;
  String note;

  CIMSchedule(
      this.id, this.patient, this.date, {this.doctor, DateTime duration, this.note}){
    this.duration = duration ?? DateTime.utc(0, 0, 0, 0, 45);
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