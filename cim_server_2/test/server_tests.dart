import 'dart:mirrors';

import 'package:cim_server_2/src/http/application_channel.dart';
import 'package:test/test.dart';
import 'package:cim_server_2/src/config/server_configuration.dart';


void main (){
  group('server test', (){
    test('test config.yaml',(){
      Type t;
      var classMirror = reflectClass(ApplicationChannel);
    });
  });
}