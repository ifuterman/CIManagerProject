import 'package:cim_client/globals.dart';
import 'package:cim_protocol/cim_protocol.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/status/http_status.dart';

class CIMConnection extends GetConnect {
  var _address = "127.0.0.1";

  String get address => _address;
  var _port = 8888;

  int get port => _port;

  CIMConnection(this._address, this._port);

  Future<CIMErrors> checkConnection() async {
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

  void init() {
    httpClient.baseUrl = "http://$address:$port";
  }

  Future<CIMErrors> authoriseUser(CIMUser user) async {
    try {
      var packet = CIMPacket.makePacket();
      packet.addInstance(user);
      var res = await post(CIMRestApi.prepareAuthToken(), packet.map);
      switch (res.status.code) {
        case HttpStatus.ok:
          return CIMErrors.ok;
        case HttpStatus.internalServerError:
          return CIMErrors.connectionErrorServerDbFault;
        case HttpStatus.unauthorized:
          return CIMErrors.wrongUserCredentials;
      }
    } catch (e) {
      return CIMErrors.connectionErrorServerNotFound;
    }
    return CIMErrors.unexpectedServerResponse;
  }

  @override
  void onInit() {
    super.onInit();
    init();
  }
}
