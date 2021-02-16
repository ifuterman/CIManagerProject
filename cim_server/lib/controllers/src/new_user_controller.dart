import 'dart:async';
import 'package:aqueduct/aqueduct.dart';
import 'package:cim_server/model/cim_user_db.dart';
import 'package:cim_protocol/cim_protocol.dart';

class NewUserController extends Controller{

  final ManagedContext context;

  NewUserController(this.context);

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
      var userDB = query.fetchOne();
      if(userDB != null){
        return Response.conflict();
      }
      query = Query<CIMUserDB>(context)
        ..values.username = user.login
        ..values.pwrd = user.password;
      var newDBUser = await query.insert();
      if(newDBUser == null) {
        return Response.conflict();
      }
      user = CIMUser(newDBUser.username, newDBUser.pwrd);
      user.id = newDBUser.id;
      packet = CIMPacket.makePacket();
      if(!packet.addInstance(user)){
        return Response.serverError(body : {"message" : "add instance problem"});
      }
      return Response.ok(packet.map);
    }catch(e) { return Response.serverError(body : {"message" : e.toString()});}
    return Response.serverError(body : {"message" : "Unimplemented error"});
  }
}