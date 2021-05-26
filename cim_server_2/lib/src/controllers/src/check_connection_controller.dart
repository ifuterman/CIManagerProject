import 'dart:async';

import 'package:cim_server_2/src/http/http.dart';
import 'package:cim_server_2/src/orm/orm.dart';

class CheckConnectionController extends Controller{
  CheckConnectionController(this.connection);
  final Connection connection;
  @override
  Future<RequestOrResponse> handle(Request request)  async{
    try {
       await connection.query('select f_check_connection()');
      return Response.ok();
    }catch(e){
      return Response.internalServerError();
    }
  }
}