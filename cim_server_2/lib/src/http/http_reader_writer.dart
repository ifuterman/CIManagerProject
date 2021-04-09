import 'dart:mirrors';

import 'package:cim_server_2/src/http/application_channel.dart';

import 'messages.dart';
import 'dart:io';
import 'dart:isolate';

class HttpReaderWriter<T> {
  static SendPort? _callerPort;
  static int _id = 0;
  static void readIsolateEntryPoint<T>(MessageInitServer messageInitServer) async {
    var channelType = messageInitServer.applicationChannel;
    var mirror = reflectClass(channelType);
    var instanceMirror = mirror.newInstance(Symbol.empty, List.empty());
    var instance = instanceMirror.reflectee as ApplicationChannel;
    print(instance.xxx);
    _id = messageInitServer.id;
    var receivePort = ReceivePort(); //Регистрация порта для приёмки сообщений
    _callerPort = messageInitServer.callerPort;
    _callerPort!.send(MessageSendPort(receivePort.sendPort,
        _id)); //Передача порта, через который будем получать сообщения
    var server = await HttpServer.bind(
        messageInitServer.host, messageInitServer.serverPort);
    server.listen(requestHandler);
    _callerPort!.send(MessageServerInited(_id));
    receivePort.listen(mainProcessListener);
  }

  static void requestHandler(HttpRequest request) {
    print('[HttpRequest received: ${request.uri}]');
  }

  static void mainProcessListener(dynamic message){
    if(message is! Message){
      print('[Server.callbackReadIsolateListener]: wrong message $message');
      return;
    }
    switch(message.getType()){
      case MessageTypes.sendPort:{
        var msg = message as MessageSendPort;
        _callerPort = msg.port;
        break;
      }
      default:{
        print('Unhandled message: ${message.getType()}');
      }
    }
  }
}