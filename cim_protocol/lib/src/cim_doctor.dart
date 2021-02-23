import 'package:cim_protocol/cim_protocol.dart';

enum DoctorSpeciality{
  therapist
}

class CIMDoctor{
  CIMDoctor(this._user);
  CIMUser _user;

  CIMUser get user => _user;
  int id;
  String name;
  String middleName;
  String lastName;
  DateTime birthDate;
  String email;
  String phones;
  DoctorSpeciality speciality;
}