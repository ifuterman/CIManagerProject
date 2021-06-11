import 'dart:convert';
import 'dart:io';

import 'package:cim_client/cim_errors.dart';
import 'package:cim_client/data/cache_provider.dart';
import 'package:cim_protocol/cim_protocol.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:vfx_flutter_common/utils.dart';

// ignore: one_member_abstracts
abstract class DataProvider {
  Future<CIMErrors> checkConnection();

  Future<CIMErrors> cleanDb();

  Future<Return<CIMErrors, Map<String, dynamic>>> getToken(CIMUser candidate);

  Future<Return<CIMErrors, CIMUser>> createFirstUser(CIMUser candidate);

  Future<Return<CIMErrors, CIMUser>> createNewUser(CIMUser candidate);

  Future<Return<CIMErrors, CIMPatient>> createPatient(CIMPatient candidate);

  Future<Return<CIMErrors, List<CIMPatient>>> getUsers();

  Future<Return<CIMErrors, CIMUser>> getUserInfo();
}

class DataProviderImpl extends GetConnect implements DataProvider {
  static const _address = "127.0.0.1";
  static const _port = 8888;

  @override
  Future<CIMErrors> checkConnection() async {
    Response res;
    try {
      res = await get(CIMRestApi.prepareCheckConnection());
      debugPrint('$now: DataProviderImpl.checkConnection: res = $res');
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
    // httpClient.baseUrl = "http://$_address:$_port";
    httpClient.baseUrl = 'https://torexo-core.apddev.ru/api';
  }

  @override
  Future<Return<CIMErrors, CIMUser>> createFirstUser(CIMUser candidate) async {

    var url = Uri.parse('http://$_address:$_port/test');

    final packet = CIMPacket.makePacket();
    packet?.addInstance(candidate);
    print('Response status.url.1: ${url}');
    // "instances": <Map<String, dynamic>>[
    // {
    // "instance": "CIMUser",
    // "login": "qq",
    // "password": "222",
    // "id": 0,
    // "role": "UserRoles.administrator"
    // }
    // ]
    final body = <String, dynamic>{
      "instance": "CIMUser",
      "login": "qq",
    };
/*    print('Response status.body.1: ${body}');
    print('Response status.body.rt.1: ${body.runtimeType}');*/
    /*var client = new HttpClient();
    client.postUrl(url)
        .then((HttpClientRequest request) {
          request.headers.contentType = ContentType.json;
          request.write(packet!.map);
      return request.close();
    })
        .then((HttpClientResponse response) async{
      print('Response status: ${response.statusCode}');
      var list = await response.first;
      print('Response body: $list');
    });*/
    try {
      var response = await http.post(
          url,
          body: jsonEncode(packet!.map),
      );
      // var response = await http.post(url, body: {"login": "frostyland@yandex.ru"});
      print('Response status.2: ${response.statusCode}');
      print('Response body.2 ${response.body}');
    } catch (e) {
      print('Response body.ERROR ${e}');
    }

    return Return(
        result: CIMErrors.ok,
        description: 'OKOKOK');

    Response res;
    try {
      debugPrint(
          '$now: DataProviderImpl.createFirstUser: ${candidate.login} / ${candidate.password}');
      final packet = CIMPacket.makePacket();
      packet?.addInstance(candidate);
      final _cacheProvider = Get.find<CacheProviderService>();
      final token = _cacheProvider.fetchToken();
      final tokenStr = 'Bearer ${token}';
      final String authKey = 'Authorization';
      // final authorisation = {authKey: tokenStr};
      // debugPrint('$now: DataProviderImpl.createFirstUser: authorisation = $authorisation');
      debugPrint('$now: DataProviderImpl.createFirstUser.000: ${packet?.map}');
      res = await post(
        CIMRestApi.prepareFirstUser(),
        packet?.map,
      );

      debugPrint(
          '$now: DataProviderImpl.createFirstUser: '
              'STATUS: ${res.statusCode} / BODY ${res.body} / '
              'ALL ${res.status} / ALL2 ${res.status.code}');

      switch (res.status.code) {
        case HttpStatus.ok:
          final data = res.body;
          debugPrint('$now: DataProviderImpl.createFirstUser: OK: data.1 = $data');
          final packet = CIMPacket.makePacketFromMap(data);
          debugPrint('$now: DataProviderImpl.createFirstUser: OK: data.2 = $packet');
          final user = packet?.getInstances()?[0] as CIMUser;
          debugPrint('$now: DataProviderImpl.createFirstUser: OK: data.3 = $user');
          return Return(result: CIMErrors.ok, data: user);
        case HttpStatus.internalServerError:
          debugPrint('$now: DataProviderImpl.createFirstUser: INTERNAL');
          return Return(result: CIMErrors.connectionErrorServerDbFault);
        default:
          debugPrint('$now: DataProviderImpl.createFirstUser: UNEXPECTED');
          return Return(result: CIMErrors.unexpectedServerResponse);
      }
    } catch (e) {
      debugPrint('$now: DataProviderImpl.createFirstUser: EEEEEE');
      return Return(
          result: CIMErrors.unexpectedServerResponse,
          description: e.toString());
    }
  }

  @override
  Future<Return<CIMErrors, List<CIMPatient>>> getUsers() async {
    Response res;
    try {
      final _cacheProvider = Get.find<CacheProviderService>();
      final token = _cacheProvider.fetchToken();
      final tokenStr = 'Bearer ${token}';
      final String authKey = 'Authorization';
      final authorisation = {authKey: tokenStr};

      res = await get(
        CIMRestApi.preparePatientsGet(),
        headers: authorisation,
      );
      // debugPrint('$now: DataProviderImpl.getUsers: ${res.statusCode} / ${res.body}');
      switch (res.status.code) {
        case HttpStatus.ok:
          // await res.body.decode();
          // debugPrint('$now: DataProviderImpl.getUsers.packet.1: ${res.body}');
          final packet = CIMPacket.makePacketFromMap(res.body);
          // debugPrint('$now: DataProviderImpl.getUsers.packet: ${packet}');
          final list = packet?.getInstances()?.cast<CIMPatient>();
          // debugPrint('$now: DataProviderImpl.getUsers.list: ${list}');
          return Return(result: CIMErrors.ok, data: list!);

        case HttpStatus.internalServerError:
          return Return(result: CIMErrors.connectionErrorServerDbFault);
        default:
          return Return(result: CIMErrors.unexpectedServerResponse);
      }
    } catch (e) {
      return Return(
          result: CIMErrors.unexpectedServerResponse,
          description: e.toString());
    }
  }

  @override
  Future<Return<CIMErrors, Map<String, dynamic>>> getToken(
      CIMUser candidate) async {
    debugPrint('$now: DataProviderImpl.getToken: !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');

    Response res;
    try {
      final packet = CIMPacket.makePacket();
      packet?.addInstance(candidate);
      res = await post(CIMRestApi.prepareAuthToken(), packet?.map);
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
      return Return(
          result: CIMErrors.unexpectedServerResponse,
          description: e.toString());
    }
  }

  @override
  Future<Return<CIMErrors, CIMUser>> createNewUser(CIMUser candidate) async {
    Response res;
    try {
      final packet = CIMPacket.makePacket();
      packet?.addInstance(candidate);

      final _cacheProvider = Get.find<CacheProviderService>();
      final token = _cacheProvider.fetchToken();
      final tokenStr = 'Bearer ${token}';
      final String authKey = 'Authorization';
      final authorisation = {authKey: tokenStr};
      res = await post(
        CIMRestApi.prepareNewUser(),
        packet?.map,
        headers: authorisation,
      );
      switch (res.status.code) {
        case HttpStatus.ok:
          final data = res.body;
          final packet = CIMPacket.makePacketFromMap(data);
          final user = packet?.getInstances()?[0] as CIMUser;
          return Return(result: CIMErrors.ok, data: user);
        case HttpStatus.internalServerError:
          return Return(result: CIMErrors.connectionErrorServerDbFault);
        default:
          return Return(result: CIMErrors.unexpectedServerResponse);
      }
    } catch (e) {
      // TODO(vvk): сделать ошибку типа  unknownError(e)
      return Return(
          result: CIMErrors.unexpectedServerResponse,
          description: e.toString());
    }
  }

  @override
  Future<Return<CIMErrors, CIMPatient>> createPatient(
      CIMPatient candidate) async {
    Response res;
    try {
      final packet = CIMPacket.makePacket();
      packet?.addInstance(candidate);
      final _cacheProvider = Get.find<CacheProviderService>();
      final token = _cacheProvider.fetchToken();
      final tokenStr = 'Bearer ${token}';
      final String authKey = 'Authorization';
      final authorisation = {authKey: tokenStr};



      res = await post(
        CIMRestApi.preparePatientsNew(),
        packet!.map,
        headers: authorisation,
      );
      debugPrint(
          '$now: DataProviderImpl.createPatient: ${res.statusCode} / ${res.body}');
      switch (res.status.code) {
        case HttpStatus.ok:
          final data = res.body;
          final packet = CIMPacket.makePacketFromMap(data);
          final user = packet!.getInstances()![0] as CIMPatient;
          return Return(result: CIMErrors.ok, data: user);
        case HttpStatus.internalServerError:
          return Return(result: CIMErrors.connectionErrorServerDbFault);
        default:
          return Return(result: CIMErrors.unexpectedServerResponse);
      }
    } catch (e) {
      // TODO(vvk): сделать ошибку типа  unknownError(e)
      return Return(
          result: CIMErrors.unexpectedServerResponse,
          description: e.toString());
    }
  }

  @override
  Future<Return<CIMErrors, CIMUser>> getUserInfo() async {
    Response res;
    try {
      res = await get(CIMRestApi.prepareGetUser());
      debugPrint(
          '$now: DataProviderImpl.getUserInfo ${res.statusCode} / ${res.body}');
      switch (res.status.code) {
        case HttpStatus.ok:
          final data = res.body;
          final packet = CIMPacket.makePacketFromMap(data);
          final user = packet!.getInstances()![0] as CIMUser;
          return Return(result: CIMErrors.ok, data: user);
        case HttpStatus.internalServerError:
          return Return(result: CIMErrors.connectionErrorServerDbFault);
        default:
          return Return(result: CIMErrors.unexpectedServerResponse);
      }
    } catch (e) {
      return Return(
          result: CIMErrors.unexpectedServerResponse,
          description: e.toString());
    }
  }

  @override
  Future<CIMErrors> cleanDb() async {

    // var url = Uri.parse('https://torexo-core.apddev.ru/api/code');
    var url = Uri.parse('http://$_address:$_port/debug/clean_db');
    print('Response status.1: ${url}');
    var response = await http.post(url, body: {'body': 'shmody'});
    // var response = await http.post(url, body: {"login": "frostyland@yandex.ru"});
    print('Response status.1: ${response.statusCode}');
    print('Response body.1: ${response.body}');

    return CIMErrors.ok;

    Response res;
    try {
      debugPrint('$now: DataProviderImpl.cleanDb.torexo');
      res = await post('/code', {"login": "frostyland@yandex.ru"});
      // res = await post(CIMRestApi.prepareDebugCleanDB(), {});
      debugPrint(
          '$now: DataProviderImpl.cleanDb ${res.statusCode} / ${res.body}');
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
