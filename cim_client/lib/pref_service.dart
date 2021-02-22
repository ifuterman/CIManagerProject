import 'package:cim_client/cim_service.dart';
import 'package:cim_client/shared/funcs.dart';
import 'package:cim_protocol/cim_protocol.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

///
class PreferenceService extends GetxService {

  static const prefix = 'preference';
  static const isDarkModeKey = '$prefix.dark_mode';
  static const langIndexKey = '$prefix.lang_index';
  static const lastUserKey = '$prefix.last_user';

  Future<PreferenceService> init() async => this;
  
  final langIndex$ = 0.obs;
  final isDarkMode$ = false.obs;

  GetStorage _storage;

  void setLangIndex(int index) {
    _storage.write(langIndexKey, index);
    langIndex$(_storage.read(langIndexKey) ?? 0);
  }

  void setDarkMode(bool value) {
    _storage.write(isDarkModeKey, value);
    isDarkMode$(_storage.read(isDarkModeKey) as bool ?? false);
    print('$now: PreferenceService.setDarkMode: ${isDarkMode$.value}');
  }

  void switchDarkMode() {
    setDarkMode(!isDarkMode$.value);
  }

  CIMUser getUser() {
    return UserMapper.fromJson(_storage.read(lastUserKey) ?? '');
  }

  void setUser(CIMUser user) {
    _storage.write(lastUserKey, user != null ? UserMapper.toJson(user) : null);
  }

  @override
  void onReady() {
    super.onReady();
    _storage = GetStorage();
    langIndex$(_storage.read(langIndexKey) ?? 0);
    delayMilli(1000).then((value) {
      isDarkMode$(_storage.read(isDarkModeKey) as bool ?? false);
      print('$now: PreferenceService.onReady: ${isDarkMode$.value}');
    });
  }
}