import 'dart:async';
import 'dart:isolate';
import 'dart:mirrors';

import 'package:alfred/alfred.dart';
import 'package:cim_server_2/src/http/request.dart';
import 'package:cim_server_2/src/http/messages.dart';
import 'package:cim_server_2/src/http/router.dart';

import 'application_channel.dart';

class HttpProcessor{
  static SendPort? callerPort;
  static int id = -1;
  static ReceivePort? receivePort;
  static StreamSubscription? subscription;
  static ApplicationChannel? channel;
  static Router? router;
  static void processorEntryPoint(MessageInitHttpProcessor message) async{

    var channelType = message.applicationChannel;
    try{
      var mirror = reflectClass(channelType);
      var instanceMirror = mirror.newInstance(Symbol.empty, List.empty());
      channel = instanceMirror.reflectee as ApplicationChannel;
      if(channel != null){
        channel!.prepare();
        router = channel!.getEndpoint();
      }
    }
    catch(e){
      channel = null;
      print(e);
      //TODO:добавить обработчик ошибок
    }
    if(channel == null){
      callerPort!.send(MessageHttpProcessorInitError(id));
      return;
    }
    callerPort = message.callerPort;
    id = message.id;
    var receivePort = ReceivePort();
    subscription = receivePort.listen(listener);
    var messageInited = MessageHttpProcessorInited(id, receivePort.sendPort);
    callerPort!.send(messageInited);
  }
  static Future listener(dynamic message) async{
    if(message is! Message){
      print('[Server.callbackReadIsolateListener]: wrong message $message');
      return;
    }
    print('[HttpProcessor.listener] received message: ${message.getType().toString()}');
    switch(message.getType()){
      case MessageTypes.request:{
        message = message as MessageHttpRequest;
        unawaited(processRequest(message.request));
        break;
      }
      default:{
        print('Unhandled message: ${message.getType()}');
      }
    }
  }
  static Future processRequest(Request request) async{
    print('[HttpProcessor.processRequest] request received:${request.uri}');
/*    var headers = request.headers;
    var contentType = headers[HttpHeaders.contentTypeHeader];
    if(contentType != null && (contentType.isEmpty || contentType[0] != 'application/json')){
      var response = Response.badRequest(body: Body.fromString('content type is null'));
      var message = MessageHttpResponse(response, id);
      callerPort!.send(message);
      return;
    }*/
    var response = router!.processRequest(request);
    var responseMessage = MessageHttpResponse(response, id);
    callerPort!.send(responseMessage);
    callerPort!.send(MessageHttpProcessorReady(id));
  }
}