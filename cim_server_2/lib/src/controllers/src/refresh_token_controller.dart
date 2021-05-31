/*import 'dart:async';
import 'dart:io';
import 'package:uuid/uuid.dart';
import 'package:cim_protocol/cim_protocol.dart';
import 'package:cim_server/model/cim_token.dart';

class RefreshTokenController extends Controller{
  RefreshTokenController(this.context);
  final ManagedContext context;
  @override
  FutureOr<RequestOrResponse> handle(Request request) async {
    try {
      var authString = request.raw.headers[HttpHeaders.authorizationHeader].toString();
      authString = authString.toLowerCase();
      final list = authString.split(' ');
      if(list == null || list.length != 2){
        return Response.badRequest(body: request.body.as());
      }
      authString = list[1];
      authString = authString.replaceAll(']', '');
      var query =  Query<CIMToken>(context)
        ..where((x) => x.refresh_token).equalTo(authString);
      var token = await query.fetchOne();
      if(token == null){
        return Response.unauthorized(body: request.body.as());
      }
      query = Query<CIMToken>(context)
        ..values.token = Uuid().v4()
        ..values.expiration = DateTime.now().add(Duration(days: 1))
        ..where((x) => x.refresh_token).equalTo(authString);
      token = await query.updateOne();
      if(token == null){
        print("AuthorisationController.handle error in update");
        return Response.serverError(body: request.body.as());
      }
      final info = CIMAuthorisationInfo();
      info.token = token.token;
      info.refreshToken = token.refresh_token;
      info.expiresIn = token.expiration;
      info.username = '';
      return Response.ok(info.toMap());
    }catch(e){
      print("AuthorisationController.handle $e");
      return Response.serverError(body: {"message :" : e});
    }
  }
}*/