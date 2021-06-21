import 'package:cim_protocol/cim_protocol.dart';
import 'package:cim_server_2/src/model/cim_user_db.dart';
import 'package:cim_server_2/src/orm/orm.dart';
import 'package:cim_server_2/src/http/http.dart';

class UserGetController extends Controller {
  UserGetController(this.connection);
  final Connection connection;

  @override
  Future<RequestOrResponse> handle(Request request) async{
    try{
      final usersQuery = Query<CIMUserDB>(connection);
      final usersList = await usersQuery.select();
      if(usersList.isEmpty){
        return Response.noContent();
      }
      var packet = CIMPacket.makePacket();
      if(packet == null){
        return Response.internalServerError(body: Body.fromMap(request.body.asJsonMap()));
      }
      for(var user in usersList){
        var u = user.toUser();
        packet.addInstance(u);
      }
      return Response.ok(body: Body.fromMap(packet.map));
    }catch(e) {
      return Response.internalServerError(body: Body.fromMap({'message': e}));
    }
  }
}