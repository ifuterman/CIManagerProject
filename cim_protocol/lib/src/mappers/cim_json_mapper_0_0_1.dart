
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

  @override
  String getVersion() => '0.0.1';

  @override
  CIMUser userFromMap(Map<String, dynamic> map) {
    var login = map[loginKey];
    var id = int.tryParse(map[idKey]);
    var pwrd = map[passwordKey];
    if(login == null || pwrd == null){
      return null;
    }
    id ??= 0;
    var rx = int.tryParse(map[roleKey]);
    rx ??= UserRoles.patient.index;
    var role = UserRoles.values[rx];
    return CIMUser.fromJson(id, login, pwrd, role);
  }

  @override
  void userToMap(CIMUser user, Map<String, dynamic> map) {
    map[loginKey] = user.login;
    map[passwordKey] = user.password;
    map[idKey] = user.id.toString();
    map[roleKey] = user.role.index.toString();
  }
  @override
  void doctorToMap(CIMDoctor doctor, Map<String, dynamic> map){
    var userMap = <String, dynamic>{};
    userToMap(doctor.user, userMap);
    map[userKey] = userMap;
    map[idKey] = doctor.id.toString();
    map[birthDateKey] = doctor.birthDate.toString();
    map[emailKey] = doctor.email;
    map[nameKey] = doctor.name;
    map[middleNameKey] = doctor.middleName;
    map[lastNameKey] = doctor.lastName;
    map[specialityKey] = doctor.speciality.index.toString();
  }
  @override
  CIMDoctor doctorFromMap(Map<String, dynamic> map) {
    var user = userFromMap(map[userKey]);
    if(user == null){
      return null;
    }
    var doctor = CIMDoctor(user);
    doctor.id = int.tryParse(map[idKey]);
    doctor.id ??= 0;
    doctor.birthDate = DateTime.tryParse(map[birthDateKey]);
    doctor.birthDate ??= DateTime.now();
    doctor.email = map[emailKey];
    doctor.name = map[nameKey];
    doctor.middleName = map[middleNameKey];
    doctor.lastName = map[lastNameKey];
    var sx = int.tryParse(map[specialityKey]);
    sx ??= 0;
    doctor.speciality = DoctorSpeciality.values[sx];
  }
}