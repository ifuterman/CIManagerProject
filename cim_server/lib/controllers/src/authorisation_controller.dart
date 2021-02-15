import 'dart:async';
import 'dart:io';
import 'package:aqueduct/aqueduct.dart';
import 'package:cim_server/model/cim_token.dart';

class AuthorisationController extends Controller{
  static const bearerKey = 'bearer';
  AuthorisationController(this.context);
  final ManagedContext context;

  @override
  FutureOr<RequestOrResponse> handle(Request request) async{
    try {
      var authString = request.raw.headers[HttpHeaders.authorizationHeader].toString();
      authString = authString.toLowerCase();
      var list = authString.split(' ');
      if(list == null || list.length != 2){
        return Response.badRequest();
      }
      authString = list[1];
      authString = authString.replaceAll(']', '');
      final query =  Query<CIMToken>(context)
//        ..where((x) => x.token).equalTo(authString)
          ;
//      var token = await query.fetchOne();
      var x = await query.fetch();
      var token = x[0];
      if(token == null){
        return Response.unauthorized();
      }
      if(token.expiration.isAfter(DateTime.now().add(Duration(days: 1)))){
        return Response.forbidden();
      }
      return request;
    }catch(e){
      print("AuthorisationController.handle $e");
      return Response.serverError();
    }
  }
}