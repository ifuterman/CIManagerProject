import 'dart:core';
import 'cim_server.dart';
import 'controllers/controllers.dart';



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
        .route("debug/clean_db")
//        .link(() => AuthorisationController(context))
//        .link(() => CheckRoleController(context))
        .link(() => DebugCleanDBController(context));

    router
        .route("debug/delete_users")
//        .link(() => AuthorisationController(context))
//        .link(() => CheckRoleController(context))
        .link(() => DebugDeleteUsersController(context));

    router
        .route("doctor/new")
        .link(() => AuthorisationController(context))
        .link(() => CheckRoleController(context))
        .link(() => DoctorNewController(context));

    router
        .route("doctor/get")
        .link(() => AuthorisationController(context))
        .link(() => CheckRoleController(context))
        .link(() => DoctorGetController(context));

    router
        .route("user/new")
        .link(() => AuthorisationController(context))
        .link(() => CheckRoleController(context))
        .link(() => UserNewController(context));

    router
        .route("user/first")
        .link(() => UserFirstController(context));

    router
        .route("user/update")
        .link(() => AuthorisationController(context))
        .link(() => CheckRoleController(context))
        .link(() => UserUpdateController(context));

    router
        .route("user/delete")
        .link(() => AuthorisationController(context))
        .link(() => CheckRoleController(context))
        .link(() => UserDeleteController(context));

    router
        .route("user/get")
        .link(() => AuthorisationController(context))
        .link(() => CheckRoleController(context))
        .link(() => UserGetController(context));

    return router;
  }
}










