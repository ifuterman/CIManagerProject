
import 'dart:convert';

import 'package:test/test.dart';


void main (){
  group('server test', (){
    test('test config.yaml',(){
      var codec = JsonCodec();
      var str = '''
   {
    "version" : "0.0.1",
    "instances" : [
        {
            "instance" : "CIMUser",
            "login" : "admin1",
            "password" : "admin",
            "id" : "0",
            "role" : "0"
        }
    ]
}
      ''';
      dynamic obj = codec.decoder.convert(str);
      print(obj);
    });
  });
}