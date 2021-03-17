import 'dart:io';

import 'package:cim_protocol/cim_protocol.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:vfx_flutter_common/utils.dart';

// ignore: one_member_abstracts
abstract class CacheProvider {

  GetStorage get storage;


  Future<CIMUser> fetchUser();
  Future<void> saveUser(CIMUser candidate);
  String fetchToken();
  Future<void> saveToken(String token);
}

class CacheProviderService extends GetxService implements CacheProvider {

  static const prefix = 'cache';
  static const userKey = '$prefix.user';
  static const tokenKey = '$prefix.token';

  GetStorage _storage;

  @override
  GetStorage get storage => _storage;

  Future<CacheProviderService> init() async {
    final directory = Directory.current.path;
    debugPrint('$now: CacheProviderService.init: directory = $directory');
    _storage = GetStorage('cache.data', directory);
    return this;
  }

  @override
  Future<CIMUser> fetchUser() {
    // TODO: implement fetchUser
    throw UnimplementedError();
  }

  @override
  Future<void> saveUser(CIMUser candidate) {
    // TODO: implement saveUser
    throw UnimplementedError();
  }

  @override
  String fetchToken() {
    return _storage.read(tokenKey);
  }

  @override
  Future<void> saveToken(String token) async {
    _storage.write(tokenKey, token);
  }

  @override
  void onInit() {
    super.onInit();
    print('$now: CacheProviderService.onInit');
  }

}
