import 'dart:async';
import 'package:cim_server_2/src/http/http.dart';
import 'package:cim_server_2/src/http/src/controller.dart';
import 'package:cim_server_2/src/model/cim_user_db.dart';
import 'package:cim_protocol/cim_protocol.dart';
import 'package:cim_server_2/src/orm/orm.dart';

class UserNewController extends Controller{

  UserNewController(this.connection);
  final Connection connection;

  @override
  Future<RequestOrResponse> handle(Request request) async {
    try {
      var packet = CIMPacket.makePacketFromMap(request.body.asJsonMap());
      if(packet == null){
        return Response.badRequest(body: Body.fromMap({'message' : 'Wrong packet'}));
      }
      final list = packet.getInstances();
      if(list == null || list.isEmpty){
        return Response.badRequest(body: Body.fromMap({'reason' : 'No instances found'}));
      }
      var user = list[0] as CIMUser;
      var query = Query<CIMUserDB>(connection)
        ..where((x) => x.username).equalTo(user.login);
      var userDBlist = await query.select();
      if(userDBlist.isNotEmpty){
        return Response.conflict();
      }
      query = Query<CIMUserDB>(connection)
        ..values.username = user.login
        ..values.pwrd = user.password
        ..values.role = user.role.toString();
      var result = await query.insert();
      if(result.isEmpty) {
        return Response.conflict();
      }
      user = result[0].toUser();
      packet = CIMPacket.makePacket();
      if(packet == null){
        return Response.internalServerError(body: Body.fromMap({'message' : 'Can`t made the packet'}));
      }
      if(!packet.addInstance(user)){
        return Response.internalServerError(body : Body.fromMap({"message" : "add instance problem"}));
      }
      return Response.ok(body: Body.fromMap(packet.map));
    }catch(e) { return Response.internalServerError(body : Body.fromMap({"message" : e.toString()}));}
  }
}