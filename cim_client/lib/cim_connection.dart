import 'dart:ui';

import 'package:cim_client/globals.dart';
import 'package:get/get.dart';
import 'package:cim_protocol/cim_protocol.dart';
import 'package:get/get_connect/http/src/status/http_status.dart';
import 'package:cim_protocol/cim_protocol.dart';




class CIMConnection extends GetConnect{
//class CIMConnection{
//  GetConnect _connection = GetConnect();
  String _address = "127.0.0.1";
  String get address => _address;
  int _port = 8888;
  int get port => _port;

  CIMConnection(this._address, this._port);

  Future<CIMErrors> checkConnection () async {
    Response res;
    try {
      res = await get(CIMRestApi.prepareCheckConnection());
      switch(res.status.code) {
        case HttpStatus.ok:
          return CIMErrors.ok;
        case HttpStatus.internalServerError:
          return CIMErrors.connection_error_server_db_fault;
      }
    }catch(e){
      return CIMErrors.connection_error_server_not_found;
    }
    if(res.status.connectionError)
      return CIMErrors.connection_error_server_not_found;
    return CIMErrors.unexpected_server_response;
  }

  void init(){
    httpClient.baseUrl = "http://$address:$port";
  }

  Future <CIMErrors> authoriseUser(CIMUser user) async {
    try{
      var res = await put(CIMRestApi.prepareAuthoriseUser(), user);
      switch(res.status.code) {
        case HttpStatus.ok:
          return CIMErrors.ok;
        case HttpStatus.internalServerError:
          return CIMErrors.connection_error_server_db_fault;
        case HttpStatus.unauthorized:
          return CIMErrors.wrong_user_credentials;
      }
    } catch(e){
      return CIMErrors.connection_error_server_not_found;
    }
    return CIMErrors.unexpected_server_response;
  }

  @override
  void onInit() {
    super.onInit();
    init();
  }
}