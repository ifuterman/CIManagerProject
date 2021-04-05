import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import 'package:cim_protocol/cim_protocol.dart';
import 'package:vfx_flutter_common/utils.dart';

import '../cim_errors.dart';

// ignore: one_member_abstracts
abstract class DataProvider {
  Future<Boolean<CIMErrors>> checkConnection();
}

class DataProviderImpl extends GetConnect implements DataProvider {
  static const _address = "127.0.0.1";
  static const _port = 8888;

  @override
  Future<Boolean<CIMErrors>> checkConnection() async{
    debugPrint('$now: DataProviderImpl.checkConnection');
    Response res;
    try {
      res = await get(CIMRestApi.prepareCheckConnection());
      // debugPrint('$now: DataProviderImpl.checkConnection');
      // debugPrint('$now: DataProviderImpl.checkConnection: '
      //     '${res.statusCode} / ${res.body}');
      debugPrint(
          '$now: DataProviderImpl.checkConnection ${res.statusCode} / ${res.body}');
      switch (res.status.code) {
        case HttpStatus.ok:
          return True(data: CIMErrors.ok);
        case HttpStatus.internalServerError:
          return False(data: CIMErrors.connectionErrorServerDbFault);
      }
    } catch (e) {
      debugPrint('$now: DataProviderImpl.checkConnection: e = $e');
      return False(data: CIMErrors.connectionErrorServerNotFound,
          description: e.toString());
    }
    if (res.status.connectionError)
      return False(data: CIMErrors.connectionErrorServerNotFound);
    return False(data: CIMErrors.unexpectedServerResponse);
  }

  @override
  void onInit() {
    httpClient.baseUrl = "http://$_address:$_port";
  }


}
