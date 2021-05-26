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
    var charSize = 2;
    if(request.contentLength > 0){
      rawBody = await request.first;
      if(request.contentLength == rawBody.length){
        charSize = 1;
      }
    }

    rawBody ??=  Uint8List(0);
    return Request(headers, method, requestedUri, uri, Body(rawBody, charSize));
  }
  HttpHeaders headers;
  String method;
  Uri requestedUri;
  Uri uri;
  Body body;
  Request(this.headers, this.method, this.requestedUri, this.uri, this.body);
}