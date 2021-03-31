import 'dart:io';

import 'package:cim_client/cim_errors.dart';
import 'package:cim_client/data/cache_provider.dart';
import 'package:cim_protocol/cim_protocol.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:vfx_flutter_common/utils.dart';

// ignore: one_member_abstracts
abstract class DataProvider {
  Future<CIMErrors> checkConnection();
  Future<CIMErrors> cleanDb();
  Future<Return<CIMErrors, Map<String, dynamic>>> getToken(CIMUser candidate);
  Future<Return<CIMErrors, CIMUser>> createFirstUser(CIMUser candidate);
  Future<Return<CIMErrors, CIMUser>> createNewUser(CIMUser candidate);
  Future<Return<CIMErrors, List<CIMPatient>>> getUsers();
  Future<Return<CIMErrors, CIMUser>> getUserInfo();
}

class DataProviderImpl extends GetConnect implements DataProvider {
  static const _address = "127.0.0.1";
  static const _port = 8888;

  @override
  Future<CIMErrors> checkConnection() async{
    Response res;
    try {
      print('DataProviderImpl.checkConnection');
      res = await get(CIMRestApi.prepareCheckConnection());
      switch (res.status.code) {
        case HttpStatus.ok:
          return CIMErrors.ok;
        case HttpStatus.internalServerError:
          return CIMErrors.connectionErrorServerDbFault;
      }
    } catch (e) {
      return CIMErrors.connectionErrorServerNotFound;
    }
    if (res.status.connectionError)
      return CIMErrors.connectionErrorServerNotFound;
    return CIMErrors.unexpectedServerResponse;
  }

  @override
  void onInit() {
    httpClient.baseUrl = "http://$_address:$_port";
  }

  @override
  Future<Return<CIMErrors, CIMUser>> createFirstUser(CIMUser candidate) async {
    Response res;
    try {
      final packet = CIMPacket.makePacket();
      packet.addInstance(candidate);
      final _cacheProvider = Get.find<CacheProvider>();
      final token = _cacheProvider.fetchToken();
      final tokenStr = 'Bearer ${token}';
      final String authKey = 'Authorization';
      final authorisation = {authKey : tokenStr};
      res = await post(
        CIMRestApi.prepareFirstUser(),
        packet.map,
        headers: authorisation,
      );

      debugPrint('$now: DataProviderImpl.createFirstUser: ${res.statusCode} / ${res.body}');

      switch (res.status.code) {
        case HttpStatus.ok:
          final data = res.body;
          final packet = CIMPacket.makePacketFromMap(data);
          final user = packet.getInstances()[0] as CIMUser;
          return Return(result: CIMErrors.ok, data: user);
        case HttpStatus.internalServerError:
          return Return(result: CIMErrors.connectionErrorServerDbFault);
        default:
          return Return(result: CIMErrors.unexpectedServerResponse);
      }
    } catch (e) {
      return Return(result: CIMErrors.unexpectedServerResponse, description: e.toString());
    }
  }

  @override
  Future<Return<CIMErrors, List<CIMPatient>>> getUsers() async {
    Response res;
    try {

      final _cacheProvider = Get.find<CacheProvider>();
      final token = _cacheProvider.fetchToken();
      final tokenStr = 'Bearer ${token}';
      final String authKey = 'Authorization';
      final authorisation = {authKey : tokenStr};

      res = await get(
          CIMRestApi.preparePatientsGet(),
        headers: authorisation,
      );
      debugPrint('$now: DataProviderImpl.getUsers: ${res.statusCode} / ${res.body}');
      switch (res.status.code) {
        case HttpStatus.ok:
          // await res.body.decode();
          debugPrint('$now: DataProviderImpl.getUsers.packet.1: ${res.body}');
          final packet = CIMPacket.makePacketFromMap(res.body);
          debugPrint('$now: DataProviderImpl.getUsers.packet: ${packet}');
          final list = packet.getInstances().cast<CIMPatient>();
          debugPrint('$now: DataProviderImpl.getUsers.list: ${list}');
          return Return(result: CIMErrors.ok, data: list);

        case HttpStatus.internalServerError:
          return Return(result: CIMErrors.connectionErrorServerDbFault);
        default:
          return Return(result: CIMErrors.unexpectedServerResponse);
      }
    } catch (e) {
      return Return(result: CIMErrors.unexpectedServerResponse, description: e.toString());
    }
  }

