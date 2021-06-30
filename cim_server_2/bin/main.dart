import 'package:cim_server_2/src/app_channel.dart';
import 'package:cim_server_2/config/server_configuration.dart';
import 'package:cim_server_2/http/http.dart';

void main(List<String> args) async {
  var config = ServerConfiguration;
  var server = Server<AppChannel>(config.host, config.port);
  await server.start(timeout: Duration(seconds: 120));

}