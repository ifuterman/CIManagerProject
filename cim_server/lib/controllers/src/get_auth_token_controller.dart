import 'dart:async';
import 'dart:core';
import 'package:aqueduct/aqueduct.dart';
import 'package:uuid/uuid.dart';
import 'package:cim_protocol/cim_protocol.dart';
import 'package:cim_server/model/cim_user_db.dart';
import 'package:cim_server/model/cim_token.dart';

class GetAuthTokenController extends Controller{
  GetAuthTokenController(this.context);
  final ManagedContext context;

  @override
  FutureOr<RequestOrResponse> handle(Request request) async {
    await request.body.decode();
    try {
      final packet = CIMPacket.makePacketFromMap(request.body.as());
      if(packet == null){
        return Response.badRequest();
      }
      final list = packet.getInstances();
      if(list == null || list.isEmpty){
        return Response.badRequest();
      }

      if(list[0] is! CIMUser){
        return Response.badRequest();
      }
      final user = list[0] as CIMUser;
      var query = Query<CIMUserDB>(context)
        ..where((x) => x.username).equalTo(user.login)
        ..where((x) => x.pwrd).equalTo(user.password);
      final userDB = await query.fetchOne();
      if(userDB == null ){
        print("if(userDB == null )");
        query = Query<CIMUserDB>(context);
        final list = await query.fetch();
        if(list.isEmpty) {
          return Response.noContent();
        }
        return Response.unauthorized();
      }
      var tokenQuery = Query<CIMToken>(context)
        ..where((x) => x.users_id).equalTo(userDB.id);
      var token = await tokenQuery.fetchOne();
      var info = null;
      if(token != null){
        tokenQuery = Query<CIMToken>(context)
          ..values.expiration = DateTime.now().add(Duration(days: 1))
          ..where((x) => x.token).equalTo(token.token);
        token = await tokenQuery.updateOne();
      }
      else{
        tokenQuery = Query<CIMToken>(context)
          ..values.users_id = userDB.id
          ..values.expiration = DateTime.now().add(Duration(days: 1))
          ..values.token = Uuid().v4()
          ..values.refresh_token = Uuid().v4()
        ;
        token = await tokenQuery.insert();
      }
      info = CIMAuthorisationInfo();
      info.token = token.token;
      info.refreshToken = token.refresh_token;
      info.username = user.login;
      info.expiresIn = token.expiration;
      return Response.ok(info.toMap());
    }catch(e){
      print("GetAuthToken.handle $e");
      return Response.serverError();
    }
  }
}