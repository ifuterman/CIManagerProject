import 'dart:async';

import 'package:cim_protocol/cim_protocol.dart';
import 'package:cim_server_2/model/cim_user_db.dart';
import 'package:cim_server_2/orm/orm.dart';
import 'package:cim_server_2/http/http.dart';

class UserFirstController extends Controller{
  UserFirstController(this.connection);
  final Connection connection;
  @override
  Future<RequestOrResponse> handle (Request request) async{
    try{
//      return Response.ok(body: Body.fromString('str'));
      var packet = CIMPacket.makePacketFromMap(request.body.asJsonMap());
      if(packet == null){
        return Response.badRequest(body: Body.fromMap(request.body.asJsonMap()));
      }
      final list = packet.getInstances();
      if(list == null || list.isEmpty || list[0] is! CIMUser){
        return Response.badRequest(body: Body.fromMap(request.body.asJsonMap()));
      }
      var user = list[0] as CIMUser;
      var query = Query<CIMUserDB>(connection);
      final test = await query.select();
      if(test.isNotEmpty){
        return Response.forbidden(body: Body.fromMap(request.body.asJsonMap()));
      }
      query = Query<CIMUserDB>(connection)
        ..values.username = user.login
        ..values.pwrd = user.password
//        ..values.role = user.role.toString();
        ..values.role = user.role;
      final userDB = await query.insertOne();
      if(userDB == null){
        return Response.internalServerError(body: Body.fromMap({'message' : 'Can`t insert to DB'}));
      }
      user = userDB.toUser();
      packet = CIMPacket.makePacket();
      if(packet == null){
        return Response.internalServerError(body: Body.fromMap({'message' : 'Can`t create send packet'}));
      }
      if(!packet.addInstance(user)){
        return Response.internalServerError(body: Body.fromMap({'message' : 'Can`t convert user instance to packet'}));
      }
      return Response.ok(body: Body.fromMap(packet.map));
    }
    catch(e){
      return Response.internalServerError(body: Body.fromMap({'message :' : e}));
    }
  }

}