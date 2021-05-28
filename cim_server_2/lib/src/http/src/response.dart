import 'dart:io';

import 'body.dart';
import 'request_or_response.dart';

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
  Response.conflict({Body? body}):status = HttpStatus.conflict{
    body ??= Body.empty();
    this.body = body;
  }
  Response.forbidden({Body? body}):status = HttpStatus.forbidden{
    body ??= Body.empty();
    this.body = body;
  }
  Response.unauthorized({Body? body}):status = HttpStatus.unauthorized{
    body ??= Body.empty();
    this.body = body;
  }
}