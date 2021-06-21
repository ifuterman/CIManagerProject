
import 'package:cim_protocol/cim_protocol.dart';
import 'package:cim_server_2/src/controllers/controllers.dart';
import 'package:cim_server_2/src/http/http.dart';

import 'config/server_configuration.dart';
import 'controllers/src/test_endpoint_controller.dart';
import 'orm/orm.dart';


class AppChannel extends ApplicationChannel{
  late Connection dbConnection;
  @override
  void prepare() async{
    var config = ServerConfiguration;
    dbConnection = Connection(config.database_host, config.database_port,
        config.database_dbname, username: config.database_username, password: config.database_password);
    await dbConnection.open();
  }
  @override
  Router getEndpoint() {
    var router = Router();
    router.route('test').link(() => TestEnpointController(dbConnection));
    router.route(CIMRestApi.prepareAuthToken())
        .link(() => GetAuthTokenController(dbConnection));
    router.route(CIMRestApi.prepareCheckConnection())
        .link(() => CheckConnectionController(dbConnection));
    router.route(CIMRestApi.prepareDebugDeleteUsers())
        .link(() => DebugDeleteUsersController(dbConnection));
    router.route(CIMRestApi.prepareDebugCleanDB())
        .link(() => DebugCleanDBController(dbConnection));
    router.route(CIMRestApi.prepareFirstUser())
        .link(() => UserFirstController(dbConnection));
    router.route(CIMRestApi.prepareRefreshToken())
        .link(() => RefreshTokenController(dbConnection));
    router.route(CIMRestApi.prepareNewUser())
        .link(() => AuthorisationController(dbConnection))
        .link(() => CheckRoleController(dbConnection))
        .link(() => UserNewController(dbConnection));
    router.route(CIMRestApi.prepareGetUser())
        .link(() => AuthorisationController(dbConnection))
        .link(() => CheckRoleController(dbConnection))
        .link(() => UserGetController(dbConnection));
    router.route(CIMRestApi.prepareUpdateUser())
        .link(() => AuthorisationController(dbConnection))
        .link(() => CheckRoleController(dbConnection))
        .link(() => UserUpdateController(dbConnection));
    router.route(CIMRestApi.prepareDoctorDelete())
        .link(() => AuthorisationController(dbConnection))
        .link(() => CheckRoleController(dbConnection))
        .link(() => DoctorDeleteController(dbConnection));
    router.route(CIMRestApi.prepareDoctorNew())
        .link(() => AuthorisationController(dbConnection))
        .link(() => CheckRoleController(dbConnection))
        .link(() => DoctorNewController(dbConnection));
    router.route(CIMRestApi.prepareDoctorGet())
        .link(() => AuthorisationController(dbConnection))
        .link(() => CheckRoleController(dbConnection))
        .link(() => DoctorGetController(dbConnection));
    router.route(CIMRestApi.prepareDoctorUpdate())
        .link(() => AuthorisationController(dbConnection))
        .link(() => CheckRoleController(dbConnection))
        .link(() => DoctorUpdateController(dbConnection));
    return router;
  }
  @override
  void finalise() {
    dbConnection.close();
  }
}