import 'dart:async';
import 'package:cim_server/cim_server.dart';
import 'package:cim_server/model/cim_doctor_db.dart';
import 'package:cim_server/model/cim_user_db.dart';

class DebugCleanDBController extends Controller{
  DebugCleanDBController(this.context);
  final ManagedContext context;

  @override
  FutureOr<RequestOrResponse> handle(Request request) async{
    try{
      final userQuery = Query<CIMUserDB>(context);
      userQuery.canModifyAllInstances = true;
      await userQuery.delete();
      final doctorsQuery = Query<CIMDoctorDB>(context);
      doctorsQuery.canModifyAllInstances = true;
      await doctorsQuery.delete();
      return Response.ok({"message" : "Users, Tokens is deleted"});
    }catch(e){
      return Response.serverError(body: {"message" : e.toString()});
    }
  }
}