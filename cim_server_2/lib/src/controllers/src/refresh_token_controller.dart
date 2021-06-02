import 'dart:async';
import 'dart:io';
import 'package:uuid/uuid.dart';
import 'package:cim_protocol/cim_protocol.dart';
import 'package:cim_server_2/src/model/cim_token.dart';
import 'package:cim_server_2/src/orm/orm.dart';
import 'package:cim_server_2/src/http/http.dart';

class RefreshTokenController extends Controller{
  RefreshTokenController(this.connection);
  final Connection connection;
  @override
  Future<RequestOrResponse> handle(Request request) async {
    try {
      var authString = request.headers[HttpHeaders.authorizationHeader].toString();
      authString = authString.toLowerCase();
      final list = authString.split(' ');
      if(list.length != 2){
        return Response.badRequest(body: Body.fromMap(request.body.asJsonMap()));
      }
      authString = list[1];
      authString = authString.replaceAll(']', '');
      var query =  Query<CIMToken>(connection)
        ..where((x) => x.refresh_token).equalTo(authString);
      var token = await query.selectOne();
      if(token == null){
        return Response.unauthorized(body: Body.fromMap(request.body.asJsonMap()));
      }
      query = Query<CIMToken>(connection)
        ..values.token = Uuid().v4()
        ..values.expiration = DateTime.now().add(Duration(days: 1))
        ..where((x) => x.refresh_token).equalTo(authString);
      token = await query.updateOne();
      if(token == null){
        print('AuthorisationController.handle error in update');
        return Response.internalServerError(body: Body.fromMap(request.body.asJsonMap()));
      }
      final info = CIMAuthorisationInfo();
      info.token = token.token!;
      info.refreshToken = token.refresh_token!;
      info.expiresIn = token.expiration;
      info.username = '';
      return Response.ok(body: Body.fromMap(info.toMap()));
    }catch(e){
      print('AuthorisationController.handle $e');
      return Response.internalServerError(body: Body.fromMap({'message :' : e}));
    }
  }
}