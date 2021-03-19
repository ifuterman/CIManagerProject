
import 'package:cim_protocol/cim_protocol.dart';

import 'cim_json_mapper.dart';

class CIMJsonMapper_0_0_1 extends CIMJsonMapper{
  final String loginKey = 'login';
  final String passwordKey = 'password';
  final String idKey = 'id';
  final String roleKey = 'role';
  final String userKey = 'user';
  final String nameKey = 'name';
  final String middleNameKey = 'middleName';
  final String lastNameKey = 'lastName';
  final String birthDateKey = 'birthDate';
  final String emailKey = 'email';
  final String phonesKey = 'phones';
  final String specialityKey = 'speciality';
  final String userIdKey = 'userId';
  final String snilsKey = 'snils';
  final String statusKey = 'status';
  final String sexKey = 'sex';
  final String doctorKey = 'doctor';
  final String patientKey = 'patient';
  final String noteKey = 'note';
  final String dateKey = 'date';
  final String durationKey = 'duration';

  @override
  String getVersion() => '0.0.1';

  @override
  CIMUser? userFromMap(Map<String, dynamic> map) {
    var login = map[loginKey];
//    var id = int.tryParse(map[idKey]);
    var id = map[idKey];
    var pwrd = map[passwordKey];
    if(login == null || pwrd == null){
      return null;
    }
    id ??= 0;
    var roleString = map[roleKey] ?? '';
    var role = UserRoles.values.firstWhere((element) => element.toString() == roleString);
    return CIMUser.fromJson(id, login, pwrd, role);
  }

  @override
  void userToMap(CIMUser user, Map<String, dynamic> map) {
    map[loginKey] = user.login;
    map[passwordKey] = user.password;
    map[idKey] = user.id;
    map[roleKey] = user.role.toString();
  }
  @override
  void doctorToMap(CIMDoctor doctor, Map<String, dynamic> map){
    map[idKey] = doctor.id;
    map[birthDateKey] = doctor.birthDate.toString();
    map[emailKey] = doctor.email;
    map[nameKey] = doctor.name;
    map[middleNameKey] = doctor.middleName;
    map[lastNameKey] = doctor.lastName;
    map[specialityKey] = doctor.speciality.toString();
    map[userIdKey] = doctor.userId;
    map[phonesKey] = doctor.phones;
  }
  @override
  CIMDoctor? doctorFromMap(Map<String, dynamic> map) {
    var name = map[nameKey];
    var lastName = map[lastNameKey];
    var specialityString = map[specialityKey];
    specialityString ??= DoctorSpeciality.therapist.toString();
    final speciality = DoctorSpeciality.values.firstWhere((element) => element.toString() == specialityString);
    var doctor = CIMDoctor(name, lastName, speciality);
    doctor.id = map[idKey];
    var testString = map[birthDateKey];
    if(testString != null) {
      doctor.birthDate = DateTime.tryParse(testString);
    }
    else{
      doctor.birthDate = DateTime.now();
    }
    doctor.email = map[emailKey];
    doctor.middleName = map[middleNameKey];
    doctor.userId = map[userIdKey];
    doctor.phones = map[phonesKey];
    return doctor;
  }
  @override
  void patientToMap(CIMPatient patient, Map<String, dynamic> map) {
    map[idKey] = patient.id.toString();
    map[birthDateKey] = patient.birthDate.toString();
    map[emailKey] = patient.email;
    map[nameKey] = patient.name;
    map[middleNameKey] = patient.middleName;
    map[lastNameKey] = patient.lastName;
    map[phonesKey] = patient.phones;
    map[snilsKey] = patient.snils;
    map[statusKey] = patient.status.toString();
    map[sexKey] = patient.sex.toString();
  }
    @override
    CIMPatient? patientFromMap(Map<String, dynamic> map) {
      if(map[lastNameKey] == null || map[nameKey] == null){
        return null;
      }
      var testString = map[birthDateKey];
      var birthDate = testString != null ? DateTime.tryParse(testString) : null;
      testString = map[sexKey];
      var sex = Sex.values.firstWhere((element) => element.toString() == testString,
      orElse: () => Sex.male);
      testString = map[idKey];
      final id = testString == null ? 0 : int.tryParse(testString) ?? 0;
      var patient = CIMPatient(id, map[lastNameKey], map[nameKey], sex,
        phones: map[phonesKey],
        email: map[emailKey],
        birthDate: birthDate,
        middleName: map[middleNameKey],
        snils: map[snilsKey]
      );
      testString = map[statusKey];
      if(testString != null){
        patient.status = Participation.values.firstWhere((element) =>
          element.toString() == testString,
          orElse: () => Participation.unknown);
      }
      return patient;
  }
  @override
  void scheduleToMap(CIMSchedule schedule, Map<String, dynamic> map) {
    map[idKey] = schedule.id;
    map[noteKey] = schedule.note;
    map[dateKey] = schedule.date.toString();
    map[durationKey] = schedule.duration;
    if(schedule.doctor != null){
      final doctorMap = <String, dynamic>{};
      if(schedule.doctor != null) {
        doctorToMap(schedule.doctor!, doctorMap);
        map[doctorKey] = doctorMap;
      }
    }
    else{
      map[doctorKey] = null;
    }
    if(schedule.patient != null){
      final patientMap = <String, dynamic>{};
      patientToMap(schedule.patient, patientMap);
      map[patientKey] = patientMap;
    }
  }
  @override
  CIMSchedule? scheduleFromMap(Map<String, dynamic> map) {
    try{
      var instanceMap = map[patientKey];
      final patient = patientFromMap(instanceMap);
      if(patient == null){
        return null;
      }
      instanceMap = map[doctorKey];
      final doctor = instanceMap == null ? null : doctorFromMap(instanceMap);
      final id = map[idKey];
      final note = map[noteKey];
      final duration = map[durationKey] ?? 45;
      var testString = map[dateKey];
      testString ??= '';
      final date = DateTime.tryParse(testString);
      if(date == null){
        return null;
      }
      return CIMSchedule(id, patient, date, doctor: doctor, duration: duration, note: note);
    }catch(e){
      return null;
    }
  }
}