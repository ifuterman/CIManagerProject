import 'dart:io';
import 'package:cim_server3/src/app_configuration.dart';
import 'package:cim_server3/src/serverApp.dart';
import 'package:liquidart/liquidart.dart';


void main(List<String> arguments) async{
  var configFilePath = 'config.yaml';
  var config = AppConfiguration.fromFile(File(configFilePath));
  final app = Application<ServerApp>()
    ..options.configurationFilePath = configFilePath
    ..options.port = config.server_port
    ..options.address = config.server_host;
  final count = Platform.numberOfProcessors ~/ (Platform.numberOfProcessors / 2);
  await app.start(numberOfInstances: count > 0 ? count : 1, consoleLogging: config.console_logging);
}


