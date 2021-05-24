import 'dart:io';

import 'package:cim_protocol/cim_protocol.dart';
import 'package:cim_server_2/src/controllers/check_connection_controller.dart';
import 'package:cim_server_2/src/http/application_channel.dart';
import 'package:cim_server_2/src/http/controller.dart';
import 'package:cim_server_2/src/http/request.dart';
import 'package:cim_server_2/src/http/request_or_response.dart';
import 'package:cim_server_2/src/http/response.dart';
import 'package:cim_server_2/src/http/router.dart';

import 'config/server_configuration.dart';
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
    router.route(CIMRestApi.prepareCheckConnection())
        .link(() => CheckConnectionController(dbConnection));
    return router;
  }
  @override
  void finalise() {
    dbConnection.close();
  }
}