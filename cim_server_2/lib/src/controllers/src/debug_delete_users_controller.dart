import 'package:cim_server_2/src/model/cim_user_db.dart';
import 'package:cim_server_2/src/orm/orm.dart';
import 'package:cim_server_2/src/http/http.dart';

class DebugDeleteUsersController extends Controller{
  DebugDeleteUsersController(this.connection);
  final Connection connection;

  @override
  Future<RequestOrResponse> handle(Request request) async{
    try{
      final userQuery = Query<CIMUserDB>(connection);
      await userQuery.delete();
      return Response.ok(body: Body.fromMap({'message' : 'Users is deleted'}));
    }catch(e){
      return Response.internalServerError(body: Body.fromMap({'message' : e.toString()}));
    }
  }
}