import 'package:cim_protocol/cim_protocol.dart';

import '../cim_protocol.dart';

enum DoctorSpeciality{
  therapist
}

class CIMDoctor{
  CIMDoctor(this.name, this.lastName, this.speciality, {this.middleName, this.birthDate, this.email, this.phones, this.userId = 0, this.id = 0});
  int id;
  String name;
  String middleName;
  String lastName;
  DateTime birthDate;
  String email;
  String phones;
  DoctorSpeciality speciality;
  int userId = 0;
}