import 'dart:io';
import 'package:cim_server3/src/controllers/controllers.dart';
import 'package:liquidart/liquidart.dart';
import 'package:liquidart/src/http/controller.dart';
import 'package:cim_protocol/cim_protocol.dart';

import 'app_configuration.dart';

class ServerApp extends ApplicationChannel{
  late ManagedContext context;
  @override
  Future prepare() async{
    final config = AppConfiguration.fromFile(File(options!.configurationFilePath!));
    final db = config.database;
    final persistentStore = PostgreSQLPersistentStore.fromConnectionInfo(db.username, db.password, db.host, db.port, db.databaseName);
    context = ManagedContext(ManagedDataModel.fromCurrentMirrorSystem(), persistentStore);
  }

  @override
  Controller get entryPoint{
    final router = Router(notFoundHandler: (request) async => Response.notFound());

    router.route(CIMRestApi.prepareCheckConnection())
        .link(() => CheckConnectionController(context));
    return router;
  }
}

class stub extends ResourceController{
  @Operation.get()
  Future<Response> handler() async {
    return Response.ok('body');
  }
}