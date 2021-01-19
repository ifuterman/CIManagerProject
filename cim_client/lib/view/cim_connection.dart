import 'package:get/get.dart';
import 'package:http/http.dart' as http;

/*enum CIMRESTAPI{

}*/



class CIMConnection extends GetConnect{
  String address = "127.0.0.1";
  int port = 8888;
  bool _connected = false;

  bool get isConnected => _connected;
  bool connect() {
    var res = checkConnection();
//    Response<bool> r = await client.get("checkConnection");
//    _connected = ;
    return isConnected;
  }

  void x(Response<dynamic> val){
    int i = 0;
    i++;
  }

  Future<Response> checkConnection () async {

   var res = await get("/checkConnection");
//    GetSocket my_socket = GetSocket("http://$address:$port");
//    await my_socket.connect();

//    final res = await get("/checkConnection");
//    var url = "http://127.0.0.1:8888/checkConnection";
//    var response = await http.get(url);

    return res;
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