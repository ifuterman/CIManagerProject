import 'dart:io';
import 'package:cim_client/cim_service.dart';
import 'package:cim_client/globals.dart';
import 'package:cim_client/shared/funcs.dart';
import 'package:cim_client/shared/return.dart';
import 'package:cim_protocol/cim_protocol.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as p;

// ignore: one_member_abstracts
abstract class ICacheProvider {
  Future<CIMErrors> checkConnection();
  Future<CIMErrors> cleanDb();
  Future<Return<CIMErrors, Map<String, String>>> getToken(CIMUser candidate);
  Future<Return<CIMErrors, CIMUser>> createFirstUser(CIMUser candidate);
  Future<Return<CIMErrors, CIMUser>> createNewUser(CIMUser candidate);
}

class CacheProvider extends GetConnect implements ICacheProvider {
  static const _address = "127.0.0.1";
  static const _port = 8888;

  @override
  Future<CIMErrors> checkConnection() async{
    Response res;
    try {
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
      print('$now: CacheProvider.createFirstUser: packet = ${packet}');
      packet.addInstance(candidate);
      print('$now: CacheProvider.createFirstUser: packet.1 = ${packet}');
      // final body = UserMapper.toJson(candidate);
      print('$now: CacheProvider.createFirstUser: body = ${packet.map}');
      res = await post(CIMRestApi.prepareFirstUser(), packet.map);
      switch (res.status.code) {
        case HttpStatus.ok:
          final data = res.body;
          print('$now: CacheProvider.createFirstUser: data = $data, ${data.runtimeType}');
          final packet = CIMPacket.makePacketFromMap(data);
          print('$now: CacheProvider.createFirstUser: packetBack = $packet');
          final user = packet.getInstances()[0] as CIMUser;
          return Return(result: CIMErrors.ok, data: user);
        case HttpStatus.internalServerError:
          print('$now: CacheProvider.createFirstUser: internalServerError');
          return Return(result: CIMErrors.connectionErrorServerDbFault);
        default:
          return Return(result: CIMErrors.unexpectedServerResponse);
      }
    } catch (e) {
      return Return(result: CIMErrors.unexpectedServerResponse, description: e.toString());
    }
  }

  @override
  Future<Return<CIMErrors, Map<String, String>>> getToken(CIMUser candidate) async {
    Response res;
    try {
      final packet = CIMPacket.makePacket();
      packet.addInstance(candidate);
      res = await post(CIMRestApi.prepareNewUser(), packet.map);
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
      return Return(result: CIMErrors.unexpectedServerResponse, description: e.toString());
    }
  }

  @override
  Future<Return<CIMErrors, CIMUser>> createNewUser(CIMUser candidate) async {
    Response res;
    try {
      final packet = CIMPacket.makePacket();
      packet.addInstance(candidate);
      res = await post(CIMRestApi.prepareNewUser(), packet.map);
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
