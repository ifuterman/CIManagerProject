import 'package:cim_protocol/cim_protocol.dart';
import 'package:cim_server_2/model/cim_user_db.dart';
import 'package:cim_server_2/orm/orm.dart';
import 'package:cim_server_2/http/http.dart';

class UserUpdateController extends Controller{
  UserUpdateController(this.connection);
  final Connection connection;
  @override
  Future<RequestOrResponse> handle(Request request) async{
    try{
      var packet = CIMPacket.makePacketFromMap(request.body.asJsonMap());
      if(packet == null){
        return Response.badRequest(body: Body.fromMap(request.body.asJsonMap()));
      }
      final list = packet.getInstances();
      if(list == null || list.isEmpty || list[0] is! CIMUser){
        return Response.badRequest(body: Body.fromMap(request.body.asJsonMap()));
      }
      var user = list[0] as CIMUser;
      final query = Query<CIMUserDB>(connection)
        ..values.username = user.login
        ..values.pwrd = user.password
        ..where((x) => x.username).equalTo(user.login);
      final userDB = await query.updateOne();
      if(userDB == null){
        return Response.conflict();
      }
      user = userDB.toUser();
      packet = CIMPacket.makePacket();
      if(packet == null){
        return Response.internalServerError(body: Body.fromMap({'message' : 'Can`t create packet'}));
      }
      if(!packet.addInstance(user)){
        return Response.internalServerError(body: Body.fromMap({'message' : 'Instance not created'}));
      }
      return Response.ok(body: Body.fromMap(packet.map));
    }catch(e) {
      return Response.internalServerError(body: Body.fromMap({'message': e}));
    }
  }
}