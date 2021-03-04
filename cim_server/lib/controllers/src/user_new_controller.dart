import 'dart:async';
import 'package:aqueduct/aqueduct.dart';
import 'package:cim_server/model/cim_user_db.dart';
import 'package:cim_protocol/cim_protocol.dart';

class UserNewController extends Controller{

  UserNewController(this.context);
  final ManagedContext context;

  @override
  FutureOr<RequestOrResponse> handle(Request request) async {
    try {
      await request.body.decode();
      var packet = CIMPacket.makePacketFromMap(request.body.as());
      final list = packet.getInstances();
      if(list == null || list.isEmpty){
        return Response.badRequest(headers: {"reason" : "No instances found"});
      }
      var user = list[0] as CIMUser;
      var query = Query<CIMUserDB>(context)
        ..where((x) => x.username).equalTo(user.login);
      var userDBlist = await query.fetch();
      if(userDBlist != null && userDBlist.isNotEmpty){
        return Response.conflict();
      }
      query = Query<CIMUserDB>(context)
        ..values.username = user.login
        ..values.pwrd = user.password
        ..values.role = user.role.index;
      var newDBUser = await query.insert();
      if(newDBUser == null) {
        return Response.conflict();
      }
      user = newDBUser.toUser();
      packet = CIMPacket.makePacket();
      if(!packet.addInstance(user)){
        return Response.serverError(body : {"message" : "add instance problem"});
      }
      return Response.ok(packet.map);
    }catch(e) { return Response.serverError(body : {"message" : e.toString()});}
  }
}