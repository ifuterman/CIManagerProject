import 'dart:io';

import 'package:cim_server_2/src/http/src/response.dart';
import 'package:cim_server_2/src/model/cim_token.dart';
import 'package:cim_server_2/src/model/cim_user_db.dart';
import 'package:cim_protocol/cim_protocol.dart';
import 'package:cim_server_2/src/http/http.dart';
import 'package:cim_server_2/src/orm/orm.dart';

class CheckRoleController extends Controller{
  CheckRoleController(this.connection);
  final Connection connection;

  @override
  Future<RequestOrResponse> handle(Request request) async{
    try {
      var token = request.headers[HttpHeaders.authorizationHeader]
          .toString();
      final list = token.split(' ');
      if(list.length != 2){
        return Response.badRequest();
      }
      token = list[1];
      token = token.replaceAll(']', '');
      final queryToken = Query<CIMToken>(connection)
        ..where((x) => x.token).equalTo(token);
      final tokenObj = await queryToken.selectOne();
      if(tokenObj == null){
        return Response.conflict(body: Body.fromMap({'message' : 'More then one or no one token founded'}));
      }
      final queryUser = Query<CIMUserDB>(connection)
        ..where((x) => x.id).equalTo(tokenObj.users_id);
      final user = await queryUser.selectOne();
      if(user == null){
        return Response.conflict(body: Body.fromMap({'message' : 'More then one or no one user not founded'}));
      }
      final role = user
          .toUser()
          .role;
      if (role == UserRoles.administrator) {
        return request;
      }
      if (role == UserRoles.doctor) {
        if (request.uri.pathSegments[0] == CIMRestApi.userSegmentKey || request.uri.pathSegments[0] == CIMRestApi.debugSegmentKey) {
          return Response.forbidden();
        }
        return request;
      }
    }catch(e){
      return Response.internalServerError(body: Body.fromMap({'message' : e.toString()}));
    }
    return Response.forbidden();
  }
}