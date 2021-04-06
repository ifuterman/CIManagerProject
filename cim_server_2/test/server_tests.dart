import 'package:test/test.dart';
import 'package:cim_server_2/src/config/server_configuration.dart';


void main (){
  group('server test', (){
    test('test config.yaml',(){
      var configuration = ServerConfiguration;
      configuration.toString();
    });
  });
}