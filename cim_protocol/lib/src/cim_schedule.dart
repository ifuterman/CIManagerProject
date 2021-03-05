import 'package:cim_protocol/cim_protocol.dart';

class CIMSchedule{
  int id;
  CIMDoctor doctor;
  CIMPatient patient;
  DateTime date;
  DateTime duration;
  String note;
}