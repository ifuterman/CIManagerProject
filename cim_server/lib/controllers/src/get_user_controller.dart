import 'package:cim_protocol/cim_protocol.dart';
import 'package:cim_server/cim_server.dart';
import 'package:cim_server/model/cim_user_db.dart';

class GetUserController extends Controller {
  GetUserController(this.context);
  final ManagedContext context;

  @override
  FutureOr<RequestOrResponse> handle(Request request) async{
    try{
      final usersQuery = Query<CIMUserDB>(context);
      usersQuery.canModifyAllInstances = true;
      final usersList = await usersQuery.fetch();
      if(usersList == null || usersList.isEmpty){
        return Response.noContent();
      }
      var packet = CIMPacket.makePacket();
      if(packet == null){
        return Response.serverError(body: request.body);
      }
      for(var user in usersList){
        var u = user.toUser();
        packet.addInstance(u);
      }
      return Response.ok(packet.map);
    }catch(e) {
      return Response.serverError(body: {"message": e});
    }
  }
}