import 'dart:io';
import 'package:cim_client/cim_service.dart';
import 'package:cim_client/globals.dart';
import 'package:cim_client/shared/funcs.dart';
import 'package:cim_client/shared/return.dart';
import 'package:cim_protocol/cim_protocol.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as p;

// ignore: one_member_abstracts
abstract class DataProvider {
  Future<CIMErrors> checkConnection();
  Future<CIMErrors> cleanDb();
  Future<Return<CIMErrors, Map<String, dynamic>>> getToken(CIMUser candidate);
  Future<Return<CIMErrors, CIMUser>> createFirstUser(CIMUser candidate);
  Future<Return<CIMErrors, CIMUser>> createNewUser(CIMUser candidate);
}

class DataProviderImpl extends GetConnect implements DataProvider {
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
      packet.addInstance(candidate);
      res = await post(CIMRestApi.prepareFirstUser(), packet.map);
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
