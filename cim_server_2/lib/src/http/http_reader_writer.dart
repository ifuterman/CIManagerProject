import 'dart:collection';

import 'package:alfred/alfred.dart';
import 'package:cim_server_2/src/http/http_processor.dart';
import 'package:cim_server_2/src/http/response.dart';

import 'body.dart';
import 'request.dart';
import 'messages.dart';
import 'dart:io';
import 'dart:isolate';
class SendPortId{
  int id;
  SendPort port;

  SendPortId(this.id, this.port);
}
class HttpReaderWriter{
  static SendPort? _callerPort;
  static int _id = 0;
  static List<Isolate> processors = List.empty(growable: true);
  static Map<int, SendPort> processorPorts = {};
  static Queue<HttpRequest> requestQueue = Queue();
  static Queue<SendPortId> processorsQueue = Queue();
  static Map<int, HttpRequest> httpRequestsMap = {};
  static HttpServer? server;
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
    try {
      server = await HttpServer.bind(
          messageInitServer.host, messageInitServer.serverPort);
    }catch(e){
      server = null;
    }
    if(server == null) {
      for(var i; i < processors.length; i++){
        processors[i].kill();
      }
      _callerPort!.send(MessageServerInitError(_id));
      return;
    }
    server!.listen(requestHandler);
    _callerPort!.send(MessageServerInited(_id));
    receivePort.listen(mainProcessListener);
  }

  static void httpProcessorListener(Message message)async{

  }

  static Future requestHandler(HttpRequest httpRequest) async{
    print('[HttpRequest received: ${httpRequest.uri}]');
    requestQueue.add(httpRequest);
    unawaited (processRequest());
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
        processorsQueue.add(SendPortId(msg.id, msg.sendPort));
        break;
      }
      case MessageTypes.processorReady:{
        message = message as MessageHttpProcessorReady;
        var port = processorPorts[message.id];
        if(port == null){
          print('[HttpReaderWriter.mainProcessListener]SendPort is null!');
          break;
        }
        processorsQueue.add(SendPortId(message.id,port));
        unawaited(processRequest());
        break;
      }
      case MessageTypes.httpResponse:{
        message = message as MessageHttpResponse;
        unawaited(processResponse(message.id, message.response));
        break;
      }
      default:{
        print('Unhandled message: ${message.getType()}');
      }
    }
  }
  static Future processRequest() async{
    if(processorsQueue.isEmpty){
      return;
    }
    if(requestQueue.isEmpty){
      return;
    }
    var sendPortId = processorsQueue.removeFirst();
    var httpRequest = requestQueue.removeFirst();
    var request = await Request.prepare(httpRequest);
    httpRequestsMap[sendPortId.id] = httpRequest;
    var message = MessageHttpRequest(request, _id);
    sendPortId.port.send(message);
  }
  static Future processResponse(int id, Response response) async{
    var httpRequest = httpRequestsMap.remove(id);;
    if(httpRequest == null){
      return;
    }
    var httpResponse = httpRequest.response;
    var headers = response.headers;
    var keys = headers.keys;
    for(var key in keys){
      var value = headers[key];
      if(value == null){
        continue;
      }
      httpResponse.headers.set(key, value);
    }
    httpResponse.statusCode = response.status;
    var body = response.body;
    if(body.rawBody.isNotEmpty) {
      switch(response.body.type){
        case BodyTypes.text:
          httpResponse.headers.contentType = ContentType.text;
          httpResponse.write(body.asString());
          break;
        case BodyTypes.json:
          httpResponse.headers.contentType = ContentType.json;
          httpResponse.write(body.asJsonMap());
          break;
        case BodyTypes.raw:
          httpResponse.headers.contentType = ContentType.binary;
          httpResponse.write(body.rawBody);
          break;
        case BodyTypes.empty:
          break;
      }

    }
    await httpResponse.close();
  }
}