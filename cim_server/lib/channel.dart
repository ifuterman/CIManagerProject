import 'dart:core';
import 'package:cim_protocol/cim_protocol.dart';
import 'model/cim_user_db.dart';

import 'cim_server.dart';


//////////////////////////////////cim_appuser2021
/// This type initializes an application.
///
/// Override methods in this class to set up routes and initialize services like
/// database connections. See http://aqueduct.io/docs/http/channel/.
class CimServerChannel extends ApplicationChannel {
  ManagedContext context;

/*  @override
  SecurityContext get securityContext {
    return SecurityContext()
      ..usePrivateKey("assets\\certificate\\cimkey.pem")
        ..useCertificateChain("assets\\certificate\\cimcert.pem");
//      ..usePrivateKey("assets\\certificate\\cimcert.pem")

    //      ..options.certificateFilePath = "assets\\certificate\\cimcert.pem"
//      ..options.privateKeyFilePath = "assets\\certificate\\cimkey.pem"
  }*/

  /// Initialize services in this method.
  ///
  /// Implement this method to initialize services, read values from [options]
  /// and any other initialization required before constructing [entryPoint].
  ///
  /// This method is invoked prior to [entryPoint] being accessed.
  @override
  Future prepare() async {
    logger.onRecord.listen((rec) => print("$rec ${rec.error ?? ""} ${rec.stackTrace ?? ""}"));
    var dataModel = ManagedDataModel.fromCurrentMirrorSystem();
    var psc = PostgreSQLPersistentStore.fromConnectionInfo("cimserver","cimtestserver", "45.86.183.142", 5432, "cim_database");
    context = ManagedContext(dataModel, psc);
//    int x = await context.persistentStore.schemaVersion;
  }

  /// Construct the request channel.
  ///
  /// Return an instance of some [Controller] that will be the initial receiver
  /// of all [Request]s.
  ///
  /// This method is invoked after [prepare].
  @override
  Controller get entryPoint {
    final router = Router();

    // Prefer to use `link` instead of `linkFunction`.
    // See: https://aqueduct.io/docs/http/request_controller/

    router//
      .route("checkConnection")
      .link(() => CheckConnectionController(context));

    router//Request token
        .route("auth/token")
    .link(() => GetAuthTokenController(context));

    router//Refresh token
        .route("auth/refresh_token")
        .link(() => RefreshTokenController(context));

    router
    .route("user/new")
    .link(() => AuthorisationController(context))
    .link(() => NewUserController(context));

    router
        .route("user/update")
        .link(() => AuthorisationController(context))
        .link(() => UpdateUserController(context));

    router
        .route("user/delete")
        .link(() => AuthorisationController(context))
        .link(() => DeleteUserController(context));

    router
        .route("user/get")
        .link(() => AuthorisationController(context))
        .link(() => GetUserController(context));

    return router;
  }
}

class AuthorisationController extends Controller{
  AuthorisationController(this.context);
  final ManagedContext context;

  @override
  FutureOr<RequestOrResponse> handle(Request request) async{
    await request.body.decode();
    try {
      var packet = CIMPacket.makePacketFromMap(request.body.as());
      var list = packet.getInstances();
      if(list == null || list.isEmpty) {
        return Response.unauthorized();
      }
      if(!(list[0] is CIMUser)){
        return Response.unauthorized();
      }
      var user = list[0] as CIMUser;
      var query = Query<CIMUserDB>(context)..where((x) => x.username).equalTo(user.login)..where((x) => x.pwrd).equalTo(user.password);
      final users = await query.fetch();
      if(users.isEmpty)
        return Response.unauthorized();
      return request;
    }catch(e){
      print("AuthorisationController.handle $e");
      return Response.serverError();
    }
  }
}

class CheckConnectionController extends Controller{
  CheckConnectionController(this.context);
  final ManagedContext context;
  @override
  FutureOr<RequestOrResponse> handle(Request request)  async {
    try {
      await context.persistentStore.execute(
          "select f_check_connection();");
      return Response.ok("true");
    }catch(e){
      return Response.serverError();
    }

    /*var func = context.persistentStore.execute("select f_check_connection();");
    var res = Future.sync(() => func);
    res.then((value) => Response.ok(""));*/
  }
}

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
      return Response.ok("token");
      return Response.ok("");
    }catch(e){
      print("GetAuthToken.handle $e");
      return Response.serverError();
    }
  }
}

class RefreshTokenController extends Controller{
  RefreshTokenController(this.context);
  final ManagedContext context;
  @override
  FutureOr<RequestOrResponse> handle(Request request) {
    return Response.serverError(body : {"message" : "Unimplemented error"});
  }

}

class NewUserController extends Controller{

  final ManagedContext context;

  NewUserController(this.context);

  @override
  FutureOr<RequestOrResponse> handle(Request request) {
    return Response.serverError(body : {"message" : "Unimplemented error"});
  }
}

class UpdateUserController extends Controller{
  final ManagedContext context;

  UpdateUserController(this.context);

  @override
  FutureOr<RequestOrResponse> handle(Request request) {
    return Response.serverError(body : {"message" : "Unimplemented error"});
  }
}

class DeleteUserController extends Controller{

  DeleteUserController(this.context);
  final ManagedContext context;

  @override
  FutureOr<RequestOrResponse> handle(Request request) {
    return Response.serverError(body : {"message" : "Unimplemented error"});
  }
}

class GetUserController extends Controller{
  GetUserController(this.context);
  final ManagedContext context;

  @override
  FutureOr<RequestOrResponse> handle(Request request) {
    return Response.serverError(body : {"message" : "Unimplemented error"});
  }
}