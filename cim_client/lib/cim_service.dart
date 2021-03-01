import 'dart:convert';

import 'package:cim_client/shared/constants.dart';
import 'package:cim_client/shared/funcs.dart';
import 'package:cim_protocol/cim_protocol.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart' hide Trans;
import 'package:get_storage/get_storage.dart';

import 'cim_connection.dart';
import 'cim_data_provider.dart';

enum CIMViews { authorisationView, connectionView, mainView }

enum UserMode {first, admin}

class CIMService extends GetxService {
  CIMService() {
    debugPrint('$now: CIMService.CIMService');
  }

  CIMConnection connection;
  CIMUser user;
  final userMode$ = Rx<UserMode>(UserMode.first);
  Rx<CIMViews> currentView;
  CIMDataProvider dataProvider;

  Future<CIMService> init() async => this;

  @override
  void onInit() {
    super.onInit();
    debugPrint('$now: CIMService.onInit');
    connection =
        Get.put(CIMConnection(AppConst.defaultAddress, AppConst.defaultPort));
    currentView = Rx(CIMViews.authorisationView);
    //user = CIMUser("", "");
    _restoreUser();
  }

  @override
  void onReady() {
    super.onReady();
    debugPrint('$now: CIMService.onReady');
  }

  void _restoreUser() {
    const userKey = 'user';

    final store = GetStorage();
    user = UserMapper.fromJson(store.read(userKey) ?? '');
    if(user == null) {
      userMode$(UserMode.first);
    }else{
      userMode$(UserMode.admin);
    }
  }
}


// TODO(vvk): Перенести в протокол?
// TODO(vvk): Изменить класс в протоколе (optional parameters, etc)
/// Mapper for [CIMUser]
abstract class UserMapper {

  static const loginKey = 'login';
  static const passwordKey = 'password';
  static const roleKey = 'role';

  static CIMUser fromJson(String json){
    assert(json != null);
    try{
      print('$now: UserMapper.fromJson: $json');
      return fromMap(jsonDecode(json));
    }catch(e){
      return null;
    }
  }

  static CIMUser fromMap(Map<String, dynamic> map) {
    try{
      print('$now: UserMapper.fromMap: $map');
      final lst = (map['instances'] as List).cast<Map<String, dynamic>>();
      final e = lst[0];
      return CIMUser(
        e[loginKey] as String,
        e[passwordKey] as String,
      );
    }catch(e){
      return null;
    }
  }

  static String toJson(CIMUser user){
    assert(user != null);
    return jsonEncode(toMap(user));
  }

  static Map<String, dynamic> toMap(CIMUser user) {
    return <String, dynamic>{
      "version" : "0.0.1",
      "instances" : [
        {
          "instance" : "CIMUser",
          "login" : "admin_again",
          "password" : "admin_again",
          "id" : "0",
          "role" : "0"
        }
      ],
      // loginKey: user.login,
      // passwordKey: user.password,
    };
  }

}
