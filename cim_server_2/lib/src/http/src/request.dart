import 'dart:io';

import 'dart:typed_data';

import 'body.dart';
import 'request_or_response.dart';

class Request implements RequestOrResponse{
  static Future<Request> prepare(HttpRequest request) async{
    var headers = request.headers;
    var method = request.method;
    var requestedUri = request.requestedUri;
    var uri = request.uri;
    Uint8List? rawBody;
    var charSize = 1;
/*    request.listen((event) {
      print('$event');});*/
    if(request.contentLength != 0){
      try {
        rawBody = await request.first;
/*        if (request.contentLength == rawBody.length) {
          charSize = 1;
        }*/
      }catch(e){
        print('Exception int Request.prepare. Can`t read body');
        rawBody = null;
      }
    }
    var type = BodyTypes.raw;
    if(headers.contentType == ContentType.json)
    {
      if(headers.contentType == ContentType.json){
        type = BodyTypes.json;
      }
      else if(headers.contentType == ContentType.text){
        type = BodyTypes.text;
      }
      if(rawBody != null && rawBody.isEmpty){
        type = BodyTypes.empty;
      }
    }
    rawBody ??=  Uint8List(0);
    return Request(headers, method, requestedUri, uri, Body(rawBody,type, charSize));
  }
  HttpHeaders headers;
  String method;
  Uri requestedUri;
  Uri uri;
  Body body;
  Request(this.headers, this.method, this.requestedUri, this.uri, this.body);
}