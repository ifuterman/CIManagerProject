import 'package:get/get.dart';

/*enum CIMRESTAPI{

}*/



class CIMConnection extends GetConnect{

  String address = "http://localhost";
  int port = 8888;
  bool _connected = false;

  bool get isConnected => _connected;
  bool connect() {
    var res = checkConnection();
    res.then((value) => x(value));

//    Response<bool> r = await client.get("checkConnection");
//    _connected = ;
    return isConnected;
  }

  void x(Response<dynamic> val){
    int i = 0;
    i++;
  }

  Future<Response> checkConnection () async => await httpClient.get("http://$address:$port/checkConnection");


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
    httpClient.baseUrl = "http://$address:$port";
    httpClient.userAgent ='cim_client';
  }
}