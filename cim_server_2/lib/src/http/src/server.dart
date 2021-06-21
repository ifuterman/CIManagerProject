import 'dart:async';
import 'dart:isolate';
import 'dart:mirrors';
import 'application_channel.dart';

import 'messages.dart';
import 'http_reader_writer.dart';

class Server<T extends ApplicationChannel>{
//  static final servers = List<Server>.empty(growable: true);
  static Server? _server;
//  late SendPort sendPort;
  Function()? onInit;
  Server(this._host, this._port);
  /*Server(this._host, this._port){
    _id = servers.length;
  }*/
//  int _id = 0;
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
      var initMessage = MessageInitServer(callerPort.sendPort, count, host, port, 0, type, timeout);
      _readIsolate = await Isolate.spawn<MessageInitServer>(HttpReaderWriter.readIsolateEntryPoint, initMessage);
      _subscription = callerPort.listen(callbackReadIsolateListener);
      _server = this;
//      servers.add(this);
//      return servers.length;
//      _readIsolate.resume(_readIsolate.pauseCapability);
  }

  Future stop() async{
//      _readIsolate.kill();
    _readPort.send(MessageStopServer(0));
    await _subscription.cancel();
  }
  static void callbackReadIsolateListener(dynamic message){
    if(message is! Message){
      print('[Server.callbackReadIsolateListener]: wrong message $message');
      return;
    }
    switch(message.getType()){
      case MessageTypes.sendPort:{
        var msg = message as MessageSendPort;
        _server!._readPort = msg.port;
        if(_server!.onInit != null) {
          _server!.onInit!();
        }
        break;
      }
      default:{
        print('Unhandled message: ${message.getType()}');
      }
    }
  }
}

