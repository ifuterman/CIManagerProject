import 'package:get/get.dart';
import 'package:cim_protocol/cim_protocol.dart';
import 'package:get/get_connect/http/src/status/http_status.dart';




//class CIMConnection extends GetConnect{
class CIMConnection{
  GetConnect _connection = GetConnect();
  String _address = "127.0.0.1";

  String get address => _address;

  set address(String value) {
    if(!_connection.isClosed)
      _connection.dispose();
    _address = value;
    init();
  }

  int _port = 8888;

  int get port => _port;

  set port(int value) {
    _port = value;
    init();
  }

  bool _connected = false;
  bool get isConnected => _connected;
  Future<int> connect() async {
    int res = await checkConnection();
    _connected = res == 0 ? true : false;
    return res;
  }

  Future<int> checkConnection () async {
    try {
      var res = await _connection.get(CIMRestApi.prepareCheckConnection());
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
    init();
  }

  void init() {
    _connected = false;
    if(!_connection.isClosed)
      _connection.dispose();
    _connection = GetConnect();
    _connection.httpClient.baseUrl = "http://$address:$port";
    _connection.$configureLifeCycle();
//    httpClient.userAgent ='cim_client';
  }
}