  @override
  Future<Return<CIMErrors, Map<String, dynamic>>> getToken(CIMUser candidate) async {
    Response res;
    try {
      final packet = CIMPacket.makePacket();
      packet.addInstance(candidate);
      res = await post(CIMRestApi.prepareAuthToken(), packet.map);
      switch (res.status.code) {
        case HttpStatus.ok:
          final map = res.body as Map<String, dynamic>;
          return Return(result: CIMErrors.ok, data: map);
        case HttpStatus.internalServerError:
          return Return(result: CIMErrors.connectionErrorServerDbFault);
        default:
          return Return(result: CIMErrors.unexpectedServerResponse);
      }
    } catch (e) {
      // TODO(vvk): сделать ошибку типа  unknownError(e)
      print('$now: DataProviderImpl.getToken: ERROR $e');
      return Return(result: CIMErrors.unexpectedServerResponse, description: e.toString());
    }
  }

  @override
  Future<Return<CIMErrors, CIMUser>> createNewUser(CIMUser candidate) async {
    Response res;
    try {
      final packet = CIMPacket.makePacket();
      packet.addInstance(candidate);


      final _cacheProvider = Get.find<CacheProvider>();
      final token = _cacheProvider.fetchToken();
      final tokenStr = 'Bearer ${token}';
      final String authKey = 'Authorization';
      final authorisation = {authKey : tokenStr};
      res = await post(
        CIMRestApi.prepareNewUser(),
        packet.map,
        headers: authorisation,
      );
      debugPrint('$now: DataProviderImpl.createFirstUser: ${res.statusCode} / ${res.body}');
      switch (res.status.code) {
        case HttpStatus.ok:
          final data = res.body;
          final packet = CIMPacket.makePacketFromMap(data);
          final user = packet.getInstances()[0] as CIMUser;
          return Return(result: CIMErrors.ok, data: user);
        case HttpStatus.internalServerError:
          return Return(result: CIMErrors.connectionErrorServerDbFault);
        default:
          return Return(result: CIMErrors.unexpectedServerResponse);
      }
    } catch (e) {
      // TODO(vvk): сделать ошибку типа  unknownError(e)
      return Return(result: CIMErrors.unexpectedServerResponse, description: e.toString());
    }
  }

  @override
  Future<Return<CIMErrors, CIMUser>> getUserInfo() async {
    Response res;
    try {
      res = await get(CIMRestApi.prepareGetUser());
      switch (res.status.code) {
        case HttpStatus.ok:
          final data = res.body;
          final packet = CIMPacket.makePacketFromMap(data);
          final user = packet.getInstances()[0] as CIMUser;
          return Return(result: CIMErrors.ok, data: user);
        case HttpStatus.internalServerError:
          return Return(result: CIMErrors.connectionErrorServerDbFault);
        default:
          return Return(result: CIMErrors.unexpectedServerResponse);
      }
    } catch (e) {
      return Return(result: CIMErrors.unexpectedServerResponse, description: e.toString());
    }
  }

  @override
  Future<CIMErrors> cleanDb() async{
    Response res;
    try {
      res = await get(CIMRestApi.prepareDebugCleanDB());
      switch (res.status.code) {
        case HttpStatus.ok:
          return CIMErrors.ok;
        case HttpStatus.internalServerError:
          return CIMErrors.connectionErrorServerDbFault;
      }
    } catch (e) {
      return CIMErrors.connectionErrorServerNotFound;
    }
    if (res.status.connectionError)
      return CIMErrors.connectionErrorServerNotFound;
    return CIMErrors.unexpectedServerResponse;
  }

}
