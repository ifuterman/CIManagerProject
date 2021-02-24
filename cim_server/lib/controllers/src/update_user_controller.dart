import 'package:cim_protocol/cim_protocol.dart';
import 'package:cim_server/cim_server.dart';
import 'package:cim_server/model/cim_user_db.dart';

class UpdateUserController extends Controller{
  UpdateUserController(this.context);
  final ManagedContext context;
  @override
  FutureOr<RequestOrResponse> handle(Request request) async{
    try{
      await request.body.decode();
      var packet = CIMPacket.makePacketFromMap(request.body.as());
      if(packet == null){
        return Response.badRequest(body: request.body);
      }
      final list = packet.getInstances();
      if(list == null || list.isEmpty || list[0] is! CIMUser){
        return Response.badRequest(body: request.body);
      }
      var user = list[0] as CIMUser;
      final query = Query<CIMUserDB>(context)
        ..values.username = user.login
        ..values.pwrd = user.password
        ..where((x) => x.username).equalTo(user.login);
      final userDB = await query.updateOne();
      if(userDB == null){
        return Response.conflict();
      }
      user = userDB.toUser();
      packet = CIMPacket.makePacket();
      if(!packet.addInstance(user)){
        return Response.serverError(body: {"message" : "Instance not created"});
      }
      return Response.ok(packet.map);
    }catch(e) {
      return Response.serverError(body: {"message": e});
    }
  }
}