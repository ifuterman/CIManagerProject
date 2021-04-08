import 'package:cim_client/cim_service.dart';
import 'package:cim_client/data/cache_provider.dart';
import 'package:cim_protocol/cim_protocol.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:vfx_flutter_common/utils.dart';

///
class PreferenceService extends GetxService {

  static const prefix = 'preference';
  static const isDarkModeKey = '$prefix.dark_mode';
  static const langIndexKey = '$prefix.lang_index';
  static const lastUserKey = '$prefix.last_user';

  PreferenceService(this._cache);

  Future<PreferenceService> init() async => this;
  
  final langIndex$ = 0.obs;
  final isDarkMode$ = false.obs;

  final CacheProviderService? _cache;

  void setLangIndex(int index) {
    _cache?.storage?.write(langIndexKey, index);
    langIndex$(_cache?.storage?.read(langIndexKey) ?? 0);
  }

  void setDarkMode(bool value) {
    _cache?.storage?.write(isDarkModeKey, value);
    isDarkMode$(_cache?.storage?.read(isDarkModeKey) as bool ?? false);
    print('$now: PreferenceService.setDarkMode: ${isDarkMode$.value}');
  }

  void switchDarkMode() {
    setDarkMode(!isDarkMode$.value);
  }

  CIMUser? getUser() {
    return UserMapper.fromJson(_cache?.storage?.read(lastUserKey) ?? '');
  }

  void setUser(CIMUser user) {
    _cache?.storage?.write(lastUserKey, user != null ? UserMapper.toJson(user) : null);
  }

  @override
  void onReady() {
    super.onReady();
    // _storage = Get.find<CacheProviderService>();
    langIndex$(_cache?.storage?.read(langIndexKey) ?? 0);
    delayMilli(1000).then((value) {
      isDarkMode$(_cache?.storage?.read(isDarkModeKey) ?? false);
      print('$now: PreferenceService.onReady: ${isDarkMode$.value}');
    });
  }
}