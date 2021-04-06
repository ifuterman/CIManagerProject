import 'dart:io';
import 'dart:isolate';

import 'package:args/args.dart';
import 'package:cim_server_2/src/config/server_configuration.dart';
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf_io.dart' as io;



void main(List<String> args) async {
/*  var parser = ArgParser()..addOption('port', abbr: 'p');
  var result = parser.parse(args);

  // For Google Cloud Run, we respect the PORT environment variable
  var portStr = result['port'] ?? Platform.environment['PORT'] ?? '8888';
  var port = int.tryParse(portStr);*/

  var receivePort = ReceivePort();
  var isolate1 = await Isolate.spawn(isolateEntryPoint, receivePort.sendPort);
  var isolate1Port = (await receivePort.first as MessageSendPort).port;
  receivePort = ReceivePort();
  var isolate2 = await Isolate.spawn(isolateEntryPoint, receivePort.sendPort);
  var isolate2Port = (await receivePort.first as MessageSendPort).port;
  var config = ServerConfiguration;
  var server = await HttpServer.bind(config.host, config.port);
  var list = List<HttpRequest>.empty(growable: true);
  var flag = true;
 await for(HttpRequest request in server) {
    if(flag) {
      isolate1Port.send(MessageHttpRequest(MyHttpRequest(request)));
      flag = false;
    }
    else{
      isolate2Port.send(MessageHttpRequest(MyHttpRequest(request)));
      flag = true;
    }
  }

}

void isolateEntryPoint(SendPort callerSendPort) async{
  var receivePort = ReceivePort();//Регистрация порта для приёмки сообщений
  callerSendPort.send(MessageSendPort(receivePort.sendPort));//Передача порта, через который будем получать сообщения
  await for(var message in receivePort){
    if(message is! Message){
      print('[isolateEntryPoint]: Wrong message type');
      continue;
    }
    switch(message.getType()){
      case MessageTypes.request:{
        handler((message as MessageHttpRequest));
        break;
      }
    }
  }
}
void handler(MessageHttpRequest) async{
  /*print('Request received ${request.uri}');
  sleep(Duration(seconds: 20));
  request.response.write('Ok');
  await request.response.close();
  print('Request completed ${request.uri}');*/
  print('Request received');
  sleep(Duration(seconds: 20));
  print('Request completed');
}
enum MessageTypes{
  empty,
  sendPort,
  request
}
abstract class Message{
  MessageTypes getType();
}

class MessageSendPort implements Message{
  SendPort port;
  MessageSendPort(this.port);
  @override
  MessageTypes getType() => MessageTypes.sendPort;
}

class MessageHttpRequest implements Message{
  MyHttpRequest request;
  MessageHttpRequest(this.request);


  @override
  MessageTypes getType() => MessageTypes.request;
}

class MyHttpRequest{
  late HttpHeaders headers;
  late String method;
  late Uri requestedUri;
  MyHttpRequest(HttpRequest request){
    headers = request.headers;
    method = request.method;
    requestedUri = request.requestedUri;
  }
}