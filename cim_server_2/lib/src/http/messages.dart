import 'dart:isolate';

import 'package:cim_server_2/src/http/response.dart';

import 'request.dart';

enum MessageTypes{
  empty,
  sendPort,
  request,
  initServer,
  serverInited,
  serverInitError,
  initHttpProcessor,
  httpProcessorInited,
  httpProcessorInitError,
  processorReady,
  httpResponse
}
abstract class Message{
  MessageTypes getType();
  int get id => _id;
  final int _id;
  Message(this._id);
}

class MessageSendPort extends Message{
  SendPort port;
  MessageSendPort(this.port, int id):super(id);
  @override
  MessageTypes getType() => MessageTypes.sendPort;
}

class MessageInitServer extends Message{
  Duration timeout;
  int threadsCount;
  String host;
  int serverPort;
  SendPort callerPort;
  Type applicationChannel;
  MessageInitServer( this.callerPort,this.threadsCount, this.host, this.serverPort, int id, this.applicationChannel, this.timeout):super(id);
  @override
  MessageTypes getType() => MessageTypes.initServer;
}

class MessageServerInited extends Message{
  MessageServerInited(int id):super(id);
  @override
  MessageTypes getType() => MessageTypes.serverInited;
}

class MessageServerInitError extends Message{
  MessageServerInitError(int id):super(id);
  @override
  MessageTypes getType() => MessageTypes.serverInitError;
}

class MessageInitHttpProcessor extends Message{
  MessageInitHttpProcessor(int id, this.callerPort, this.applicationChannel):super(id);
  @override
  MessageTypes getType() => MessageTypes.initHttpProcessor;
  SendPort callerPort;
  Type applicationChannel;
}

class MessageHttpRequest extends Message{
  Request request;
  MessageHttpRequest(this.request, int id):super(id);


  @override
  MessageTypes getType() => MessageTypes.request;
}

class MessageHttpProcessorInited extends Message{
  @override
  MessageTypes getType() => MessageTypes.httpProcessorInited;
  SendPort sendPort;
  MessageHttpProcessorInited(int id, this.sendPort):super(id);
}

class MessageHttpProcessorInitError extends Message{
  @override
  MessageTypes getType() => MessageTypes.httpProcessorInited;
  MessageHttpProcessorInitError(int id):super(id);
}

class MessageHttpProcessorReady extends Message{
  @override
  MessageTypes getType() => MessageTypes.processorReady;
  MessageHttpProcessorReady(int id):super(id);
}

class MessageHttpResponse extends Message{
  Response response;
  @override
  MessageTypes getType() => MessageTypes.httpResponse;
  MessageHttpResponse(this.response, int id):super(id);
}