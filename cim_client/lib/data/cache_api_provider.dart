import 'dart:io';
import 'package:cim_client/globals.dart';
import 'package:cim_protocol/cim_protocol.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as p;

// ignore: one_member_abstracts
abstract class ICacheProvider {
  Future<CIMErrors> checkConnection();
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

}
