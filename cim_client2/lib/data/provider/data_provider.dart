import 'dart:io';
import 'package:get/get.dart';

import 'package:cim_protocol/cim_protocol.dart';

import '../cim_errors.dart';

// ignore: one_member_abstracts
abstract class DataProvider {
  Future<CIMErrors> checkConnection();
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


}
