import 'dart:async';
import 'dart:isolate';
import 'dart:mirrors';
import 'package:cim_server_2/src/http/application_channel.dart';

import 'messages.dart';
import 'http_reader_writer.dart';

class Server<T extends ApplicationChannel>{
  static final servers = List<Server>.empty(growable: true);
  Function(Server)? onInit;
  Server(this._host, this._port){
    _id = servers.length;
  }
  int _id = 0;
  final String _host;
  final int _port;
  String get host => _host;
  int get port => _port;
  late Isolate _readIsolate;
  late SendPort _readPort;
  late StreamSubscription _subscription;
//  static Future<Server> onInit(Server server) async {return server;}
    Future start ({int count = 2, Duration? timeout}) async{
      timeout ??= Duration(seconds: 30);
      var type = reflectType(T).reflectedType;
      var callerPort = ReceivePort();
      var initMessage = MessageInitServer(callerPort.sendPort, count, host, port, servers.length, type, timeout);
      _readIsolate = await Isolate.spawn<MessageInitServer>(HttpReaderWriter.readIsolateEntryPoint, initMessage);
      _subscription = callerPort.listen(callbackReadIsolateListener);
      servers.add(this);
//      _readIsolate.resume(_readIsolate.pauseCapability);
  }


  static void callbackReadIsolateListener(dynamic message){
    if(message is! Message){
      print('[Server.callbackReadIsolateListener]: wrong message $message');
      return;
    }
    switch(message.getType()){
      case MessageTypes.sendPort:{
        var msg = message as MessageSendPort;
        var server = servers[msg.id];
        server._readPort = msg.port;
        if(server.onInit != null) {
          server.onInit!(server);
        }
        break;
      }
      default:{
        print('Unhandled message: ${message.getType()}');
      }
    }
  }
}

