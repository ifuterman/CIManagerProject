
import 'package:cim_protocol/src/cim_user.dart';

import 'cim_json_mapper.dart';

class CIMJsonMapper_0_0_1 extends CIMJsonMapper{
  final String loginKey = 'login';
  final String passwordKey = 'password';
  final String idKey = 'id';

  @override
  String getVersion() => '0.0.1';

  @override
  CIMUser userFromMap(Map<String, String> map) {
    var login = map[loginKey];
    var id = int.tryParse(map[idKey]);
    if(login == null || id == null){
      return null;
    }
    return CIMUser.fromJson(id, login, '');
  }

  @override
  void userToMap(CIMUser user, Map<String, String> map) {
    map[loginKey] = user.login;
    map[passwordKey] = user.password;
    map[idKey] = user.id.toString();
  }
}