import 'package:cim_server/cim_server.dart';
import 'package:cim_server/model/cim_user_db.dart';

class DebugDeleteUsersController extends Controller{
  DebugDeleteUsersController(this.context);
  final ManagedContext context;

  @override
  FutureOr<RequestOrResponse> handle(Request request) async{
    try{
      final userQuery = Query<CIMUserDB>(context);
      userQuery.canModifyAllInstances = true;
      await userQuery.delete();
      return Response.ok({"message" : "Users is deleted"});
    }catch(e){
      return Response.serverError(body: {"message" : e.toString()});
    }
  }
}