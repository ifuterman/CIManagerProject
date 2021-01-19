import 'package:postgres/postgres.dart';

import 'cim_server.dart';
import 'dart:core';
import 'package:cim_model/src/CIMUser.dart';


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

    return router;
  }
}

class CheckConnectionController extends Controller{
  final ManagedContext context;
  CheckConnectionController(this.context);
  @override
  FutureOr<RequestOrResponse> handle(Request request)  async {
    var res = await context.persistentStore.execute("select f_check_connection();");
/*    final connection = PostgreSQLConnection("45.86.183.142", 5432, "cim_database",password: "cimtestserver", username: "cimserver");
    await connection.open();
    var res = await connection.query("SELECT 1");

  //  final ps = PostgreSQLPersistentStore.fromConnectionInfo("cimserver","cimtestserver", "45.86.183.142", 5432, "cim_database");
    //final res = Future.sync(() => ps.execute("SELECT 1"));
    /*Future<dynamic> result = context.persistentStore.execute("select f_check_connection();");
    result.then((value) {
      f = true;
      });*/
*/
//    final res = Future.sync(() => context.persistentStore.execute("SELECT 1"));
//    res.then((value) => foo);
    return Response.ok("true");
  }
  void foo(var val){
    int x = 0;
  }
}