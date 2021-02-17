import 'dart:async';
import 'package:cim_server/cim_server.dart';
import 'package:cim_server/model/cim_token.dart';
import 'package:cim_server/model/cim_user_db.dart';

class DebugCleanDBController extends Controller{
  DebugCleanDBController(this.context);
  final ManagedContext context;

  @override
  FutureOr<RequestOrResponse> handle(Request request) async{
    try{
      final tokenQuery = Query<CIMToken>(context);
      tokenQuery.canModifyAllInstances = true;
      await tokenQuery.delete();
      final userQuery = Query<CIMUserDB>(context);
      userQuery.canModifyAllInstances = true;
      await userQuery.delete();
      return Response.ok({"message" : "Users, Tokens is deleted"});
    }catch(e){
      return Response.serverError(body: {"message" : e.toString()});
    }
  }
}