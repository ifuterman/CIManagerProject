import 'dart:io';
import 'dart:isolate';

enum MessageTypes{
  empty,
  sendPort,
  request,
  initServer
}
abstract class Message{
  MessageTypes getType();
}

class MessageSendPort implements Message{
  SendPort port;
  MessageSendPort(this.port);
  @override
  MessageTypes getType() => MessageTypes.sendPort;
}

class MessageInitServer implements Message{
  int threadsCount;
  String host;
  int serverPort;
  SendPort callerPort;
  MessageInitServer( this.callerPort,this.threadsCount, this.host, this.serverPort);

  @override
  MessageTypes getType() => MessageTypes.initServer;
}

class MessageHttpRequest implements Message{
  MyHttpRequest request;
  MessageHttpRequest(this.request);


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