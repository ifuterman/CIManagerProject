
//import 'package:cim_client/http_client/src/http_client.dart';
import 'dart:io';

import 'package:cim_protocol/cim_protocol.dart';
import 'package:flutter_test/flutter_test.dart';

void main (){
  test('HasNoSense test', () async {
    try {
      var packet = CIMPacket.makePacket();
      var user = CIMUser('admin', 'admin');
      packet!.addInstance(user);
      var client = HttpClient();
      var request = await client.post('127.0.0.1', 8888, 'user/first');
      request.write(packet.map);
      var response = await request.close();
      var result = await response.first;
      print(result);
    }
    catch(e){
      print(e);
    }
 /*   try {
      HttpClient client = HttpClient('127.0.0.1', 8888);
      var packet = CIMPacket.makePacket();
      var user = CIMUser('admin', 'admin');
      packet!.addInstance(user);
      var request = Request.json(packet.map);
      print('time:${DateTime.now()}');
      var response = await client.post(CIMRestApi.prepareFirstUser(), request);
      print('time:${DateTime.now()}');
      print(response.toString());
    }catch(e){
      print('$e');
    }*/
  });
}