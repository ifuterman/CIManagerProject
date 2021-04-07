import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'messages.dart';

class Server{
  String _host;
  int _port;
  int _threadsConut;
  Server._(this._host, this._port, this._threadsConut, this._readIsolate);
  String get host => _host;
  int get port => _port;
  Isolate _readIsolate;
  static Future<Server?> start (String host, int port, [int count = 2]) async{
    var callerPort = ReceivePort();
    var initMessage = MessageInitServer(callerPort.sendPort, count, host, port);
    var readIsolate = await Isolate.spawn(readIsolateEntryPoint, initMessage);
    SendPort? readPort;
    await for(Message message in callerPort){
      if(message.getType() == MessageTypes.sendPort){
        readPort = (message as MessageSendPort).port;
        break;
      }
    }
    if(readPort == null){
      return null;
    }
    readPort.send(1);
    // SendPort sp = await callerPort.first;

//    readIsolate.controlPort.send(1);
    var server = Server._(host, port, count, readIsolate);
    return server;
  }
}

void readIsolateEntryPoint(MessageInitServer messageInitServer) async{
  var receivePort = ReceivePort();//Регистрация порта для приёмки сообщений
  messageInitServer.callerPort.send(MessageSendPort(receivePort.sendPort));//Передача порта, через который будем получать сообщения
  var server = await HttpServer.bind(messageInitServer.host, messageInitServer.serverPort);
  receivePort.listen(handler);
}

void handler(dynamic message){
  print('Message received');
}