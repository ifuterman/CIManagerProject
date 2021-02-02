import 'dart:core';
import 'package:cim_model/cim_model.dart';
import 'package:postgres/postgres.dart';

import 'cim_server.dart';


//////////////////////////////////cim_appuser2021
/// This type initializes an application.
///
/// Override methods in this class to set up routes and initialize services like
/// database connections. See http://aqueduct.io/docs/http/channel/.
class CimServerChannel extends ApplicationChannel {
  ManagedContext context;

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
    router
      .route("/example")
      .linkFunction((request) async {
        return Response.ok({"key": "value"});
      });

    router
      .route("checkConnection")
      .link(() => CheckConnectionController(context));

    router
        .route("auth/token")
    .link(() => GetAuthToken(context));

    return router;
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

class GetAuthToken extends Controller{
  GetAuthToken(this.context);
  final ManagedContext context;

  @override
  FutureOr<RequestOrResponse> handle(Request request) async {
    var x = request.body;
    return Response.ok("token");
  }
}