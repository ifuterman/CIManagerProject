import 'dart:io';

import 'dart:typed_data';

import 'package:cim_server_2/src/http/body.dart';
import 'package:cim_server_2/src/http/request_or_response.dart';

class Request implements RequestOrResponse{
  static Future<Request> prepare(HttpRequest request) async{
    var headers = request.headers;
    var method = request.method;
    var requestedUri = request.requestedUri;
    var uri = request.uri;
    var rawBody = request.contentLength > 0 ? await request.first : Uint8List(0);
    return Request(headers, method, requestedUri, uri, Body(rawBody));
  }
  HttpHeaders headers;
  String method;
  Uri requestedUri;
  Uri uri;
  Body body;
  Request(this.headers, this.method, this.requestedUri, this.uri, this.body);
}