
import 'dart:convert';
import 'dart:mirrors';

import 'package:cim_server_2/src/app_channel.dart';
import 'package:test/test.dart';


void main (){
  group('server test', (){
    test('test config.yaml',(){

      var classMirror = reflectClass(AppChannel);

      classMirror.metadata.forEach((metadata) {
        if (metadata.reflectee is TestAnnotation) {
          print(metadata.reflectee.name);
          print(metadata.reflectee.description);
        }
      });
      for (var v in classMirror.declarations.values) {
        if (v.metadata.isNotEmpty) {
          if(v.metadata.first.reflectee is TestAnnotation) {
            print(v.metadata.first.reflectee.name);
          }
//            print(v.metadata.first.reflectee.description);
        }
      }
    });
  });
}