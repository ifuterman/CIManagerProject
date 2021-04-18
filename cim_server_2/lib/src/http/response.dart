import 'dart:io';

import 'package:cim_server_2/src/http/body.dart';
import 'package:cim_server_2/src/http/request_or_response.dart';

class Response implements RequestOrResponse{
  int status;
  late Body body;
  Map<String, String> headers = {};
  Response(this.status, Body? body){
    body ??= Body.empty();
    this.body = body;
  }
  Response.badRequest({Body? body}):status = HttpStatus.badRequest{
    body ??= Body.empty();
    this.body = body;
  }
  Response.internalServerError({Body? body}):status = HttpStatus.internalServerError{
    body ??= Body.empty();
    this.body = body;
  }
  Response.notFound({Body? body}):status = HttpStatus.notFound{
    body ??= Body.empty();
    this.body = body;
  }
  Response.ok({Body? body}):status = HttpStatus.ok{
    body ??= Body.empty();
    this.body = body;
  }
  Response.requestTimeout({Body? body}):status = HttpStatus.serviceUnavailable{
    body ??= Body.empty();
    this.body = body;
  }
}