import 'dart:async';

import 'package:cim_protocol/cim_protocol.dart';
import 'package:cim_server/cim_server.dart';
import 'package:cim_server/model/cim_user_db.dart';

class FirstUserController extends Controller{
  FirstUserController(this.context);
  final ManagedContext context;
  @override
  FutureOr<RequestOrResponse> handle (Request request) async{
    try{
      await request.body.decode();
      var packet = CIMPacket.makePacketFromMap(request.body.as());
      if(packet == null){
        return Response.badRequest();
      }
      final list = packet.getInstances();
      if(list == null || list.isEmpty || list[0] is! CIMUser){
        return Response.badRequest();
      }
      var user = list[0] as CIMUser;
      var query = Query<CIMUserDB>(context);
      final test = await query.fetch();
      if(test != null && test.isNotEmpty){
        return Response.forbidden();
      }
      query = Query<CIMUserDB>(context)
        ..values.username = user.login
        ..values.pwrd = user.password;
      final userDB = await query.insert();
      user = userDB.toUser();
      packet = CIMPacket.makePacket();
      if(!packet.addInstance(user)){
        return Response.serverError();
      }
      return Response.ok(packet.map);
    }
    catch(e){
      print("AuthorisationController.handle $e");
      return Response.serverError();
    }
  }

}