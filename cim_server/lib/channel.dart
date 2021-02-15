import 'dart:core';
import 'package:cim_protocol/cim_protocol.dart';
import 'package:cim_server/model/cim_token.dart';
import 'cim_server.dart';
import 'controllers/controllers.dart';
import 'model/cim_user_db.dart';



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
  FutureOr<RequestOrResponse> handle(Request request) async {
    try {
      await request.body.decode();
      var packet = CIMPacket.makePacketFromMap(request.body.as());
      final list = packet.getInstances();
      if(list == null || list.isEmpty){
        return Response.badRequest(headers: {"reason" : "No instances found"});
      }
      var user = list[0] as CIMUser;
      var query = Query<CIMUserDB>(context)
        ..where((x) => x.username).equalTo(user.login);
      var userDB = query.fetchOne();
      if(userDB != null){
        return Response.conflict();
      }
      query = Query<CIMUserDB>(context)
        ..values.username = user.login
        ..values.pwrd = user.password;
      var newDBUser = await query.insert();
      if(newDBUser == null) {
        return Response.conflict();
      }
      user = CIMUser(newDBUser.username, newDBUser.pwrd);
      user.id = newDBUser.id;
      packet = CIMPacket.makePacket();
      if(!packet.addInstance(user)){
        return Response.serverError(body : {"message" : "add instance problem"});
      }
      return Response.ok(packet.map);
    }catch(e) { return Response.serverError(body : {"message" : e.toString()});}
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