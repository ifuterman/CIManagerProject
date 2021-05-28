import 'dart:async';
import 'dart:io';
import 'package:cim_server_2/src/model/cim_token.dart';
import 'package:cim_server_2/src/orm/orm.dart';
import 'package:cim_server_2/src/http/http.dart';

class AuthorisationController extends Controller{
  static const bearerKey = 'bearer';
  AuthorisationController(this.connection);
  final Connection connection;

  @override
  Future<RequestOrResponse> handle(Request request) async{
    try {
      var authString = request.headers[HttpHeaders.authorizationHeader].toString();
      authString = authString.toLowerCase();
      final list = authString.split(' ');
      if(list.length != 2){
        return Response.badRequest();
      }
      authString = list[1];
      authString = authString.replaceAll(']', '');
      final query =  Query<CIMToken>(connection)
        ..where((x) => x.token).equalTo(authString);
      final token = await query.selectOne();
      if(token == null){
        return Response.unauthorized();
      }
      if(token.expiration!.isAfter(DateTime.now().add(Duration(days: 1)))){
        return Response.forbidden();
      }
      return request;
    }catch(e){
      print('AuthorisationController.handle $e');
      return Response.internalServerError(body: Body.fromMap({"message" : e}));
    }
  }
}