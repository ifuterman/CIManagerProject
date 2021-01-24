import 'package:get/get.dart';
import 'package:cim_protocol/cim_protocol.dart';
import 'package:get/get_connect/http/src/status/http_status.dart';




class CIMConnection extends GetConnect{
//class CIMConnection{
//  GetConnect _connection = GetConnect();
  String _address = "127.0.0.1";
  String get address => _address;
  int _port = 8888;
  int get port => _port;

  CIMConnection(this._address, this._port);

  Future<int> checkConnection () async {
    try {
      var res = await get(CIMRestApi.prepareCheckConnection());
      switch(res.status.code) {
        case HttpStatus.ok:
          return 0;
        case HttpStatus.internalServerError:
          return 101;
      }
    }catch(e){
      return 100;
    }
    return 100;
  }

  void init(){
    httpClient.baseUrl = "http://$address:$port";
  }

  @override
  void onInit() {
    super.onInit();
    init();
  }
}