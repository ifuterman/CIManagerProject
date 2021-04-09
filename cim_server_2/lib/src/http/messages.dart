import 'dart:io';
import 'dart:isolate';

enum MessageTypes{
  empty,
  sendPort,
  request,
  initServer,
  serverInited,
  initHttpProcessor
}
abstract class Message{
  MessageTypes getType();
  int get id => _id;
  int _id;
  Message(this._id);
}

class MessageSendPort extends Message{
  SendPort port;
  MessageSendPort(this.port, int id):super(id);
  @override
  MessageTypes getType() => MessageTypes.sendPort;
}

class MessageInitServer extends Message{
  int threadsCount;
  String host;
  int serverPort;
  SendPort callerPort;
  Type applicationChannel;
  MessageInitServer( this.callerPort,this.threadsCount, this.host, this.serverPort, int id, this.applicationChannel):super(id);
  @override
  MessageTypes getType() => MessageTypes.initServer;
}

class MessageServerInited extends Message{
  MessageServerInited(int id):super(id);
  MessageTypes getType() => MessageTypes.serverInited;
}

class MessageInitHttpProcessor extends Message{
  MessageInitHttpProcessor(int id):super(id);
  MessageTypes getType() => MessageTypes.initHttpProcessor;
}

class MessageHttpRequest extends Message{
  MyHttpRequest request;
  MessageHttpRequest(this.request, int id):super(id);


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