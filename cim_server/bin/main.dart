import 'package:cim_server/cim_server.dart';

Future main() async {
  final app = Application<CimServerChannel>()
      ..options.configurationFilePath = "config.yaml"
      ..options.port = 8888
//      ..options.certificateFilePath = "assets\\certificate\\cimcert.pem"
//      ..options.privateKeyFilePath = "assets\\certificate\\cimkey.pem"
  ;

  final count = Platform.numberOfProcessors ~/ 2;
  await app.start(numberOfInstances: count > 0 ? count : 1);

  print("Application started on port: ${app.options.port}.");
  print("Use Ctrl-C (SIGINT) to stop running the application.");
}