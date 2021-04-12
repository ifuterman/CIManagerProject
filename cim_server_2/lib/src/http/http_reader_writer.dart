import 'dart:collection';
import 'dart:mirrors';

import 'package:alfred/alfred.dart';
import 'package:cim_server_2/src/http/application_channel.dart';
import 'package:cim_server_2/src/http/http_processor.dart';

import 'request.dart';
import 'messages.dart';
import 'dart:io';
import 'dart:isolate';

class HttpReaderWriter{
  static SendPort? _callerPort;
  static int _id = 0;
  static List<Isolate> processors = List.empty(growable: true);
  static Map<int, SendPort> processorPorts = {};
  static Queue<Request> requestQueue = Queue();
  static Queue<SendPort> processorsQueue = Queue();
  static void readIsolateEntryPoint(MessageInitServer messageInitServer) async {
    var channelType = messageInitServer.applicationChannel;
    _id = messageInitServer.id;
    var receivePort = ReceivePort(); //Регистрация порта для приёмки сообщений
    _callerPort = messageInitServer.callerPort;
/*    _callerPort!.send(MessageSendPort(receivePort.sendPort,
        _id)); //Передача порта, через который будем получать сообщения*/
    for(var i = 0; i < messageInitServer.threadsCount; i++){
      var processorMessage = MessageInitHttpProcessor(i, receivePort.sendPort, channelType);
      var isolate = await Isolate.spawn<MessageInitHttpProcessor>(HttpProcessor.processorEntryPoint, processorMessage);
      processors.add(isolate);
    }
    var server = await HttpServer.bind(
        messageInitServer.host, messageInitServer.serverPort);

    server.listen(requestHandler);
    _callerPort!.send(MessageServerInited(_id));
    receivePort.listen(mainProcessListener);
  }

  static void httpProcessorListener(Message message)async{

  }

  static Future requestHandler(HttpRequest httpRequest) async{
    print('[HttpRequest received: ${httpRequest.uri}]');
    var request = await Request.prepare(httpRequest);
    requestQueue.add(request);
    unawaited (processRequest());
  }

  static Future processRequest() async{
    if(processorsQueue.isEmpty){
      return;
    }
    if(requestQueue.isEmpty){
      return;
    }
    var port = processorsQueue.removeFirst();
    var request = requestQueue.removeFirst();
    var message = MessageHttpRequest(request, _id);
    port.send(message);
  }

  static Future mainProcessListener(dynamic message) async{
    if(message is! Message){
      print('[Server.callbackReadIsolateListener]: wrong message $message');
      return;
    }
    print('[HttpReaderWriter.mainProcessListener] received message: ${message.getType().toString()}');
    switch(message.getType()){
      case MessageTypes.sendPort:{
        var msg = message as MessageSendPort;
        _callerPort = msg.port;
        break;
      }
      case MessageTypes.httpProcessorInited:{
        var msg = message as MessageHttpProcessorInited;
        processorPorts[msg.id] = msg.sendPort;
        processorsQueue.add(msg.sendPort);
        break;
      }
      case MessageTypes.processorReady:{
        message = message as MessageHttpProcessorReady;
        var port = processorPorts[message.id];
        if(port == null){
          print('[HttpReaderWriter.mainProcessListener]SendPort is null!');
          break;
        }
        processorsQueue.add(port);
        unawaited(processRequest());
        break;
      }
      default:{
        print('Unhandled message: ${message.getType()}');
      }
    }
  }
}