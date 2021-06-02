import 'dart:async';
import 'dart:core';
import 'package:uuid/uuid.dart';
import 'package:cim_protocol/cim_protocol.dart';
import 'package:cim_server_2/src/model/cim_user_db.dart';
import 'package:cim_server_2/src/model/cim_token.dart';
import 'package:cim_server_2/src/orm/orm.dart';
import 'package:cim_server_2/src/http/http.dart';

class GetAuthTokenController extends Controller{
  GetAuthTokenController(this.connection);
  final Connection connection;

  @override
  Future<RequestOrResponse> handle(Request request) async {
    try {
      final packet = CIMPacket.makePacketFromMap(request.body.asJsonMap());
      if(packet == null){
        return Response.badRequest(body: Body.fromMap(request.body.asJsonMap()));
      }
      final list = packet.getInstances();
      if(list == null || list.isEmpty){
        return Response.badRequest(body: Body.fromMap(request.body.asJsonMap()));
      }

      if(list[0] is! CIMUser){
        return Response.badRequest(body: Body.fromMap(request.body.asJsonMap()));
      }
      final user = list[0] as CIMUser;
      var query = Query<CIMUserDB>(connection)
        ..where((x) => x.username).equalTo(user.login)
        ..where((x) => x.pwrd).equalTo(user.password);
      final userDB = await query.selectOne();
      if(userDB == null ){
        print('if(userDB == null )');
        query = Query<CIMUserDB>(connection);
        final list = await query.select();
        if(list.isEmpty) {
          return Response.noContent();
        }
        return Response.unauthorized(body: Body.fromMap(request.body.asJsonMap()));
      }
      var tokenQuery = Query<CIMToken>(connection)
        ..where((x) => x.users_id).equalTo(userDB.id);
      var token = await tokenQuery.selectOne();
      CIMAuthorisationInfo info;
      if(token != null){
        tokenQuery = Query<CIMToken>(connection)
          ..values.expiration = DateTime.now().add(Duration(days: 1))
          ..where((x) => x.token).equalTo(token.token);
        token = await tokenQuery.updateOne();
      }
      else{
        tokenQuery = Query<CIMToken>(connection)
          ..values.users_id = userDB.id
          ..values.expiration = DateTime.now().add(Duration(days: 1))
          ..values.token = Uuid().v4()
          ..values.refresh_token = Uuid().v4()
        ;
        token = await tokenQuery.insertOne();
      }
      if(token == null){
        return Response.internalServerError(body: Body.fromMap({'message' : 'Token not created'}));
      }
      info = CIMAuthorisationInfo();
      info.token = token.token!;
      info.refreshToken = token.refresh_token!;
      info.username = user.login;
      info.expiresIn = token.expiration;
//      info.role = userDB.getRole();
      info.role = userDB.role;
      return Response.ok(body: Body.fromMap(info.toMap()));
    }catch(e){
      print('GetAuthToken.handle $e');
      return Response.internalServerError(body: Body.fromMap({'message :' : e}));
    }
  }
}