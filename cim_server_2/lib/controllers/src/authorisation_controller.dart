import 'dart:async';
import 'dart:io';
import 'package:cim_server_2/model/cim_token.dart';
import 'package:cim_server_2/orm/orm.dart';
import 'package:cim_server_2/http/http.dart';

class AuthorisationController extends Controller{
  static const bearerKey = 'bearer';
  AuthorisationController(this.connection);
  final Connection connection;

  @override
  Future<RequestOrResponse> handle(Request request) async{
    try {
      var header = request.headers[HttpHeaders.authorizationHeader];
      if(header == null){
        return Response.unauthorized(body: Body.fromMap({'message' : 'Header \'authorization\' is missed'}));
      }
      var authString = header.toString();
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
      if(token.expiration!.isBefore(DateTime.now())){
        return Response.forbidden();
      }
      return request;
    }catch(e){
      print('AuthorisationController.handle $e');
      return Response.internalServerError(body: Body.fromMap({'message' : e}));
    }
  }
}