import 'dart:async';
import 'package:cim_server_2/src/model/cim_token.dart';
import 'package:cim_server_2/src/orm/orm.dart';
import 'package:cim_server_2/src/http/http.dart';
import 'package:cim_server_2/src/model/cim_user_db.dart';
import 'package:cim_server_2/src/model/cim_doctor_db.dart';

class DebugCleanDBController extends Controller{
  DebugCleanDBController(this.connection);
  final Connection connection;

  @override
  Future<RequestOrResponse> handle(Request request) async{
    try{
      final userQuery = Query<CIMUserDB>(connection);
      await userQuery.delete();
      final doctorsQuery = Query<CIMDoctorDB>(connection);
      await doctorsQuery.delete();
      final tokensQuery = Query<CIMToken>(connection);
      await tokensQuery.delete();
      return Response.ok(body: Body.fromMap({'message' : 'Users, Doctors, Tokens is deleted'}));
    }catch(e){
      return Response.internalServerError(body: Body.fromMap({'message' : e.toString()}));
    }
  }
}