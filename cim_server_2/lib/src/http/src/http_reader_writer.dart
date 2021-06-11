import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'http_processor.dart';
import 'response.dart';

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
  static Duration requestTimeout = Duration(seconds: 30);//Timeout for processing http request
  static Duration processorTimeout = Duration(minutes: 20);//Timeout for completing processor isolate working cycle for processing 1 request
  static SendPort? _callerPort;
  static int _id = 0;
  static List<Isolate> processors = List.empty(growable: true);
  static Map<int, SendPort> processorPorts = {};
//  static Queue<HttpRequest> requestQueue = Queue();
  static Queue<MapEntry<HttpRequest, Timer>> requestQueue = Queue();
  static Queue<SendPortId> processorsQueue = Queue();
//  static Map<int, HttpRequest> httpRequestsMap = {};
  static Map<int, MapEntry<HttpRequest, Timer>> httpRequestsMap = {};
  static Map<int, Timer> timeoutMap = {};
  static HttpServer? server;
  static Type? channelType;
  static ReceivePort? receivePort;
  static void readIsolateEntryPoint(MessageInitServer messageInitServer) async {
    channelType = messageInitServer.applicationChannel;
    _id = messageInitServer.id;
    receivePort = ReceivePort(); //Регистрация порта для приёмки сообщений
    _callerPort = messageInitServer.callerPort;
    requestTimeout = messageInitServer.timeout;
    processorTimeout = requestTimeout * 10;
/*    _callerPort!.send(MessageSendPort(receivePort.sendPort,
        _id)); //Передача порта, через который будем получать сообщения*/
    for(var i = 0; i < messageInitServer.threadsCount; i++){
      var isolate = await _spawn(i);
      processors.add(isolate);
    }
    try {
      /*server = await HttpServer.bind(
          messageInitServer.host, messageInitServer.serverPort);*/
      server = await HttpServer.bind(
          InternetAddress.anyIPv4, messageInitServer.serverPort);
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
    receivePort!.listen(mainProcessListener);
  }
  static Future<Isolate> _spawn(int id) async{
    var processorMessage = MessageInitHttpProcessor(id, receivePort!.sendPort, channelType!);
    var isolate = await Isolate.spawn<MessageInitHttpProcessor>(HttpProcessor.processorEntryPoint, processorMessage);
    return isolate;
  }
  /*static void httpProcessorListener(Message message)async{

  }*/

  static Future requestHandler(HttpRequest httpRequest) async{
    print('[HttpRequest received: ${httpRequest.uri}], contentLength = ${httpRequest.contentLength}');
    var timer = Timer(requestTimeout, ()=>httpRequestTimeout(httpRequest));
    var entry = MapEntry(httpRequest, timer);
//    requestQueue.add(httpRequest);
    requestQueue.add(entry);
    await processRequest();
  }
  static void httpRequestTimeout(HttpRequest request){
    print('[HttpReaderWriter.httpRequestTimeout]');
    /*if(requestQueue.contains(requestEntry)){//If request in requestQueue, it has not been processed yet

      requestQueue.remove(requestEntry);
    }*/
    var entries = requestQueue.toList();
    MapEntry<HttpRequest, Timer>? requiredEntry;
    for(var entry in entries){
      if(entry.key == request)
        {
          requiredEntry = entry;
          break;
        }
    }
    if(requiredEntry != null){
      requestQueue.remove(requiredEntry);
    }
    else {
      var id = -1;
      for (var mapEntry in httpRequestsMap.entries) {
        if (mapEntry.value.key == request) {
          id = mapEntry.key;
          requiredEntry = mapEntry.value;
          break;
        }
      }
      if(id < 0){
        return;
      }
      httpRequestsMap.remove(id);
    }
    sendResponse(requiredEntry!.key.response, Response.requestTimeout());
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
        var timer = timeoutMap[message.id];
        if(timer != null){
          timer.cancel();
        }
        var port = processorPorts[message.id];
        if(port == null){
          print('[HttpReaderWriter.mainProcessListener]SendPort is null!');
          break;
        }
        processorsQueue.add(SendPortId(message.id,port));
        await processRequest();
        break;
      }
      case MessageTypes.httpResponse:{
        message = message as MessageHttpResponse;
        var timer = timeoutMap[message.id];
        if(timer != null){
          timer.cancel();
        }
        await processResponse(message.id, message.response);
        break;
      }
      case MessageTypes.stopServer:{
        await server!.close();
        receivePort!.close();
        for(var port in processorPorts.values){
          port.send(MessageStopServer(0));
        }
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
    var entry = requestQueue.removeFirst();
    var httpRequest = entry.key;
    var request = await Request.prepare(httpRequest);
    httpRequestsMap[sendPortId.id] = entry;
    var message = MessageHttpRequest(request, _id);
    timeoutMap[sendPortId.id] = Timer(processorTimeout, ()=>processorTimeoutCallback(sendPortId.id));
    sendPortId.port.send(message);
  }
  static void processorTimeoutCallback(int id) async{
    print('[HttpReaderWriter.processorTimeoutCallback]');
    var isolate = processors[id];
    isolate.kill(priority: Isolate.immediate);
    isolate = await _spawn(id);
    processors[id] = isolate;
  }
  static Future processResponse(int id, Response response) async{
    var entry = httpRequestsMap.remove(id);
    if(entry == null){
      return;
    }
    entry.value.cancel();
    var httpRequest = entry.key;
    print('response=> status: ${response.status}, body: ${response.body.asJsonMap()}');
    await sendResponse(httpRequest.response, response);
  }
  static Future sendResponse(HttpResponse httpResponse, Response response)async{
    try{
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
      switch(response.body.type){
        case BodyTypes.text:
          httpResponse.headers.contentType = ContentType.text;
          var str = body.asString();
          httpResponse.write(str);
          break;
        case BodyTypes.json:
          httpResponse.headers.contentType = ContentType.json;
          var str = body.asString();
          httpResponse.write(str);
          break;
        case BodyTypes.raw:
          httpResponse.headers.contentType = ContentType.binary;
          httpResponse.write(body.rawBody);
          break;
        case BodyTypes.empty:
          httpResponse.headers.contentType = ContentType.text;
          break;
      }
      print('Response sent. StatusCode = ${httpResponse.statusCode}');
      await httpResponse.close();
    }catch(e){print('Exception in sendResponse: $e');}
  }
}