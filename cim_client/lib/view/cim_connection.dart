import 'package:get/get.dart';
import 'package:cim_protocol/cim_protocol.dart';
import 'package:get/get_connect/http/src/status/http_status.dart';




class CIMConnection extends GetConnect{
  String address = "127.0.0.1";
  int port = 8888;
  bool _connected = false;
  bool get isConnected => _connected;
  Future<int> connect() async {
    int res = await checkConnection();
    _connected = res == 0 ? true : false;
    return res;
  }

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


  CIMConnection(){
    super.$configureLifeCycle();
    _connected = false;
  }
  CIMConnection.fromAddress(this.address, this.port) {
    super.$configureLifeCycle();
    _connected = false;
  }

  @override
  void onInit() {
    super.onInit();
    httpClient.baseUrl = "http://$address:$port";
//    httpClient.userAgent ='cim_client';
  }
}