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
    var body = await Body.makeBody(request);
    return Request(headers, method, requestedUri, uri, body);
  }
  HttpHeaders headers;
  String method;
  Uri requestedUri;
  Uri uri;
  Body body;
  Request(this.headers, this.method, this.requestedUri, this.uri, this.body);
}